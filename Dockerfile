# Use the ubuntu:latest base image.
FROM ubuntu:latest

# Install necessary packages: curl (needed to download crictl)
RUN apt-get update && apt-get install -y \
    curl \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*


ARG CRICTL_VERSION="v1.33.0"
RUN echo "Downloading crictl version ${CRICTL_VERSION}..." && \
    curl -L "https://github.com/kubernetes-sigs/cri-tools/releases/download/${CRICTL_VERSION}/crictl-${CRICTL_VERSION}-linux-amd64.tar.gz" -o /tmp/crictl.tar.gz && \
    echo "Download complete. Extracting..." && \
    tar -xzf /tmp/crictl.tar.gz -C /usr/local/bin/ && \
    echo "Extraction complete. Cleaning up..." && \
    rm /tmp/crictl.tar.gz && \
    echo "crictl installed successfully."

# Copy the script into the container.
# We'll define the script content below or assume it's in a local file named 'prune_loop.sh'.
COPY prune_loop.sh /usr/local/bin/prune_loop.sh

# Make the script executable.
RUN chmod +x /usr/local/bin/prune_loop.sh

# The command to run when the container starts.
# This executes the script that contains the infinite pruning loop.
CMD ["/usr/local/bin/prune_loop.sh"]
