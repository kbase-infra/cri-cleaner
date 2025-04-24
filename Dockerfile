# Use the ubuntu:latest base image.
FROM ubuntu:latest

# Install necessary packages: curl (needed to download crictl)
RUN apt-get update && apt-get install -y \
    curl \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*


ARG CRICTL_VERSION="v1.33.0"
RUN curl -L "https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.33.0/crictl-v1.33.0-linux-amd64.tar.gz" \
    | tar -xz -C /usr/local/bin/


# Copy the script into the container.
# We'll define the script content below or assume it's in a local file named 'prune_loop.sh'.
COPY prune_loop.sh /usr/local/bin/prune_loop.sh

# Make the script executable.
RUN chmod +x /usr/local/bin/prune_loop.sh

# The command to run when the container starts.
# This executes the script that contains the infinite pruning loop.
CMD ["/usr/local/bin/prune_loop.sh"]
