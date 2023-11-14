## Deploy ACT

1. deploy ACR separately before deploying ACI. This allows us to push image to ACR first.


## Pushing Docker image to ACR

```shell
export IMAGE_TAG="my-tag"


docker build -t $IMAGE_TAG .   # build the docker image

# login az
az login
az acr login --name <acrName>

# push image to ACR
export ACR_TAG="<acrLoginServer>/<nameSpace>/$IMAGE_TAG"
docker tag $IMAGE_TAG $ACR_TAG
docker push $ACR_TAG
```

## Deploy ACI using our ACR's Image
