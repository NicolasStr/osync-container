# osync-container Helm Chart

This chart deploys one osync-container pod per PVC defined in `values.yaml`.

## Usage

1. Edit `values.yaml` to list your PVCs and any environment variables needed for osync.
2. Install the chart:
   ```sh
   helm install my-osync ./chart
   ```

## values.yaml Example

```yaml
image:
  repository: ghcr.io/<your-org-or-user>/osync-container
  tag: latest

pvcs:
  - name: data1
    claimName: my-claim1
    mountPath: /data1
    targetSyncDir: /remote/target1
  - name: data2
    claimName: my-claim2
    mountPath: /data2
    targetSyncDir: "ssh://backupuser@yourhost:22//remote/target2"

# targetSyncDir can be a local path or a remote SSH path (e.g. ssh://user@host:port//path)

env:
  GENERAL__INSTANCE_ID: "sync_job1"
  ALERT_OPTIONS__ALWAYS_SEND_MAILS: "true"

podSecurityContext:
  runAsUser: 1000
  runAsGroup: 1000
  fsGroup: 1000
  fsGroupChangePolicy: "OnRootMismatch"
  seccompProfile:
    type: RuntimeDefault

securityContext:
  allowPrivilegeEscalation: false
  readOnlyRootFilesystem: false
  runAsNonRoot: true

tolerations: []
affinity: {}
nodeSelector: {}

podAntiAffinity:
  enabled: true
  topologyKey: "kubernetes.io/hostname"

livenessProbe:
  exec:
    command:
      - sh
      - -c
      - "pgrep osync || pgrep bash || pgrep sh"
  initialDelaySeconds: 30
  periodSeconds: 30
  timeoutSeconds: 5
  failureThreshold: 3

serviceAccount:
  create: true
  name: ""
```

### Features
- Deploys one pod per PVC, each with its own INITIATOR_SYNC_DIR and TARGET_SYNC_DIR (local or SSH path)
- All osync configuration can be set via environment variables
- Fully customizable pod/container security context, livenessProbe, tolerations, affinity, nodeSelector, and anti-affinity
- Optional ServiceAccount creation and usage

This will deploy two pods, each mounting a different PVC and using the specified environment variables and security settings. The `targetSyncDir` can be a local path or a remote SSH path.
