# Include ENV given to us by K8 during pod creation
# If this file is missing an ENV pair it might not have been available when the pod was created.
# (See https://github.com/kubernetes/kubernetes/blob/f737ad62ed3e2af920319c01e9cfccaa19dc11f9/pkg/kubelet/kubelet_pods.go#L570-L573)
source /.k8-env

export GOROOT=/opt/golang/current
export GOPATH=/root/Development/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

# Initialize virtualenv and disable the prompt
export VIRTUAL_ENV_DISABLE_PROMPT=1
source ~/.venv/bin/activate
