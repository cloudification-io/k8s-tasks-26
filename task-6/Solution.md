# Task 6: solution

## Where to look

- Error on image update

```bash
kubectl -n task-6 set image deploy/app app=alpine:3.20

error: failed to patch image update to pod template: Internal error occurred: failed calling webhook "task-6.training.local": failed to call webhook: Post "https://validator.task-6-webhook.svc:443/validate?timeout=5s": no endpoints available for service "validator"
```

- Object is validated at `validator.task-6-webhook.svc` - namespace=task-6-webhook

```bash
$ kgp -n task-6-webhook
No resources found in task-6-webhook namespace.

$ kg deploy -n task-6-webhook
NAME        READY   UP-TO-DATE   AVAILABLE   AGE
validator   0/0     0            0           5h16m
```

- Validating controller is not running

## Solution

- Scale up validating controller

```bash
k scale deploy/validator -n task-6-webhook --replicas=1
```

- Update image afterwards

```bash

```
