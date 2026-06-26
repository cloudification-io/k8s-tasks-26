# Task 1

Provision a Shoot cluster

1. Log into [Persehone dashboard](https://dashboard.eu-de-1.cloud.sap/monsoon3/gardenerworkshopjune2026/kubernetes-gardener/prod/clusters)
2. Add new cluster
   1. K8s version: `1.34.6`
   2. Important settings for worker pool:
      1. Machine_type: `g_c4_m8_v2`
      2. Availability zones: `b` or `d`
      3. Max nodes: >= `3`
3. Once provisioned download Kubeconfig
   1. Cluster name -> Kubeconfig
