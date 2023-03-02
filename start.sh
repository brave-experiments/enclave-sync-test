#!/bin/sh

set -x

domain="star-randsrv.bsg.brave.software"
key_material="foobar"

echo "[+] Starting nitriding."
nitriding \
    -fqdn "$domain" \
    -sync-with "$domain" &

sleep 1

echo "[+] Registering pseudo-secret key material."
curl --silent \
     --include \
     -X PUT \
     -d "{\"secret\":\"${key_material}\"}" \
     "http://127.0.0.1:8080/enclave/state" || \
     echo "[+] Failed with exit code ${?}."

while : ; do
    sleep 5
    curl --silent \
         --include \
         "http://127.0.0.1:8080/enclave/state" && break
done

echo "[+] Sync succeeded.  Terminating."
