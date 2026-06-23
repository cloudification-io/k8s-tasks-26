# Task 6: Perform an image update

## Problem

You need to bump the `app` Deployment in `task-6` to a newer Alpine tag: `app=alpine:3.20`

```bash
kubectl -n task-6 set image <deployment> app=alpine:3.20
```

Ensure update passes

## Documentation

- [Kyverno - Validate Rules](https://kyverno.io/docs/policy-types/cluster-policy/validate/)
- [Kubernetes - Validating Admission Webhooks](https://kubernetes.io/docs/reference/access-authn-authz/extensible-admission-controllers/#validating-admission-webhook)
- [Debugging Pending/CrashLooping Pods](https://kubernetes.io/docs/tasks/debug/debug-application-cluster/debug-pods/)
