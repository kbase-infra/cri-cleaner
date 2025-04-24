# Use the ubuntu:latest base image.
FROM ubuntu:latest

# Install necessary packages: curl (needed to download crictl)
RUN apt-get update && apt-get install -y \
    wget \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*


ARG CRICTL_VERSION="v1.33.0"

COPY ./crictl-v1.33.0-linux-amd64.tar.gz /tmp/crictl.tar.gz
# Install crictl
RUN tar -C /usr/local/bin -xzf /tmp/crictl.tar.gz && \
    rm /tmp/crictl.tar.gz && \
    chmod +x /usr/local/bin/crictl

COPY prune_loop.sh /usr/local/bin/prune_loop.sh

# Make the script executable.
RUN chmod +x /usr/local/bin/prune_loop.sh

# The command to run when the container starts.
# This executes the script that contains the infinite pruning loop.
CMD ["/usr/local/bin/prune_loop.sh"]
