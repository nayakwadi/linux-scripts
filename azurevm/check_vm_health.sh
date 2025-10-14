#!/usr/bin/env bash
#
# check_vm_health.sh
#
# Analyze the health of an Ubuntu VM based on CPU, Memory and Disk usage.
#
# Behavior:
# - If any metric exceeds the threshold (60%), the VM is reported as "NOT HEALTHY".
# - Otherwise the VM is reported as "HEALTHY".
# - If the "explain" argument is provided (accepts "explain", "--explain" or "-e"),
#   the script prints the reason(s) with each metric value.
#
# Usage:
#   ./check_vm_health.sh            # prints only HEALTHY / NOT HEALTHY
#   ./check_vm_health.sh explain    # prints status and explanation
#
# Tested on Ubuntu. Requires standard utils: top, free, df, awk, sed. Falls back to /proc/stat
# for CPU if top parsing fails.

THRESHOLD=60.0

show_usage() {
  cat <<EOF
Usage:
  $0 [explain|--explain|-e]

Checks CPU, Memory and root-disk utilization.
If any metric > ${THRESHOLD}% => NOT HEALTHY
Otherwise => HEALTHY
EOF
}

# Parse arguments
EXPLAIN=false
if [[ $# -gt 0 ]]; then
  case "$1" in
    explain|--explain|-e) EXPLAIN=true ;;
    -h|--help) show_usage; exit 0 ;;
    *) echo "Unknown argument: $1"; show_usage; exit 2 ;;
  esac
fi

# Helper: compare float greater-than (returns 0 if a > b)
float_gt() {
  # usage: float_gt "a" "b"
  awk -v a="$1" -v b="$2" 'BEGIN {exit !(a > b)}'
}

# Get CPU usage percentage.
# Primary method: parse top output for idle and do 100 - idle
# Fallback: compute from /proc/stat over 1 second interval
get_cpu_usage() {
  local cpu_idle cpu_usage
  cpu_idle=$(top -bn1 2>/dev/null | grep -i "cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/")
  if [[ -n "$cpu_idle" ]]; then
    # Use bc or awk for arithmetic
    cpu_usage=$(awk -v idle="$cpu_idle" 'BEGIN { printf "%.1f", 100 - idle }')
    echo "$cpu_usage"
    return 0
  fi

  # Fallback to /proc/stat
  if [[ -r /proc/stat ]]; then
    # read first line fields
    read -r _user _nice _system _idle _iowait _irq _softirq _steal _guest _guest_nice < /proc/stat
    prev_idle=$((_idle + _iowait))
    prev_total=$((_user + _nice + _system + _idle + _iowait + _irq + _softirq + _steal + _guest + _guest_nice))
    sleep 1
    read -r _user _nice _system _idle _iowait _irq _softirq _steal _guest _guest_nice < /proc/stat
    idle=$((_idle + _iowait))
    total=$((_user + _nice + _system + _idle + _iowait + _irq + _softirq + _steal + _guest + _guest_nice))
    diff_idle=$((idle - prev_idle))
    diff_total=$((total - prev_total))
    if [[ $diff_total -gt 0 ]]; then
      # compute usage as (1 - diff_idle/diff_total) * 100 with awk for decimal
      cpu_usage=$(awk -v di="$diff_idle" -v dt="$diff_total" 'BEGIN { printf "%.1f", (1 - di/dt) * 100 }')
      echo "$cpu_usage"
      return 0
    fi
  fi

  # If all else fails, return 0.0 to avoid false positive
  echo "0.0"
  return 0
}

# Get memory usage percentage.
# Use available memory when possible: (total - available) / total * 100
get_mem_usage() {
  # free output: on modern systems "available" exists
  if free_out=$(free 2>/dev/null); then
    mem_used_percent=$(echo "$free_out" | awk '/^Mem:/ { if ($7 != "") { printf "%.1f", ($2 - $7)/$2 * 100 } else { printf "%.1f", $3/$2 * 100 } }')
    echo "$mem_used_percent"
    return 0
  fi
  echo "0.0"
  return 0
}

# Get root filesystem disk usage percentage (integer or decimal)
get_disk_usage() {
  # use df -P to ensure POSIX output; target '/'
  # extract percent number
  disk_pct=$(df -P / 2>/dev/null | awk 'NR==2 { gsub(/%/,"",$5); printf "%.1f", $5 }')
  if [[ -z "$disk_pct" ]]; then
    echo "0.0"
  else
    echo "$disk_pct"
  fi
}

cpu=$(get_cpu_usage)
mem=$(get_mem_usage)
disk=$(get_disk_usage)

# Decide health: if any metric > THRESHOLD => NOT HEALTHY
is_not_healthy=false
if float_gt "$cpu" "$THRESHOLD" || float_gt "$mem" "$THRESHOLD" || float_gt "$disk" "$THRESHOLD"; then
  is_not_healthy=true
fi

if $is_not_healthy; then
  status="NOT HEALTHY"
else
  status="HEALTHY"
fi

# Output
echo "$status"

if $EXPLAIN; then
  printf "Details:\n"
  printf "  CPU Usage:    %s%%\n" "$cpu"
  printf "  Memory Usage: %s%%\n" "$mem"
  printf "  Disk Usage:   %s%%\n" "$disk"
  printf "\nExplanation:\n"
  if $is_not_healthy; then
    echo "  One or more metrics exceed the threshold of ${THRESHOLD}%. Causes might include:"
    if float_gt "$cpu" "$THRESHOLD"; then
      echo "   - High CPU usage (${cpu}%) (e.g. runaway process, heavy compute, DDoS, misconfiguration)"
    fi
    if float_gt "$mem" "$THRESHOLD"; then
      echo "   - High memory usage (${mem}%) (e.g. memory leak, many processes, caching pressure)"
    fi
    if float_gt "$disk" "$THRESHOLD"; then
      echo "   - High disk usage (${disk}%) on root (e.g. logs, backups, large files filling /)"
    fi
    echo "  Recommended actions: inspect top/ps, check logs, clear or rotate logs, increase resources or scale."
  else
    echo "  All metrics are at or below ${THRESHOLD}%. VM appears healthy."
  fi
fi

# Exit code: 0 for healthy, 2 for not healthy (non-zero to reflect problem)
if $is_not_healthy; then
  exit 2
else
  exit 0
fi