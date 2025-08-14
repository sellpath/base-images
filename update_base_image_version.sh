#!/bin/bash
# Update base_image_version.txt in all Docker build contexts

set -e

for dir in postgres run_stage build_stage ui_run_stage; do
  cp -f base_image_version.txt "$dir/base_image_version.txt"
done

echo "base_image_version.txt updated in all build contexts."
