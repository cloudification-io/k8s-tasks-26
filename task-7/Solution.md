# Solution

## Where to look

- `kubectl get pods -n task-7`
- `kubectl logs <pod> -n task-7 -c web`
- `kubectl logs <pod> -n task-7 -c log-tailer`
- `kubectl describe pod <pod> -n task-7` - check the init container's command
- `kubectl exec -n task-7 <pod> -c log-tailer -- ls -la /var/log/nginx`

Fix volume mount in log-tailer container

```yaml
        - name: log-tailer
          volumeMounts:
            - name: nginx-logs
              mountPath: /var/log/nginx```
```

Both containers settle into `Running`, and `log-tailer`'s logs start
streaming nginx's access log lines.
