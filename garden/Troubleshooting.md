# Troubleshooting

## Access virtual CP (Seed/Shoot)

```bash
## 1. Make a port forwarding in necessary namespace
k port-forward svc/kube-apiserver 6443:443 &

## 2. Fetch kubeconfig
K8S_CONTEXT="eude1-01p"

kg secret gardener -o jsonpath='{.data.kubeconfig}' | base64 -d > ~/.kube/config_${K8S_CONTEXT}
sed -i.bk "s|server:.*|server: https://localhost:6443|gI"  ~/.kube/config_${K8S_CONTEXT}

## 3. Use tmp kubeconfig
export KUBECONFIG="~/.kube/config_${K8S_CONTEXT}"
unload_u8s
kg seed
```
