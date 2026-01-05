#!/usr/bin/env bash
# Trigger Komodo webhook
# Usage: ./trigger-komodo-webhook.sh <secret> [branch]
#   secret - webhook secret (or set KOMODO_WEBHOOK_SECRET env var)
#   branch - git branch to trigger (default: main)

SECRET="${1:-$KOMODO_WEBHOOK_SECRET}"
BRANCH="${2:-main}"
PAYLOAD="{\"ref\":\"refs/heads/$BRANCH\"}"
SIGNATURE="sha256=$(echo -n "$PAYLOAD" | openssl dgst -sha256 -hmac "$SECRET" | awk '{print $2}')"

curl -sw "%{http_code}\n" \
  "https://komodo.wsiwiec.com/listener/github/procedure/695b1e462652deb41b6edd4b/$BRANCH" \
  -H "X-Hub-Signature-256: $SIGNATURE" \
  -d "$PAYLOAD"

# Example workflow:
# add KOMODO_WEBHOOK_SECRET to your repository secrets.

# - name: Trigger Komodo
#   run: ./webhooks/trigger-komodo-webhook.sh "${{ secrets.KOMODO_WEBHOOK_SECRET }}"

# Or inline without the script:

# - name: Trigger Komodo
#   env:
#     SECRET: ${{ secrets.KOMODO_WEBHOOK_SECRET }}
#   run: |
#     PAYLOAD='{"ref":"refs/heads/main"}'
#     SIGNATURE="sha256=$(echo -n "$PAYLOAD" | openssl dgst -sha256 -hmac "$SECRET" | awk '{print $2}')"
#     curl -sw "%{http_code}\n" \
#       "https://komodo.wsiwiec.com/listener/github/procedure/695b1e462652deb41b6edd4b/main" \
#       -H "X-Hub-Signature-256: $SIGNATURE" \
#       -d "$PAYLOAD"