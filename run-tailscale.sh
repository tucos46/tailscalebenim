#!/bin/sh
set -e

# Start the tailscaled daemon in the background
/render/tailscaled &

# Bring the tailscale network up, with our required flags
# This command will stay in the foreground, keeping the container alive
/render/tailscale up \
  --authkey="${TAILSCALE_AUTHKEY}" \
  --hostname="${RENDER_SERVICE_NAME}" \
  --advertise-routes="${ROUTES}" \
  --accept-routes \
  --net=userspace \
  --advertise-exit-node \
  "$@"

# Wait for the tailscaled background process to exit
wait $!
