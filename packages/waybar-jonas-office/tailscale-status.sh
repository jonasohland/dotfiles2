#!/bin/sh

if tailscale status | grep -q "is stopped" >/dev/null; then
  printf '{"text":"", "tooltip": "Tailscale - Down", "class": "disabled"}'
else
  printf '{"text":"", "tooltip": "Tailscale - Up"}'
fi
