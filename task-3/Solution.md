# Task 3: PVC troubleshooting

## Where to look

- `kubectl get pvc -n task-3`
- `kubectl describe pvc shared-data -n task-3` - read the `Events` section
- `kubectl get pods -n task-3`
- `kubectl describe pod <pod> -n task-3`
- `kubectl get storageclass`

## Solution

- Check Pods

```bash
kgp -n task-3
NAME                   READY   STATUS    RESTARTS   AGE    IP       NODE     NOMINATED NODE   READINESS GATES
web-64947dcbf9-9x96n   0/1     Pending   0          117s   <none>   <none>   <none>           <none>
web-64947dcbf9-tfpvv   0/1     Pending   0          117s   <none>   <none>   <none>           <none>
```

- Describe a Pod to get errors

```bash
kdp -n task-3 web-64947dcbf9-9x96n
Name:             web-64947dcbf9-9x96n
...
Events:
  Type     Reason            Age                    From               Message
  ----     ------            ----                   ----               -------
  Warning  FailedScheduling  2m10s (x3 over 2m10s)  default-scheduler  0/3 nodes are available: pod has unbound immediate PersistentVolumeClaims. not found
  Warning  FailedScheduling  2m10s (x2 over 2m10s)  default-scheduler  0/3 nodes are available: 3 node(s) didn't match PersistentVolume's node affinity. no new claims to deallocate, preemption: 0/3 nodes are available: 3 Preemption is not helpful for scheduling.
```

- Check PVC node affinity - `3 node(s) didn't match PersistentVolume's node affinity.`

```bash
kd pvc -n task-3
Name:          shared-data
Namespace:     task-3
StorageClass:  cinder-zone-a
```

- Check StorageClass

```bash
kg sc cinder-zone-a -o yaml
allowVolumeExpansion: true
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: cinder-zone-a
parameters:
  availability: eu-de-1a
```

- Check nodes - nodes are in zone b

```bash
kdn kks-kluster-01-pool-1-6grjd
Name:               kks-kluster-01-pool-1-6grjd
Roles:              <none>
Labels:             beta.kubernetes.io/arch=amd64
                    beta.kubernetes.io/instance-type=c_c4_m4
                    beta.kubernetes.io/os=linux
                    ccloud.sap.com/nodepool=pool-1
                    disktype=ssd
                    failure-domain.beta.kubernetes.io/region=eu-de-1
                    failure-domain.beta.kubernetes.io/zone=eu-de-1b
```

- Re-create Volume with another StorageClass

```bash
kg pvc -n task-3 shared-data -o yaml > shared-data.pvc.yaml
```

- Update storage class and re-create volume

```yaml
  storageClassName: cinder-zone-b
```

```bash
kdl pvc -n task-3 shared-data
k apply -f shared-data.pvc.yaml
```

- Scale down deployment as the volume can only be attached to 1 node at a time

```bash
kgp -n task-3
NAME                   READY   STATUS              RESTARTS   AGE   IP            NODE                          NOMINATED NODE   READINESS GATES
web-64947dcbf9-fplhd   1/1     Running             0          38s   100.100.1.7   kks-kluster-01-pool-1-qqqwq   <none>           <none>
web-64947dcbf9-hlqp2   0/1     ContainerCreating   0          38s   <none>        kks-kluster-01-pool-1-6grjd   <none>           <none>

kdp -n task-3
...
Events:
  Type     Reason              Age                From                     Message
  ----     ------              ----               ----                     -------
  Normal   Scheduled           89s                default-scheduler        Successfully assigned task-3/web-64947dcbf9-hlqp2 to kks-kluster-01-pool-1-6grjd
  Warning  FailedAttachVolume  67s (x6 over 85s)  attachdetach-controller  AttachVolume.Attach failed for volume "pv-kluster-01-5d0c883f03574a048a7f2b9902410da3-c454ea5a-1c2e-4a28-9e0f-7e1797be5be1" : rpc error: code = Internal desc = [ControllerPublishVolume] Attach Volume failed with error failed to attach d85ceae8-a19c-484d-9de0-a62c7754f4ba volume to 26d11bc2-34af-4a4c-ae63-29ed7e2fbc92 compute: Expected HTTP response code [200] when accessing [POST https://compute-3.eu-de-1.cloud.sap:443/v2.1/servers/26d11bc2-34af-4a4c-ae63-29ed7e2fbc92/os-volume_attachments], but got 400 instead: {"badRequest": {"code": 400, "message": "Invalid volume: volume d85ceae8-a19c-484d-9de0-a62c7754f4ba is already attached to instances: 1458b5f0-d818-49aa-986d-f584edb64450"}}
  Warning  FailedAttachVolume  18s (x2 over 50s)  attachdetach-controller  AttachVolume.Attach failed for volume "pv-kluster-01-5d0c883f03574a048a7f2b9902410da3-c454ea5a-1c2e-4a28-9e0f-7e1797be5be1" : rpc error: code = Internal desc = [ControllerPublishVolume] Attach Volume failed with error failed to attach d85ceae8-a19c-484d-9de0-a62c7754f4ba volume to 26d11bc2-34af-4a4c-ae63-29ed7e2fbc92 compute: Expected HTTP response code [200] when accessing [POST https://compute-3.eu-de-1.cloud.sap:443/v2.1/servers/26d11bc2-34af-4a4c-ae63-29ed7e2fbc92/os-volume_attachments], but got 400 instead: {"badRequest": {"code": 400, "message": "Invalid volume: volume d85ceae8-a19c-484d-9de0-a62c7754f4ba is already attached to instances: 5e25fdab-4e35-4b88-8d45-df26d768c374"}}
```

- Scale down

```bash
k scale deploy/web -n task-3  --replicas=1
deployment.apps/web scaled
```
