# =========================================================================================
# STAGE 1: The Builder Image
# =========================================================================================
FROM archlinux:latest AS builder

# 1. Initialize pacman and install dependencies from official repositories
#    - base-devel is the equivalent of build-essential
#    - git-delta is available in the official repos, so we don't need to download it manually
#    - jdk-openjdk provides the latest available OpenJDK (currently 22, not 25 yet)
RUN pacman-key --init && \
    pacman-key --populate && \
    pacman -Syu --noconfirm && \
    pacman -S --noconfirm --needed \
    # Build dependencies
    base-devel \
    curl \
    wget \
    gnupg \
    unzip \
    openssl \
    # Requested Tools
    zsh \
    git \
    git-lfs \
    git-crypt \
    fzf \
    fd \
    nodejs \
    npm \
    universal-ctags \
    cscope \
    jq \
    git-delta \
    jdk-openjdk \
    go \
    luacheck \
    yq \
    neovim \
    yarn \
    && pacman -Scc --noconfirm
# 5. Install Rust toolchain (rustc, cargo) and rust-analyzer
ENV RUSTUP_HOME=/usr/local/rustup
ENV CARGO_HOME=/usr/local/cargo
ENV PATH=/usr/local/cargo/bin:$PATH
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path \
    && rustup component add rust-analyzer

# 6. Configure git-graph (it's a git alias, writes to /root/.gitconfig)
RUN git config --global alias.graph "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)'"

# =========================================================================================
# STAGE 2: The Final Image
# =========================================================================================
# Start from a minimal Arch Linux base
FROM archlinux:latest

# 1. Install only the RUNTIME dependencies using pacman
# This is more robust than copying libraries from the builder stage.
RUN pacman-key --init && \
    pacman-key --populate && \
    pacman -Syu --noconfirm && \
    pacman -S --noconfirm --needed \
    # List all runtime tools here that were installed via pacman
    git \
    git-lfs \
    git-crypt \
    fzf \
    fd \
    nodejs \
    npm \
    universal-ctags \
    cscope \
    jq \
    yq \
    neovim \
    git-delta \
    jdk-openjdk \
    go \
    luacheck \
    && pacman -Scc --noconfirm

# 2. Copy the manually installed tools and configs from the builder stage
COPY --from=builder /usr/local /usr/local
COPY --from=builder /root/.gitconfig /root/.gitconfig

# Set environment variables required for the tools to work
ENV RUSTUP_HOME=/usr/local/rustup
ENV CARGO_HOME=/usr/local/cargo
# Arch symlinks the latest JDK to 'default-runtime', which is more stable than a hardcoded version
ENV JAVA_HOME=/usr/lib/jvm/default-runtime
ENV PATH="/usr/local/cargo/bin:/usr/local/go/bin:/usr/local/bin:/usr/bin:/bin:/sbin:/usr/sbin"

# Set a working directory
WORKDIR /work

# Default command to start a shell for interactive use
CMD ["/bin/bash"]
