# .devcontainer/Dockerfile

# Stage 1: use the pre_built image if it exists.
# docker commit COMMIT_ID py312_devcontainer:latest
FROM py312_devcontainer:latest as custom

# Stage 2: use a base Python 3.12 image
FROM python:3.12-slim-bookworm

# Install system dependencies
# 'build-essential' for compiling native extensions, 'git' for version control,
# 'curl' for downloading, 'libpq-dev' for PostgreSQL client (if needed), etc.
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends build-essential git curl sudo \
    && mkdir -p /etc/sudoers.d/ \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Create a non-root user 'vscode' with sudo access and set it as the default
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=1000
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && usermod -aG sudo $USERNAME \
    && echo $USERNAME ALL=\(ALL\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME
USER $USERNAME

# Install pipx and Poetry as the 'vscode' user
ENV PIPX_HOME=/home/vscode/.local/pipx
ENV PIPX_BIN_DIR=/home/vscode/.local/bin
ENV PATH="${PATH}:${PIPX_BIN_DIR}"
RUN pip install --no-cache-dir --user pipx \
    && python3 -m pipx ensurepath

# Install Poetry using pipx
RUN pipx install poetry==1.8.2 # Specify a version for consistency

# Set the working directory
WORKDIR /workspaces/vscode_devcontainer_py.git

# Copy project dependency files and install them
# This is done before copying the rest of the code to leverage Docker layer caching.
# The layer will only be rebuilt if these files change.
COPY --chown=vscode:vscode ../pyproject.toml ./
# COPY --chown=vscode:vscode ../poetry.lock ./
RUN poetry install --no-root

ENTRYPOINT ["bash", "-l", "-c"]
