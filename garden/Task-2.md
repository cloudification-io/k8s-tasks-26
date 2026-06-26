# Task 2

## 1. Deploy Garden operator via Helm Chart

- [Docs](https://gardener.cloud/docs/gardener/concepts/operator/#deployment)

- Community Helm charts can be found [here](https://github.com/gardener-community/gardener-charts)
  
```bash
helm repo add gardener-charts https://gardener-community.github.io/gardener-charts
helm repo update

# Search for the Helm chart
helm search repo gardener-operator
NAME                             	CHART VERSION	APP VERSION	DESCRIPTION
gardener-charts/gardener-operator	1.145.0      	           	A Helm chart to deploy the Gardener Operator
```

- Install Operator Chart

```bash
helm upgrade --install \
    --create-namespace \
    --namespace garden \
    gardener-operator gardener-charts/gardener-operator

Release "gardener-operator" has been upgraded. Happy Helming!
NAME: gardener-operator
```

- Verify operator is Running

```bash
kgp -n garden
NAME                                 READY   STATUS    RESTARTS   AGE   IP          NODE                                                     NOMINATED NODE   READINESS GATES
gardener-operator-67644dd456-xfbmb   1/1     Running   0          33s   10.44.0.4   shoot--ec09f46219--demo-99-worker-4uoxo-z1-7d45c-fr9s7   <none>           <none>
```

## 2. Create Garden object

Links:
- [Garden object](https://gardener.cloud/docs/gardener/deployment/setup_gardener/#garden) - used by operator to provision Runtime and Virtual Garden clusters

```bash
k apply -f https://raw.githubusercontent.com/gardener/gardener/refs/tags/v1.145.0/example/operator/20-garden.yaml
```

Query garden objects

```bash
kg garden
NAME    K8S VERSION   GARDENER VERSION   LAST OPERATION   RUNTIME   VIRTUAL   API SERVER   OBSERVABILITY   AGE
local   1.33.0        v1.145.0           Error            True      False     False        True            14h
```

Check which resources are created and/or failed

## 3. Find a way to remove garden object

- [Docs](https://gardener.cloud/docs/gardener/concepts/operator/#garden)

## 4. Apply new garden object

Apply garden object via

```bash
kubectl apply -f garden.yml
```

Note if there's a difference in provisioned resources
