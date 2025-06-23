#!/bin/sh
set -e

echo "Starting tailscaled..."
# Start the daemon in the background
tailscaled &

# Give it a moment to come up
sleep 3

echo "Bringing tailscale up..."
# Bring the tailscale network up, with our required flags
tailscale up \
  --authkey="${TAILSCALE_AUTHKEY}" \
  --hostname="${RENDER_SERVICE_NAME}" \
  --advertise-routes="${ROUTES}" \
  --accept-routes \
  --net=userspace \
  --advertise-exit-node

echo "Tailscale is up. Waiting for daemon to exit."
# Wait for the tailscaled background process to exit
wait $!
