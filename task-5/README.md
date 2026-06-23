# Task 5: Perform a Helm upgrade and ensure it goes right (1)

## Task

Check Helm releases in `task-5` namespace.
Use `values-upgrade.yaml` to upgrade release with new values

```bash
helm upgrade <release-name> jetstack/cert-manager -n task-5 \
    --reuse-values -f <values-file>
```

## Documentation

- [Helm upgrade](https://helm.sh/docs/helm/helm_upgrade/)
- [Managing Resources for Containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)
- [Resource units in Kubernetes (Mi vs Gi)](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#resource-units-in-kubernetes)
- [Assigning Pods to Nodes / scheduling based on resources](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/)
- [Debugging Pending Pods](https://kubernetes.io/docs/tasks/debug/debug-application-cluster/debug-pods/)
