# Task 2 - Solution

## Where to look

- `kubectl get pods -n task-2`
- `kubectl logs <pod> -n task-2 -c wait-for-dns`
- `kubectl logs <pod> -n task-2 -c wait-for-api`
- `kubectl logs <pod> -n task-2 -c endpoint-watcher`
- `kubectl get networkpolicy -n task-2 -o yaml`
- `kubectl get namespace kube-system --show-labels`
- `kubectl get pods -n kube-system --show-labels`
- `kubectl get role,rolebinding -n default`

## Solution

2 Network Policy misconfigurations:

```bash
klg -n task-2 api-watcher-5ff6bff46-4tr8k -c wait-for-dns
Server:		198.18.128.2
Address:	198.18.128.2:53

** server can't find kubernetes.svc.cluster.local: NXDOMAIN

** server can't find kubernetes.cluster.local: NXDOMAIN

** server can't find kubernetes.task-2.svc.cluster.local: NXDOMAIN

** server can't find kubernetes.svc.cluster.local: NXDOMAIN

** server can't find kubernetes.task-2.svc.cluster.local: NXDOMAIN

** server can't find kubernetes.cluster.local: NXDOMAIN

** server can't find kubernetes.openstack.eu-de-1.cloud.sap: NXDOMAIN

** server can't find kubernetes.openstack.eu-de-1.cloud.sap: NXDOMAIN
DNS lookup to kubernetes timed out
```

- Check Network Policies

```bash
kg netpol -n task-2
NAME                   POD-SELECTOR      AGE
allow-dns              dns-access=true   39m
allow-kube-apiserver   <none>            39m
default-deny-egress    <none>            39m
```

- Check that correct label is applied

```bash
kg deploy -n task-2 api-watcher -o yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-watcher
  namespace: task-2
spec:
...
  template:
    metadata:
      labels:
        app: task-2-api-watcher
        dns: "true"
```

- Update Deployment label `dns: "true"` -> `dns-access: "true"`

- Check 2nd InitContainer

```bash
klg -n task-2 api-watcher-5ff6bff46-4tr8k -c wait-for-api
...
```

- Container cannot connect to kubernetes.default.svc - timeout
- Check 2nd network policy

```bash
$ kg netpol -n task-2 allow-kube-apiserver -o yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-kube-apiserver
  namespace: task-2
spec:
  egress:
  - ports:
    - port: 16443
      protocol: TCP
...
```

- Port looks wierd and needs to be changed to 443

```bash
kg svc -n default
NAME         TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE
kubernetes   ClusterIP   198.18.128.1   <none>        443/TCP   23h
```
