# Assignment — Build a "Virtual Garden" control plane

## Scenario

A shoot's `kube-apiserver` and `etcd` run as pods inside a seed cluster; the garden control plane itself can
run the same way (the *virtual garden*). `etcd` is never managed by hand — a
dedicated operator, **etcd-druid**, provisions and reconciles it from a single
`Etcd` custom resource.

You will build an imitation of a virtual garden:

1. Install **etcd-druid** (the operator).
2. Provision a single-member **etcd** cluster by creating an `Etcd` resource.
3. Deploy a **kube-apiserver** that uses that etcd as its backing store.
4. Reach the apiserver via **`kubectl port-forward`**, build a kubeconfig from a **token stored in a Secret**, and talk to it.
5. Create objects (a ConfigMap and a Secret) **inside** the virtual control plane

## Tasks

### 0. Namespace

Create the working namespace.

```bash
kubectl apply -f manifests/01-namespace.yaml
```

### 1. Install the etcd-druid operator

etcd-druid is published as an OCI Helm chart. Install it into its own namespace.

```bash
helm install etcd-druid \
  oci://europe-docker.pkg.dev/gardener-project/releases/charts/gardener/etcd-druid \
  --namespace etcd-druid --create-namespace \
  --version v0.34.0
```

Verify the operator is running and that the `Etcd` CRD was
installed.

### 2. Provision the etcd cluster

Read `manifests/02-etcd.yaml` and note: `replicas: 1`, no TLS block (plain HTTP
on 2379), no backup `store` (local snapshots only). Then apply it.

```bash
kubectl apply -f manifests/02-etcd.yaml
```

Watch druid reconcile it into real resources and wait until the `Etcd` reports `Ready`.

### 3. Deploy cert-manager

Cert-manager automates TLS certificate provisioning

```bash
helm install cert-manager \
  oci://quay.io/jetstack/charts/cert-manager \
  --namespace cert-manager --create-namespace \
  --version v1.20.3 \
  --set crds.enabled=true

kubectl -n cert-manager rollout status deploy/cert-manager-webhook
```

Once provisioned create cert-manager objects

```bash
kubectl apply -f manifests/certificates.yaml
kubectl -n virtual-garden wait --for=condition=Ready certificate --all --timeout=120s
```

### 4. Deploy the kube-apiserver

Open `manifests/03-kube-apiserver.yaml` and read the `command:` flags before
applying — this is the heart of the exercise. Make sure
`--etcd-servers=...` matches the **client Service** from Part 2.

```bash
kubectl apply -f manifests/03-kube-apiserver.yaml
```

Confirm the apiserver pod becomes Ready and that it actually
connected to your etcd.

### 5. Get access (port-forward + Secret)

Forward the apiserver Service to your machine (leave this running in one
terminal):

```bash
kubectl -n virtual-garden port-forward svc/virtual-garden-kube-apiserver 6443:443
```

Build a kubeconfig named `virtual-garden.kubeconfig` that points at `https://127.0.0.1:6443`

```bash
kubectl -n virtual-garden get secret virtual-garden-admin-client -o go-template='apiVersion: v1
kind: Config
clusters:
- name: virtual-garden
  cluster:
    server: https://127.0.0.1:6443
    certificate-authority-data: {{index .data "ca.crt"}}
users:
- name: garden-admin
  user:
    client-certificate-data: {{index .data "tls.crt"}}
    client-key-data: {{index .data "tls.key"}}
contexts:
- name: virtual-garden
  context:
    cluster: virtual-garden
    user: garden-admin
current-context: virtual-garden
' > virtual-garden.kubeconfig
```

### 6. Create objects in the virtual control plane

Using your `virtual-garden.kubeconfig`, create a ConfigMap and a Secret in the
virtual cluster's `default` namespace, then read them back.

```bash
export KUBECONFIG=$PWD/virtual-garden.kubeconfig
kubectl create configmap garden-info --from-literal=team="$USER"
kubectl create secret generic garden-secret --from-literal=password=s3cr3t
kubectl get configmap garden-info -o yaml
kubectl get secret garden-secret -o yaml
```

#### Extra

Prove these objects physically live in *your* etcd.
etcd-druid uses a distroless etcd image with no shell, so attach an **ephemeraldebug container** and query etcd directly:

```bash
unset KUBECONFIG   # talk to the HOST cluster again
kubectl -n virtual-garden debug -it virtual-garden-etcd-0 \
  --image=quay.io/coreos/etcd:v3.5.21 --target=etcd -- \
  etcdctl --endpoints=http://127.0.0.1:2379 get /registry/configmaps/default/garden-info --prefix --keys-only
```

You should see the key `/registry/configmaps/default/garden-info`
