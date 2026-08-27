#!/usr/bin/env bash
# Renders every diagram to public/markdown/gaussian-splat-surfaces/imgs.
# Asymptote exits 0 even on a compile error, so treat any diagnostic as fatal.
set -uo pipefail
cd "$(dirname "$0")"
out=../../../../public/markdown/gaussian-splat-surfaces/imgs
mkdir -p "$out"
status=0
for f in *.asy; do
    [ "$f" = "common.asy" ] && continue
    err=$(asy -f svg "$f" 2>&1)
    if [ -n "$err" ]; then
        echo "FAIL $f"
        echo "$err" | sed 's/^/    /'
        status=1
        continue
    fi
    mv "${f%.asy}.svg" "$out/"
    echo "  ok $f"
done
echo "rendered $(ls "$out"/*.svg 2>/dev/null | wc -l) diagrams into $out"
exit $status
