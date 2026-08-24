#!/usr/bin/env bash
set -euo pipefail

api_base="${API_BASE_URL:-http://localhost:8080}"
iterations="${PERF_ITERATIONS:-25}"
max_p95_ms="${PERF_MAX_P95_MS:-750}"
email="phase14-perf-$(date +%s)@example.com"

token="$(curl --fail --silent --show-error \
  --header 'Content-Type: application/json' \
  --data "{\"email\":\"$email\",\"password\":\"correct-horse-1\",\"displayName\":\"Phase 14 Performance\"}" \
  "$api_base/api/v1/auth/register" | jq --raw-output '.accessToken')"

timings_file="$(mktemp)"
trap 'rm -f "$timings_file"' EXIT

for ((request_number = 1; request_number <= iterations; request_number++)); do
  curl --fail --silent --show-error \
    --output /dev/null \
    --header "Authorization: Bearer $token" \
    --write-out '%{time_total}\n' \
    "$api_base/api/v1/dashboard" >> "$timings_file"
done

p95_ms="$(sort -n "$timings_file" | awk -v count="$iterations" 'NR == int((count * 95 + 99) / 100) { printf "%.0f", $1 * 1000 }')"
test -n "$p95_ms"
if (( p95_ms > max_p95_ms )); then
  echo "Performance smoke test failed: dashboard p95 ${p95_ms}ms > ${max_p95_ms}ms" >&2
  exit 1
fi

echo "Performance smoke test passed: dashboard p95 ${p95_ms}ms (${iterations} requests)"
