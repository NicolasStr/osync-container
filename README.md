# osync-container

A minimal container for running [osync](https://github.com/deajan/osync) with dynamic configuration via environment variables.

## Usage

This container generates a config file at startup based on a template (`config.tpl`) and environment variables. It then runs `osync` with optional flags.

### Configuration via Environment Variables

- To set a value in the config, use environment variables in the form:
  
  `SECTION__KEY=VALUE`
  
  For example, to set `ALWAYS_SEND_MAILS` in the `[ALERT_OPTIONS]` section:
  
  ```sh
  docker run -e ALERT_OPTIONS__ALWAYS_SEND_MAILS=true ...
  ```
  This will result in:
  ```ini
  [ALERT_OPTIONS]
  ALWAYS_SEND_MAILS=true
  ```

- By default, the config file is generated from `config.tpl` and written to the file specified by `$CONFIG_FILE` (default: `config`).

#### Special Environment Variables

| Variable                | Description                                                                                 |
|-------------------------|---------------------------------------------------------------------------------------------|
| `DISABLE_CONFIG_UPDATE` | If set (to any value), disables config file generation and templating.                      |
| `CONFIG_FILE`           | Path to the config file to generate and use (default: `config`).                            |
| `VERBOSE`               | If set to `true`, adds `--verbose` to the `osync` command.                                  |
| `NO_MAXTIME`            | If set to `true`, adds `--no-maxtime` to the `osync` command.                               |
| `SILENT`                | If set to `true`, adds `--silent` to the `osync` command.                                   |
| `ON_CHANGES`            | If set to `true`, adds `--on-changes` to the `osync` command.                               |

### All Available Config Sections and Variables

| Section | Variable Name | Docker Env Name | Default Value | Description |
|---------|---------------|-----------------|--------------|-------------|
| GENERAL | CONFIG_FILE_REVISION | GENERAL__CONFIG_FILE_REVISION | 1.3.0 | Config file revision |
| GENERAL | INSTANCE_ID | GENERAL__INSTANCE_ID | "sync_test" | Sync job identification |
| GENERAL | INITIATOR_SYNC_DIR | GENERAL__INITIATOR_SYNC_DIR | "/home/git/osync/dir1" | Initiator directory |
| GENERAL | TARGET_SYNC_DIR | GENERAL__TARGET_SYNC_DIR | "/home/git/osync/dir2" | Target directory |
| GENERAL | SSH_RSA_PRIVATE_KEY | GENERAL__SSH_RSA_PRIVATE_KEY | "/home/backupuser/.ssh/id_rsa" | Path to SSH private key |
| GENERAL | SSH_PASSWORD_FILE | GENERAL__SSH_PASSWORD_FILE | "" | Path to SSH password file |
| GENERAL | _REMOTE_TOKEN | GENERAL___REMOTE_TOKEN | SomeAlphaNumericToken9 | Remote token for ssh filter |
| GENERAL | CREATE_DIRS | GENERAL__CREATE_DIRS | true | Create sync directories |
| GENERAL | LOGFILE | GENERAL__LOGFILE | "" | Log file location |
| GENERAL | MINIMUM_SPACE | GENERAL__MINIMUM_SPACE | 10240 | Minimum free space (KB) |
| GENERAL | BANDWIDTH | GENERAL__BANDWIDTH | 0 | Bandwidth limit (KB/s) |
| GENERAL | SUDO_EXEC | GENERAL__SUDO_EXEC | false | Run sync as superuser |
| GENERAL | RSYNC_EXECUTABLE | GENERAL__RSYNC_EXECUTABLE | rsync | Rsync executable |
| GENERAL | RSYNC_REMOTE_PATH | GENERAL__RSYNC_REMOTE_PATH | "" | Remote rsync path |
| GENERAL | RSYNC_PATTERN_FIRST | GENERAL__RSYNC_PATTERN_FIRST | include | Rsync include/exclude order |
| GENERAL | RSYNC_INCLUDE_PATTERN | GENERAL__RSYNC_INCLUDE_PATTERN | "" | Rsync include patterns |
| GENERAL | RSYNC_EXCLUDE_PATTERN | GENERAL__RSYNC_EXCLUDE_PATTERN | "" | Rsync exclude patterns |
| GENERAL | RSYNC_INCLUDE_FROM | GENERAL__RSYNC_INCLUDE_FROM | "" | Rsync include from file |
| GENERAL | RSYNC_EXCLUDE_FROM | GENERAL__RSYNC_EXCLUDE_FROM | "" | Rsync exclude from file |
| GENERAL | PATH_SEPARATOR_CHAR | GENERAL__PATH_SEPARATOR_CHAR | ";" | List elements separator |
| GENERAL | INITIATOR_CUSTOM_STATE_DIR | GENERAL__INITIATOR_CUSTOM_STATE_DIR | "" | Custom state dir (initiator) |
| GENERAL | TARGET_CUSTOM_STATE_DIR | GENERAL__TARGET_CUSTOM_STATE_DIR | "" | Custom state dir (target) |
| REMOTE_OPTIONS | SSH_COMPRESSION | REMOTE_OPTIONS__SSH_COMPRESSION | false | Use ssh compression |
| REMOTE_OPTIONS | SSH_IGNORE_KNOWN_HOSTS | REMOTE_OPTIONS__SSH_IGNORE_KNOWN_HOSTS | false | Ignore ssh known hosts |
| REMOTE_OPTIONS | SSH_CONTROLMASTER | REMOTE_OPTIONS__SSH_CONTROLMASTER | false | Use single TCP connection |
| REMOTE_OPTIONS | REMOTE_HOST_PING | REMOTE_OPTIONS__REMOTE_HOST_PING | false | Check remote host connectivity |
| REMOTE_OPTIONS | REMOTE_3RD_PARTY_HOSTS | REMOTE_OPTIONS__REMOTE_3RD_PARTY_HOSTS | "www.kernel.org www.google.com" | 3rd party hosts to ping |
| MISC_OPTIONS | RSYNC_OPTIONAL_ARGS | MISC_OPTIONS__RSYNC_OPTIONAL_ARGS | "" | Optional rsync arguments |
| MISC_OPTIONS | PRESERVE_PERMISSIONS | MISC_OPTIONS__PRESERVE_PERMISSIONS | true | Preserve permissions |
| MISC_OPTIONS | PRESERVE_OWNER | MISC_OPTIONS__PRESERVE_OWNER | true | Preserve owner |
| MISC_OPTIONS | PRESERVE_GROUP | MISC_OPTIONS__PRESERVE_GROUP | true | Preserve group |
| MISC_OPTIONS | PRESERVE_EXECUTABILITY | MISC_OPTIONS__PRESERVE_EXECUTABILITY | true | Preserve executability |
| MISC_OPTIONS | PRESERVE_ACL | MISC_OPTIONS__PRESERVE_ACL | false | Preserve ACLs |
| MISC_OPTIONS | PRESERVE_XATTR | MISC_OPTIONS__PRESERVE_XATTR | false | Preserve Xattr |
| MISC_OPTIONS | COPY_SYMLINKS | MISC_OPTIONS__COPY_SYMLINKS | false | Copy symlinks |
| MISC_OPTIONS | KEEP_DIRLINKS | MISC_OPTIONS__KEEP_DIRLINKS | false | Treat symlinked dirs as dirs |
| MISC_OPTIONS | PRESERVE_HARDLINKS | MISC_OPTIONS__PRESERVE_HARDLINKS | false | Preserve hard links |
| MISC_OPTIONS | CHECKSUM | MISC_OPTIONS__CHECKSUM | false | Full checksum on files |
| MISC_OPTIONS | RSYNC_COMPRESS | MISC_OPTIONS__RSYNC_COMPRESS | true | Rsync compress |
| MISC_OPTIONS | SOFT_MAX_EXEC_TIME | MISC_OPTIONS__SOFT_MAX_EXEC_TIME | 7200 | Soft max exec time (s) |
| MISC_OPTIONS | HARD_MAX_EXEC_TIME | MISC_OPTIONS__HARD_MAX_EXEC_TIME | 10600 | Hard max exec time (s) |
| MISC_OPTIONS | KEEP_LOGGING | MISC_OPTIONS__KEEP_LOGGING | 1801 | Log message interval (s) |
| MISC_OPTIONS | MIN_WAIT | MISC_OPTIONS__MIN_WAIT | 60 | Min wait in daemon mode (s) |
| MISC_OPTIONS | MAX_WAIT | MISC_OPTIONS__MAX_WAIT | 7200 | Max wait in daemon mode (s) |
| BACKUP_DELETE_OPTIONS | LOG_CONFLICTS | BACKUP_DELETE_OPTIONS__LOG_CONFLICTS | false | Log conflictual files |
| BACKUP_DELETE_OPTIONS | ALERT_CONFLICTS | BACKUP_DELETE_OPTIONS__ALERT_CONFLICTS | false | Alert on conflicts |
| BACKUP_DELETE_OPTIONS | CONFLICT_BACKUP | BACKUP_DELETE_OPTIONS__CONFLICT_BACKUP | true | Keep backup of updated files |
| BACKUP_DELETE_OPTIONS | CONFLICT_BACKUP_MULTIPLE | BACKUP_DELETE_OPTIONS__CONFLICT_BACKUP_MULTIPLE | false | Keep multiple backup versions |
| BACKUP_DELETE_OPTIONS | CONFLICT_BACKUP_DAYS | BACKUP_DELETE_OPTIONS__CONFLICT_BACKUP_DAYS | 30 | Days to keep backups |
| BACKUP_DELETE_OPTIONS | CONFLICT_PREVALANCE | BACKUP_DELETE_OPTIONS__CONFLICT_PREVALANCE | initiator | Conflict winner |
| BACKUP_DELETE_OPTIONS | SOFT_DELETE | BACKUP_DELETE_OPTIONS__SOFT_DELETE | true | Keep deleted files |
| BACKUP_DELETE_OPTIONS | SOFT_DELETE_DAYS | BACKUP_DELETE_OPTIONS__SOFT_DELETE_DAYS | 30 | Days to keep deleted files |
| BACKUP_DELETE_OPTIONS | SKIP_DELETION | BACKUP_DELETE_OPTIONS__SKIP_DELETION | "" | Skip deletion on replicas |
| BACKUP_DELETE_OPTIONS | SYNC_TYPE | BACKUP_DELETE_OPTIONS__SYNC_TYPE | "" | Sync type |
| RESUME_OPTIONS | RESUME_SYNC | RESUME_OPTIONS__RESUME_SYNC | true | Resume aborted sync |
| RESUME_OPTIONS | RESUME_TRY | RESUME_OPTIONS__RESUME_TRY | 2 | Max resume tries |
| RESUME_OPTIONS | FORCE_STRANGER_LOCK_RESUME | RESUME_OPTIONS__FORCE_STRANGER_LOCK_RESUME | false | Force stranger lock resume |
| RESUME_OPTIONS | PARTIAL | RESUME_OPTIONS__PARTIAL | false | Keep partial uploads |
| RESUME_OPTIONS | DELTA_COPIES | RESUME_OPTIONS__DELTA_COPIES | true | Use delta copy algorithm |
| ALERT_OPTIONS | DESTINATION_MAILS | ALERT_OPTIONS__DESTINATION_MAILS | "your@alert.tld" | Alert mail recipients |
| ALERT_OPTIONS | ALWAYS_SEND_MAILS | ALERT_OPTIONS__ALWAYS_SEND_MAILS | false | Always send mails |
| ALERT_OPTIONS | MAIL_BODY_CHARSET | ALERT_OPTIONS__MAIL_BODY_CHARSET | "" | Mail body encoding |
| ALERT_OPTIONS | SENDER_MAIL | ALERT_OPTIONS__SENDER_MAIL | "alert@your.system.tld" | Sender mail address |
| ALERT_OPTIONS | SMTP_SERVER | ALERT_OPTIONS__SMTP_SERVER | smtp.your.isp.tld | SMTP server |
| ALERT_OPTIONS | SMTP_PORT | ALERT_OPTIONS__SMTP_PORT | 25 | SMTP port |
| ALERT_OPTIONS | SMTP_ENCRYPTION | ALERT_OPTIONS__SMTP_ENCRYPTION | none | SMTP encryption |
| ALERT_OPTIONS | SMTP_USER | ALERT_OPTIONS__SMTP_USER | "" | SMTP user |
| ALERT_OPTIONS | SMTP_PASSWORD | ALERT_OPTIONS__SMTP_PASSWORD | "" | SMTP password |
| EXECUTION_HOOKS | LOCAL_RUN_BEFORE_CMD | EXECUTION_HOOKS__LOCAL_RUN_BEFORE_CMD | "" | Local before sync command |
| EXECUTION_HOOKS | LOCAL_RUN_AFTER_CMD | EXECUTION_HOOKS__LOCAL_RUN_AFTER_CMD | "" | Local after sync command |
| EXECUTION_HOOKS | REMOTE_RUN_BEFORE_CMD | EXECUTION_HOOKS__REMOTE_RUN_BEFORE_CMD | "" | Remote before sync command |
| EXECUTION_HOOKS | REMOTE_RUN_AFTER_CMD | EXECUTION_HOOKS__REMOTE_RUN_AFTER_CMD | "" | Remote after sync command |
| EXECUTION_HOOKS | MAX_EXEC_TIME_PER_CMD_BEFORE | EXECUTION_HOOKS__MAX_EXEC_TIME_PER_CMD_BEFORE | 0 | Max exec time before (s) |
| EXECUTION_HOOKS | MAX_EXEC_TIME_PER_CMD_AFTER | EXECUTION_HOOKS__MAX_EXEC_TIME_PER_CMD_AFTER | 0 | Max exec time after (s) |
| EXECUTION_HOOKS | STOP_ON_CMD_ERROR | EXECUTION_HOOKS__STOP_ON_CMD_ERROR | true | Stop on command error |
| EXECUTION_HOOKS | RUN_AFTER_CMD_ON_ERROR | EXECUTION_HOOKS__RUN_AFTER_CMD_ON_ERROR | false | Run after commands on error |

### Example

```sh
docker run \
  -e CONFIG_FILE=/data/osync.conf \
  -e GENERAL__INSTANCE_ID=myjob \
  -e ALERT_OPTIONS__ALWAYS_SEND_MAILS=true \
  -e VERBOSE=true \
  osync-container osync
```

This will:
- Generate `/data/osync.conf` from `config.tpl`, updating the `[GENERAL]` and `[ALERT_OPTIONS]` sections.
- Run `osync /data/osync.conf --verbose`.

---

For more details on available config options, see the `config.tpl` file or the [osync documentation](https://github.com/deajan/osync).