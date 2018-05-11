.PHONY: build, all, deploy
.DEFAULT_GOAL := all

NAMESPACE=default

all:
	@echo "1. Run 'make build' to build the image"
	@echo "2. Add your public ssh key to 'authorized_keys'"
	@echo "2. Run 'generateHostKeys.sh' to generate new ssh keys"
	@echo "3. Run 'updateKeys.sh' to upload the keys to k8 configmap"
	@echo "4. Run 'make deploy' to deploy the 'dev' image to K8"
	@echo "5. Run 'kubectl port-forward \$$(kubectl get pod -l app=dev-shell -o jsonpath={.items[].metadata.name}) 2222:22'"
	@echo "6. Login to the container with 'ssh -p 2222 root@localhost' or 'ssh root@shell'"


build:
	@echo "# Run this command to ensure you are building against devgun docker:"
	@echo '# eval \$$(minikube docker-env)'
	docker build . -t dev-shell:latest

deploy:
	kubectl apply -n $(NAMESPACE) -f  dev-shell.yaml

