# Task 4: Troubleshoot network issues

## Problem

Pods in the `task-4` namespace are not becoming `Ready`. There are three
layered problems to find and fix, one at a time - fixing one will reveal the
next:

1. A Pod can't do DNS lookups.
2. Once DNS works, a Pod gets a timeout reaching the Kubernetes API server.
3. Once both of those work, the Pod's logs show it doesn't have enough
   permissions to list `Endpoints` in the `default` namespace.

## Goal

Inspect Pod logs in `task-4` namespace and investigate where errors come from

## Documentation

- [Network Policies](https://kubernetes.io/docs/concepts/services-networking/network-policies/)
- [Network Policies: Targeting a namespace by its name](https://kubernetes.io/docs/concepts/services-networking/network-policies/#targeting-a-namespace-by-its-name)
- [DNS for Services and Pods](https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/)
- [Accessing the API from within a Pod](https://kubernetes.io/docs/tasks/run-application/access-api-from-pod/)
- [Using RBAC Authorization](https://kubernetes.io/docs/reference/access-control/rbac/)
- [Role and RoleBinding](https://kubernetes.io/docs/reference/access-control/rbac/#role-and-clusterrole)
