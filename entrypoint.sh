#!/bin/sh

# Only update config if DISABLE_CONFIG_UPDATE is not set
if [ -z "$DISABLE_CONFIG_UPDATE" ]; then
  # Copy template to config
  cp config.tpl $CONFIG_FILE

  # For each env var with __, update the config file
  printenv | grep "__" | while IFS='=' read -r envvar value; do
    section="$(echo "$envvar" | cut -d'__' -f1)"
    key="$(echo "$envvar" | cut -d'__' -f2-)"
    # Only process if both section and key are set
    if [ -n "$section" ] && [ -n "$key" ]; then
      # Escape special characters for sed
      esc_value=$(printf '%s\n' "$value" | sed 's/[&/]/\\&/g')
      # Replace or add the key in the section
      awk -v section="[$section]" -v key="$key" -v value="$esc_value" '
        BEGIN {found_section=0; done=0}
        {
          if ($0 == section) {found_section=1; print; next}
          if (found_section && $0 ~ /^\[/) {if (!done) {print key "=" value; done=1} found_section=0}
          if (found_section && $0 ~ "^" key "=") {$0=key "=" value; done=1}
          print
        }
        END {if (found_section && !done) print key "=" value}
      ' $CONFIG_FILE > config.tmp && mv config.tmp $CONFIG_FILE
    fi
  done

  echo "Config parsed from environment variables."
else
  echo "Config update disabled by DISABLE_CONFIG_UPDATE."
fi

# Build osync flags from env vars
osync_flags="$CONFIG_FILE"
[ "$VERBOSE" = "true" ] && osync_flags="$osync_flags --verbose"
[ "$NO_MAXTIME" = "true" ] && osync_flags="$osync_flags --no-maxtime"
[ "$SILENT" = "true" ] && osync_flags="$osync_flags --silent"
[ "$ON_CHANGES" = "true" ] && osync_flags="$osync_flags --on-changes"

# If the command is osync, add flags
if [ "$1" = "osync" ]; then
  shift
  set -- osync $osync_flags "$@"
fi

# Execute the main container command
exec "$@"