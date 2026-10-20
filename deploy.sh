#!/usr/bin/env bash
# Deploy the static site to S3 and refresh CloudFront.
# Usage: BUCKET=my-bucket DISTRIBUTION_ID=E123ABC ./deploy.sh
set -euo pipefail

: "${BUCKET:?Set BUCKET}"
: "${DISTRIBUTION_ID:?Set DISTRIBUTION_ID}"
SITE_DIR="$(dirname "$0")/site"

# 1. Fonts: renamed when they change, so they can be cached for a long time
aws s3 sync "$SITE_DIR" "s3://$BUCKET" --delete \
  --exclude "*" --include "assets/fonts/*" \
  --cache-control "public, max-age=31536000, immutable"

# 2. Everything else (HTML, CSS, JS, favicon, robots): revalidated on every visit,
#    so a new index.html never meets an old style.css cached in the browser
aws s3 sync "$SITE_DIR" "s3://$BUCKET" --delete \
  --exclude "assets/fonts/*" \
  --cache-control "public, max-age=0, must-revalidate"

# 3. Drop the edge cache
aws cloudfront create-invalidation --distribution-id "$DISTRIBUTION_ID" --paths "/*" >/dev/null
echo "Deployed to s3://$BUCKET and invalidated $DISTRIBUTION_ID"
