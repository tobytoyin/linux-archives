To allow `scripts/` to be used as logstash pipeline, run the\
following command:

```shell
docker run --rm -it\
  -v $(pwd):/work \
  logstash \
  bash
```
