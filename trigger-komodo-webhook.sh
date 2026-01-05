#!/usr/bin/env bash
# Trigger Komodo webhook
# Usage: ./trigger-komodo-webhook.sh <secret> [branch] [webhook_url]
#   secret      - webhook secret (or set KOMODO_WEBHOOK_SECRET env var)
#   branch      - git branch to trigger (default: main)
#   webhook_url - webhook URL (or set KOMODO_WEBHOOK_URL env var)

SECRET="${1:-$KOMODO_WEBHOOK_SECRET}"
BRANCH="${2:-main}"
WEBHOOK_URL="${3:-$KOMODO_WEBHOOK_URL}"
PAYLOAD="{\"ref\":\"refs/heads/$BRANCH\"}"
SIGNATURE="sha256=$(echo -n "$PAYLOAD" | openssl dgst -sha256 -hmac "$SECRET" | awk '{print $2}')"

curl -sw "%{http_code}\n" \
  "$WEBHOOK_URL" \
  -H "X-Hub-Signature-256: $SIGNATURE" \
  -d "$PAYLOAD"

# Example GitHub Actions workflow:
# Add KOMODO_WEBHOOK_SECRET and KOMODO_WEBHOOK_URL to your repository secrets.

# - name: Trigger Komodo
#   run: ./trigger-komodo-webhook.sh "${{ secrets.KOMODO_WEBHOOK_SECRET }}" "main" "${{ secrets.KOMODO_WEBHOOK_URL }}"

# Or using env vars:

# - name: Trigger Komodo
#   env:
#     KOMODO_WEBHOOK_SECRET: ${{ secrets.KOMODO_WEBHOOK_SECRET }}
#     KOMODO_WEBHOOK_URL: ${{ secrets.KOMODO_WEBHOOK_URL }}
#   run: ./trigger-komodo-webhook.sh