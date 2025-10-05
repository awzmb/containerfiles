FROM archlinux:base-20250928.0.426921@sha256:9a72b5e3c1675683016cb065f513deea7c65836cb5bd22b88c89353098faa40f

# Layer 1: System Packages & Setup
RUN \
  # Initialize package manager keys and update the system
  pacman-key --init && \
  pacman-key --populate && \
  pacman -Syu --noconfirm && \
  # Install all necessary packages in a single, alphabetized list
  pacman -S --noconfirm --needed \
  # --- Core Development Tools ---
  base-devel \
  ctags \
  curl \
  fd \
  fzf \
  git \
  git-crypt \
  git-delta \
  git-lfs \
  gnupg \
  jq \
  neovim \
  openssl \
  ripgrep \
  unzip \
  wget \
  yq \
  zsh \
  # --- Language Support: Java ---
  jdk-openjdk \
  # --- Language Support: Javascript/TypeScript ---
  nodejs \
  npm \
  yarn \
  # --- Language Support: Lua (for Neovim) ---
  luacheck \
  # --- Language Support: Python ---
  python \
  python-pip \
  # --- Language Support: Rust ---
  # We install rustup to manage the toolchain, which is more flexible.
  rustup \
  # Clean up package cache to keep the image small
  && pacman -Scc --noconfirm

# Layer 2: Create a non-root user for better security and permissions
# User will have the same UID/GID as a typical default user on Linux (1000)
# This can be overridden at build time with --build-arg USER_ID=xxx --build-arg GROUP_ID=xxx
# NOTE: If running into problems, check your current UID/GID with `id -u` and `id -g`
ARG USER_ID=1000
ARG GROUP_ID=1000
RUN groupadd --gid $GROUP_ID dev && \
  useradd --uid $USER_ID --gid $GROUP_ID -m -s /bin/zsh dev

# Switch to the new user
USER dev
WORKDIR /home/dev

# Layer 3: Configure User Environment (Git, Rust)
RUN \
  # Configure git alias for the 'dev' user
  git config --global alias.graph "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)'" && \
  # Install the default Rust toolchain using rustup
  rustup default stable

# Add Rust's cargo bin to the PATH
ENV PATH="/home/dev/.cargo/bin:${PATH}"

# Layer 4: Pre-install Neovim plugins
# This is the magic step. We copy the config and run the plugin manager headlessly.
# IMPORTANT: This assumes your nvim config is in a directory named '.config/nvim'
#            in the same directory as this Dockerfile when you build.
ADD --chown=dev:dev https://raw.githubusercontent.com/awzmb/wmconfig/refs/heads/master/.config/nvim/init.lua /home/dev/.config/nvim/init.lua

# Install plugins using lazy.nvim
RUN nvim --headless "+Lazy! sync" +qa

# Set the default working directory for the container
WORKDIR /workspace

# Default command to start Neovim
CMD ["/usr/bin/nvim"]
