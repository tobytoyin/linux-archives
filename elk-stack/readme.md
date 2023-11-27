```shell
docker run --rm --name logstash \
    -p 5044:5044 \
    -v $(pwd)/logstash-pipelines://usr/share/logstash/pipeline \
    -v $(pwd)/pipelines.yml:/usr/share/logstash/config/pipelines.yml\
    -v $(pwd)/logstash.yml:/usr/share/logstash/config/logstash.yml\
    docker.elastic.co/logstash/logstash:8.11.1  -f /etc/logstash/conf.d/hello-world.conf

```
