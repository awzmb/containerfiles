FROM archlinux:base-20250928.0.426921@sha256:9a72b5e3c1675683016cb065f513deea7c65836cb5bd22b88c89353098faa40f

RUN pacman-key --init && \
  pacman-key --populate && \
  pacman -Syu --noconfirm && \
  pacman -S --noconfirm --needed \
  # basic tooling
  base-devel \
  curl \
  wget \
  gnupg \
  unzip \
  openssl \
  zsh \
  git \
  git-lfs \
  git-crypt \
  git-delta \
  git \
  git-lfs \
  git-crypt \
  jq \
  yq \
  fzf \
  fd \
  ripgrep \
  neovim \
  jdk-openjdk \
  luacheck \
  # rust support
  rust \
  rustup \
  rust-analyzer \
  cargo \
  cscope \
  ctags \
  # python support  
  python \
  python-pip \
  python-neovim \
  # javascript/ts support
  nodejs \
  npm \
  yarn \
  && pacman -Scc --noconfirm

# configure git-graph (it's a git alias, writes to /root/.gitconfig)
RUN git config --global alias.graph "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)'"

# set a working directory
WORKDIR /workspace

# default command to start a shell for interactive use
CMD ["/usr/bin/nvim"]
