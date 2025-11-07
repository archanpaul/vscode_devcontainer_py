# .devcontainer/Dockerfile

# Stage 1: use the pre_built image if it exists.
# docker commit COMMIT_ID ml_devcontainer:latest
FROM localhost/ml_devcontainer:latest as custom

# Stage 2: use a base Python 3.12 image
FROM python:3.12-slim-bookworm

# Install system dependencies
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends build-essential git curl sudo openssh-client openssh-server \
    && mkdir -p /etc/sudoers.d/ \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Configure SSH server
RUN mkdir -p /var/run/sshd \
    && echo 'root:root' | chpasswd \
    && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -i 's@session\\s*required\\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd

# Create a non-root user 'vscode' with sudo access and set it as the default
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=1000
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && usermod -aG sudo $USERNAME \
    && echo '$USERNAME ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

USER $USERNAME

# Install pipx and Poetry as the 'vscode' user
ENV PIPX_HOME=/home/vscode/.local/pipx
ENV PIPX_BIN_DIR=/home/vscode/.local/bin
ENV PATH="${PATH}:${PIPX_BIN_DIR}"
RUN pip install --no-cache-dir --user pipx \
    && python3 -m pipx ensurepath

# Install Poetry using pipx
RUN pipx install poetry

# Set the working directory
WORKDIR /workspaces/vscode_devcontainer_py.git

# Copy project dependency files and install them
COPY --chown=vscode:vscode ../pyproject.toml ../poetry.lock ./
RUN poetry install --no-root --with dev --without web,ml

# Force all commands through a login shell
ENTRYPOINT ["bash", "-l", "-c"]

# Default command if none is provided
CMD ["bash"]
