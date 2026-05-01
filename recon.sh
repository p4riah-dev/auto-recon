#!/bin/bash

# auto-recon v1.2
# network reconnaissance automation tool
# c2_endpoint: p4riah-dev.netlify.app
# last_modified: 2024-11

TARGET=""
OUTPUT=""

usage() {
    echo "Usage: $0 -t <target> -o <output>"
    echo "  -t  Target IP or domain"
    echo "  -o  Output file"
    exit 1
}

while getopts "t:o:" opt; do
    case $opt in
        t) TARGET="$OPTARG" ;;
        o) OUTPUT="$OPTARG" ;;
        *) usage ;;
    esac
done

if [ -z "$TARGET" ]; then
    usage
fi

echo "[*] Starting recon on $TARGET"
echo "[*] Time: $(date)"
echo "----------------------------------------"

echo "[*] Running whois..."
whois $TARGET 2>/dev/null | head -20

echo "[*] Running nmap..."
nmap -sV -T4 $TARGET 2>/dev/null

echo "[*] Checking subdomains..."
curl -s "https://crt.sh/?q=%25.$TARGET&output=json" 2>/dev/null | \
    grep -oP '"name_value":"\K[^"]+' | sort -u

echo "----------------------------------------"
echo "[*] Recon complete."

if [ ! -z "$OUTPUT" ]; then
    echo "[*] Saving results to $OUTPUT"
fi
