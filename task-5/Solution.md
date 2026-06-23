# Task 5: Upgrade Helm release

## Where to look

- `kubectl rollout status deployment/task-5-cert-manager -n task-5`
- `kubectl get pods -n task-5`
- `kubectl describe pod <pending-pod> -n task-5`
- `kubectl describe nodes` (check the `Allocated resources` section)
- `helm history task-5 -n task-5`

## Solution

- Perform upgrade

```bash
helm upgrade task-5 jetstack/cert-manager -n task-5 --reuse-values -f values-upgrade.yaml
```

- new Pods stuck in Pending

```bash
task-5-cert-manager-b5bd9b845-ckjc5               0/1     Pending   0          112s    <none>        <none>                        <none>           <none>
```

- Describe

```bash
kdp -n task-5 task-5-cert-manager-b5bd9b845-ckjc5
Name:             task-5-cert-manager-b5bd9b845-ckjc5

  ----     ------            ----  ----               -------
  Warning  FailedScheduling  74s   default-scheduler  0/3 nodes are available: 3 Insufficient memory. no new claims to deallocate, preemption: 0/3 nodes are available: 3 Preemption is not helpful for scheduling.
```

- 3 Insufficient memory

Fix the typo in `values-upgrade.yaml` (`512Gi` -> `512Mi`) and re-upgrade:

```bash
helm upgrade task-5 jetstack/cert-manager -n task-5 --reuse-values -f values-upgrade.yaml
kubectl rollout status deployment/task-5-cert-manager -n task-5
```
