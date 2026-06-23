# Task 1 - Solution

## Where to look

- `kubectl get pods -n task-1 -o wide`
- `kubectl describe pod <pending-pod> -n task-1` - read the `Events` section
- `kubectl get nodes --show-labels`

```bash
:kgp -n task-1
NAME                   READY   STATUS    RESTARTS   AGE   IP             NODE                          NOMINATED NODE   READINESS GATES
web-846c8c649f-9pwdr   1/1     Running   0          34m   100.100.14.7   kks-kluster-04-pool-1-8kbvm   <none>           <none>
web-846c8c649f-n9j2f   0/1     Pending   0          34m   <none>         <none>                        <none>           <none>
web-846c8c649f-xwfh9   1/1     Running   0          34m   100.100.13.6   kks-kluster-04-pool-1-2rmbb   <none>           <none>
```

```bash
kg deploy -n task-1 web -o yaml
apiVersion: apps/v1
kind: Deployment
...
      nodeSelector:
        disktype: ssd
```

## Solution

The third node is missing the `disktype=ssd` label required by the
Deployment's `nodeSelector`. Label it:

```bash
kubectl get nodes --show-labels
kubectl label node <unlabeled-node> disktype=ssd
```

All 3 Pods reach `Running`.
