# Final stage
FROM debian:bullseye-slim

# Install wget and ca-certificates for downloading
RUN apt-get update && apt-get install -y wget ca-certificates && rm -rf /var/lib/apt/lists/*

# Set a specific, known-good, recent version of Tailscale. This is the most reliable method.
ENV TAILSCALE_VERSION="1.66.0"
ENV TS_FILE="tailscale_${TAILSCALE_VERSION}_amd64.tgz"

# Download, extract, and move the executables to a standard location in the $PATH
RUN wget -qO "${TS_FILE}" "https://pkgs.tailscale.com/stable/${TS_FILE}" && \
    tar xzf "${TS_FILE}" --strip-components=1 && \
    mv tailscale /usr/local/bin/ && \
    mv tailscaled /usr/local/bin/ && \
    rm "${TS_FILE}"

# Copy our run script which contains the correct flags
COPY run.sh /app/run.sh
RUN chmod +x /app/run.sh

# Set the working directory and the final command
WORKDIR /app
CMD ["./run.sh"]
