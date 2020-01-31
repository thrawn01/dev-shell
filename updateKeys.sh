#!/bin/sh
NAMESPACE=default

# Update the keys stored in ssh.yaml from the authorized-keys file
kubectl --namespace $NAMESPACE delete secret ssh-keys
kubectl --namespace $NAMESPACE create secret generic ssh-keys --from-file=./ssh-config/authorized_keys
