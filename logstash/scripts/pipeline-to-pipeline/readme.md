
Logstash *Pipeline to Pipeline Communication* provides a simple way to construct Pipelines dependencies instead of relying on using external storages/ queues to maintain pipeline dependencies.

To create this type of communication, we need:
1. a "persistent" pipeline serves as a "Listener" pipeline
2. Send log events to the "Listener" pipeline
3. "Listener" pipeline distributed/ downstream to the next pipeline

---
## Design Patterns

Using pipelines communications allow us to construct different streaming patterns. From the documentation, this include:

- *distributor pattern* - publish different log streams to different pipelines to handle different transformation & ingestion processes
- *output isolator pattern* - publish the same log streams to different pipelines to ingest to different destination (this goes through the same transformation process)
- *forked path pattern* - publish the same log streams to different pipelines to perform different transformation processes to match the destinations' requirements
- *collector pattern* - subscribe to different pipelines, which aim to transform the log stream into a consistent schema, then uniformly ingest to one destination

---
## Setup Pipelines

In this example, we create a simple pub-sub pipelines:
- Pipeline `upstream-pipeline` publish to the virtual stage `stagingListener`
- Pipeline `downstream-pipeline` subscribe to the virtual stage `stagingListener`
- `[upstream]->(listenerChannel)<-[downstream]`


We first creates two pipelines configs:
- `/myPath/upstream-pipeline.conf` for the pipeline that publish the log streams
- `/myPath/downstream-pipeline.conf` for the pipeline that mutate and output it
- both of them points the same channel `listenerChannel`

```ruby
# /myPath/upstream-pipeline.conf
input {
    stdin { }
}

output {
	pipeline {
		id => "upstream"
		send_to => listenerChannel
	}
}
```

```ruby
# /myPath/downstream-pipeline.conf
input {
		# input is to listen from the staging server in logstash
    pipeline {
        address => listenerChannel
    }
}

filter {
    # add a field to acknowledge output from downstream pipelines
    mutate {
        add_field => { "from" => "downstream" }
    }
}

output {
	stdout {
        codec => rubydebug
    }
}
```


Then we need to run both the pipelines in our Node, there are two ways we can go about running two dependent pipelines. We can open two separate terminals and starts two config pipelines independently:

```shell
# in terminal #1 -> starts the downstream
logstash -f /myPath/upstream-pipeline.conf
# ...this output the events

# in termainal #2 -> starts the upstream
logstash -f /myPath/downstream-pipeline.conf
# ... this listen the events
```

Or more preferably, we can create a custom `pipelines.yml` and starts Logstash daemon, which it will starts all the defined pipelines:

```yml
# logstash uses this if running in daemon mode
# /usr/share/logstash/config/pipelines.yml
- pipeline.id: pipeline-upstream
  path.config: "/myPath/upstream-pipeline.conf"
  queue.type: persisted

- pipeline.id: pipeline-downstream
  path.config: "/myPath/downstream-pipeline.conf"
```

Then starts the Logstash daemon, which it will starts all the pipelines defined in the YAML:

```shell
logstash
# ... starts everything

# enter stdin
> my-awesome-log-stream
```

We can see that our logs has been processed and output correctly:

```shell
# output
my-awesome-log-stream
{
          "host" => {
        "hostname" => "77354d917467"
    },
    "@timestamp" => 2023-11-23T15:49:39.218553467Z,
          "from" => "downstream",
      "@version" => "1",
         "event" => {
        "original" => "my-awesome-log-stream"
    },
       "message" => "my-awesome-log-stream"
}
```

---
## ℹ️  Resources

- [Pipeline-to-pipeline communication | Logstash Reference [8.11] | Elastic](https://www.elastic.co/guide/en/logstash/8.11/pipeline-to-pipeline.html#distributor-pattern)
- [Logstash-to-Logstash communication | Logstash Reference [8.11] | Elastic](https://www.elastic.co/guide/en/logstash/8.11/ls-to-ls.html)
