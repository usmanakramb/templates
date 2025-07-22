#!/bin/bash
set -e

# if [[ -z "$VAULT_ADDR" || -z "$VAULT_NAMESPACE" || -z "$VAULT_ROLE" ]]; then
if [[ -z "$VAULT_ADDR" || -z "$VAULT_ROLE" ]]; then
    echo "MISSING REQUIRED VARIABLES: VAULT_ROLE, VAULT_ADDR"
    exit 1
fi


echo "Logging in to Vault"

export VAULT_TOKEN=$(./vault write auth/jwt/login role="${VAULT_ROLE}" jwt="${ENV0_OIDC_TOKEN}" -format=json | jq --raw-output '.auth.client_token')

echo $VAULT_TOKEN

echo "Running some Vault commands"

./vault kv put -mount=secret creds passcode=my-password
./vault kv get -mount=secret -field=passcode creds
        
