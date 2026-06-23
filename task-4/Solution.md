# Task 4: RBAC

## Where to look

- `kubectl get pods -n task-4`
- `kubectl logs <pod> -n task-4 -c endpoint-watcher`
- `kubectl get networkpolicy -n task-4 -o yaml`
- `kubectl get namespace kube-system --show-labels`
- `kubectl get pods -n kube-system --show-labels`
- `kubectl get role,rolebinding -n default`

## Solution

Three independent, layered bugs:

- Permission denied listing Endpoints

```bash
klg -n task-4 deploy/api-watcher -f
Found 2 pods, using pod/api-watcher-5f7bfcc4cf-x4c6p
{
  "kind": "Status",
  "apiVersion": "v1",
  "metadata": {},
  "status": "Failure",
  "message": "endpoints is forbidden: User \"system:serviceaccount:task-4:task-4-api-watcher\" cannot list resource \"endpoints\" in API group \"\" in the namespace \"default\"",
  "reason": "Forbidden",
```

- Check RoleBindings in `default` namespace

```bash
kg rolebinding -n default
NAME                              ROLE                           AGE
kubernikus:member                 ClusterRole/edit               18h
task-4-endpoints-reader-binding   Role/task-4-endpoints-reader   16m

kg rolebinding -n default task-4-endpoints-reader-binding -o yaml
...
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: task-4-endpoints-reader
```

- Check corresponding Role

```bash
kg role -n default task-4-endpoints-reader -o yaml
...
rules:
- apiGroups:
  - ""
  resources:
  - endpoints
  verbs:
  - get
```

- Add necessary verb - `k edit role -n default task-4-endpoints-reader`

```bash
  verbs:
  - get
  - list
```
