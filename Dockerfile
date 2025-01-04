FROM debian:bookworm-slim

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install required packages for .NET Core and the GitHub Actions runner
RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    curl \
    git \
    libicu-dev \
    libc6-dev \
    libssl-dev \
    libkrb5-dev \
    tzdata \
    ca-certificates \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user for security
RUN groupadd -r github && useradd -r -g github github

# Grant sudo privileges to the github user
RUN echo "github ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Set working directory
WORKDIR /home/github/actions-runner

# Define build-time arguments
ARG GH_RUNNER_VERSION=2.321.0
ARG GH_RUNNER_HASH=62cc5735d63057d8d07441507c3d6974e90c1854bdb33e9c8b26c0da086336e1
ARG GH_RUNNER_ARCH=linux-arm64

# Download the GitHub Actions runner package
ENV GH_RUNNER_URL=https://github.com/actions/runner/releases/download/v${GH_RUNNER_VERSION}/actions-runner-${GH_RUNNER_ARCH}-${GH_RUNNER_VERSION}.tar.gz

RUN curl -o actions-runner.tar.gz -L ${GH_RUNNER_URL} \
    && echo "${GH_RUNNER_HASH}  actions-runner.tar.gz" | sha256sum -c - \
    && tar xzf actions-runner.tar.gz \
    && rm actions-runner.tar.gz

# Copy the entrypoint script into the container
COPY entrypoint.sh /home/github/actions-runner/entrypoint.sh
RUN chmod +x /home/github/actions-runner/entrypoint.sh

# Define environment variables for runner configuration
ENV RUNNER_NAME=raspberry-pi-runner
ENV RUNNER_LABELS=self-hosted,raspberry-pi,docker
ENV RUNNER_WORKDIR=_work

# Switch to the github user
USER github

# Entrypoint to configure and run the runner
ENTRYPOINT ["/home/github/actions-runner/entrypoint.sh"]