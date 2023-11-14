## Deploy ACT

Deploy ACR separately before deploying ACI. This allows us to push image to ACR first.

```shell
cd acr
terraform init -upgrade
terraform apply -auto-approve
```


## Pushing Docker image to ACR

```shell
export IMAGE_TAG="my-tag"
export NAMESPACE="mynamespace"

# login az
az login
az acr login --name <registryName>

# push image to ACR
az acr build -t $NAMESPACE/$IMAGE_TAG:latest -r <registryName> .
```

## Deploy ACI using our ACR's Image

First we retrieve the admin username and password for deployment
```shell
az acr credential show --name <registryName>
# find username and password.value
```

Then deploy the terraform ACI:

```shell
cd aci
terraform apply -auto-approve
# provide username and password
```

## Access ACI shell

Use AZ CLI to access the container shell

```shell
az container exec --exec-command "bash" -g <resourceGroup> --name <containerName>
```
