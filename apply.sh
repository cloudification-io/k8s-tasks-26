#!/bin/bash

## Install cert-manager
helm upgrade --install task-5 jetstack/cert-manager -n task-5 --create-namespace --set crds.enabled=true

sleep 10
## Label nodes

nodes=($(kubectl get nodes -o jsonpath='{.items[*].metadata.name}'))

count=${#nodes[@]}
target=$(( (count * 2 + 2) / 3 )) # round up 2/3

for node in "${nodes[@]:0:$target}"; do
  kubectl label node "$node" disktype=ssd --overwrite
done

## Install network policies
# helm repo add cilium https://helm.cilium.io
# helm repo update

# helm upgrade --install cilium cilium/cilium \
#   -n kube-system \
#   --set cni.chainingMode=flannel \
#   --set cni.exclusive=false \
#   --set enableIPv4Masquerade=true \
#   --set policyEnforcementMode=default


## Apply all manifests


for folder in $(ls )
do
    kubectl apply -f $folder/manifests
done


sleep 2
kubectl scale deploy/validator -n task-6-webhook --replicas=0
