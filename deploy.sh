#!/usr/bin/env bash
# Deploy the static site to S3 and refresh CloudFront.
# Usage: BUCKET=my-bucket DISTRIBUTION_ID=E123ABC ./deploy.sh
set -euo pipefail

: "${BUCKET:?Set BUCKET}"
: "${DISTRIBUTION_ID:?Set DISTRIBUTION_ID}"
SITE_DIR="$(dirname "$0")/site"

# 1. Assets (fonts, css, js, images): cached 7 days on browsers and the edge
aws s3 sync "$SITE_DIR" "s3://$BUCKET" --delete \
  --exclude "*.html" --exclude "*.txt" \
  --cache-control "public, max-age=604800"

# 2. HTML / robots: always revalidated, so updates show up immediately
aws s3 sync "$SITE_DIR" "s3://$BUCKET" --delete \
  --exclude "*" --include "*.html" --include "*.txt" \
  --cache-control "public, max-age=0, must-revalidate"

# 3. Drop the edge cache
aws cloudfront create-invalidation --distribution-id "$DISTRIBUTION_ID" --paths "/*" >/dev/null
echo "Deployed to s3://$BUCKET and invalidated $DISTRIBUTION_ID"
