To allow `scripts/` to be used as logstash pipeline, run the\
following command: 

```shell
docker run --rm -it\
  -v $(pwd):/work \ 
  -v $(pwd)/scripts/:/etc/logstash/conf.d \ 
  logstash \
  bash
```

