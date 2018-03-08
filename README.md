# Dev Image for Kubernetes
1. Run ```make build``` to build the image
2. Add your public ssh key to ```authorized_keys```
2. Run ```generateHostKeys.sh``` to generate new ssh keys
3. Run ```updateKeys.sh``` to upload the keys to k8 configmap
4. Run ```make deploy``` to deploy the 'dev' image to K8
5. Login to the container with ```ssh root@dev-container```

Whenever you want to add/remove keys

1. Edit authorized_keys
2. Run updateKeys.sh
