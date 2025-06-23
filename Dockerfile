# Final stage
FROM debian:bullseye-slim

# Install wget and ca-certificates for downloading
RUN apt-get update && apt-get install -y wget ca-certificates && rm -rf /var/lib/apt/lists/*

# Download and install the latest stable Tailscale
# The executables will be placed in /usr/local/bin which is in the $PATH
RUN TS_VER=$(wget -qO- 'https://api.github.com/repos/tailscale/tailscale/releases/latest' | grep -oP '"tag_name":\s*"v\K[0-9.]+') && \
    wget -qO "tailscale.tgz" "https://pkgs.tailscale.com/stable/tailscale_${TS_VER}_amd64.tgz" && \
    tar xzf "tailscale.tgz" --strip-components=1 && \
    mv tailscale /usr/local/bin/ && \
    mv tailscaled /usr/local/bin/ && \
    rm "tailscale.tgz"

# Copy our run script
COPY run.sh /app/run.sh
RUN chmod +x /app/run.sh

# Set the entrypoint
WORKDIR /app
CMD ["./run.sh"]
