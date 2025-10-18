# Latest Ubuntu + common dev deps + Hare (bootstrapped)
FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# 1) Base tools & build deps
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    curl \
    git \
    make \
    ninja-build \
    pkg-config \
    vim \
    sudo \
    python3 \
    python3-pip \
    python3-venv \
    scdoc \
    # useful extras
    less \
    file \
    wget \
  && rm -rf /var/lib/apt/lists/*

# 2) Build & install QBE (Hare depends on it)
# QBE uses a plain Makefile: `make` then `make install` (PREFIX supported).
# See: https://c9x.me/compile/ and mirrored README notes.
RUN set -eux; \
    git clone git://c9x.me/qbe.git /tmp/qbe || git clone https://github.com/ibara/qbe.git /tmp/qbe; \
    make -C /tmp/qbe; \
    make -C /tmp/qbe install PREFIX=/usr/local; \
    rm -rf /tmp/qbe

# 3) Build & install harec (bootstrap compiler)
# Follow Hare docs: copy platform config, make, (optional make check), install.
RUN set -eux; \
    git clone https://git.sr.ht/~sircmpwn/harec /tmp/harec; \
    cp /tmp/harec/configs/linux.mk /tmp/harec/config.mk; \
    make -C /tmp/harec; \
    make -C /tmp/harec install; \
    rm -rf /tmp/harec

# 4) Build & install Hare standard library & tools (provides `hare`, `haredoc`, etc.)
RUN set -eux; \
    git clone https://git.sr.ht/~sircmpwn/hare /tmp/hare; \
    cp /tmp/hare/configs/linux.mk /tmp/hare/config.mk; \
    make -C /tmp/hare; \
    make -C /tmp/hare install; \
    rm -rf /tmp/hare


USER ${USERNAME}
WORKDIR /workspace

# Keep PATH standard; Hare installs to /usr/local by default
ENV PATH="/usr/local/bin:${PATH}"

# Quick health check: show versions when container starts
CMD ["/bin/bash", "-lc", "set -e; echo 'qbe:' $(qbe -V 2>/dev/null || echo not found); echo 'harec:' $(command -v harec || echo not found); echo 'hare:' $(command -v hare || echo not found); bash"]
