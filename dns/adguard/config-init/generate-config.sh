#!/bin/sh
set -e

CONFIG_TEMPLATE="/template/AdGuardHome.template.yaml"
CONFIG_FILE="/config/AdGuardHome.yaml"

echo "Starting config generation..."

# Check required variables
if [ -z "$ADGUARD_USER" ] || [ -z "$ADGUARD_PASSWORD" ]; then
    echo "Error: ADGUARD_USER and ADGUARD_PASSWORD must be set"
    exit 1
fi

# Generate bcrypt hash from plain password
echo "Generating password hash..."
ADGUARD_PASSWORD_HASH=$(htpasswd -nbBC 10 "" "$ADGUARD_PASSWORD" | tr -d ':\n' | sed 's/\$2y/\$2a/')

# Generate config from template
if [ -f "$CONFIG_TEMPLATE" ]; then
    echo "Generating AdGuard config..."
    ESCAPED_HASH=$(printf '%s\n' "$ADGUARD_PASSWORD_HASH" | sed 's/[&/\$]/\\&/g')
    sed -e "s/\${ADGUARD_USER}/$ADGUARD_USER/g" \
        -e "s/\${ADGUARD_PASSWORD_HASH}/$ESCAPED_HASH/g" \
        "$CONFIG_TEMPLATE" > "$CONFIG_FILE"
    echo "Config generated successfully: $CONFIG_FILE"
else
    echo "Error: Template not found: $CONFIG_TEMPLATE"
    exit 1
fi

echo "Config initialization complete."
