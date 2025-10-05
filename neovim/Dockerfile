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
  cmake \
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
  wl-clipboard \
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
  luarocks \
  # --- Language Support: Python ---
  python \
  python-pip \
  # --- Language Support: Rust ---
  rustup \
  rust-analyzer \
  # --- Language Support: Golang ---
  go \
  gopls \
  # Clean up package cache to keep the image small
  && pacman -Scc --noconfirm

# Layer 2: Create a non-root user for better security and permissions
# User will have the same UID/GID as a typical default user on Linux (1000)
# This can be overridden at build time with --build-arg USER_ID=xxx --build-arg GROUP_ID=xxx
# NOTE: If running into problems, check your current UID/GID with `id -u` and `id -g`
ARG USER_ID=1000
ARG GROUP_ID=1000
ARG USERNAME=dev
RUN groupadd --gid $GROUP_ID ${USERNAME} && \
  useradd --uid $USER_ID --gid $GROUP_ID -m -s /bin/zsh ${USERNAME}

# Switch to the new user
USER ${USERNAME}
WORKDIR /home/${USERNAME}

# Configure User Environment (Git, Rust)
RUN \
  # Configure git alias for the user
  git config --global alias.graph "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)'" && \
  # Install the default Rust toolchain using rustup
  rustup default stable

# Add Rust's cargo bin to the PATH
ENV PATH="/home/${USERNAME}/.cargo/bin:${PATH}"

# Pre-install Neovim plugins
# This is the magic step. We copy the config and run the plugin manager headlessly.
# IMPORTANT: This assumes your nvim config is in a directory named '.config/nvim'
#            in the same directory as this Dockerfile when you build.
ADD --chown=${USERNAME}:${USERNAME} https://raw.githubusercontent.com/awzmb/wmconfig/refs/heads/master/.config/nvim/init.lua /home/${USERNAME}/.config/nvim/init.lua

# Install lazy.nvim plugin manager
RUN git clone --filter=blob:none https://github.com/folke/lazy.nvim.git --branch=stable /home/${USERNAME}/.local/share/nvim/lazy/lazy.nvim

# Install plugins using lazy.nvim
RUN nvim --headless "+Lazy! sync" "+Mason" "+qa"

# Install Mason packages
# RUN nvim --headless +"lua require('nvchad.mason').install_all()" +"autocmd User MasonUpdateAllComplete qa"
RUN nvim --headless -c "MasonInstall lua-language-server rust-analyzer helm-ls terraform-ls pyright gopls yaml-language-server dockerfile-language-server json-lsp bash-language-server tflint tfsec luacheck kube-linter hclfmt" -c qall

# Set the default working directory for the container
WORKDIR /workspace

# Default command to start Neovim
CMD ["/usr/bin/nvim"]
