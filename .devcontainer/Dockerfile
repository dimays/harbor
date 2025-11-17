# Use lightweight Debian image
FROM debian:bookworm-slim

# Avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install common CLI tools
RUN apt-get update && apt-get install -y \
    git \
    curl \
    wget \
    vim \
    bash-completion \
    unzip \
    gnupg \
    lsb-release \
    sudo \
    rsync \
    && rm -rf /var/lib/apt/lists/*

# Install GitHub CLI
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt-get update && apt-get install -y gh \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /workspace

# Non-root user
RUN useradd -ms /bin/bash vscode \
    && usermod -aG sudo vscode
USER vscode

SHELL ["/bin/bash", "-c"]
