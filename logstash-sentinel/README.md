`sample-log.json` is a sample DCR log for the sentinel table.

To use this container:

```shell
docker build -t logstash-sentinel .

docker run --rm -it\
  -v $(pwd):/work\
  logstash-sentinel\
  bash
```

Run in container:
```shell
logstash -f /work/scripts/<confName>.conf
```
