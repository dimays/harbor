# Use official Python 3.12 Dev Container image
FROM mcr.microsoft.com/devcontainers/python:3.12

# Install common Linux packages
RUN apt-get update && apt-get install -y \
    git \
    curl \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Set working directory (VSCode mounts your project here)
WORKDIR /workspace

# Use non-root user
USER vscode

# Default shell
SHELL ["/bin/bash", "-c"]
