# FROM mcr.microsoft.com/devcontainers/anaconda:1-3
FROM mcr.microsoft.com/devcontainers/miniconda

ENV CONDA_PLUGINS_AUTO_ACCEPT_TOS=true

COPY .devcontainer/environment.yml .devcontainer/noop.txt /tmp/conda-tmp/
# COPY .devcontainer/environment_bioconda.yml .devcontainer/noop.txt /tmp/conda-tmp/

SHELL ["/bin/bash","-l", "-c"]

WORKDIR /root/

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends ufw openssh-server openssh-client\
    && apt-get -y install --no-install-recommends vim rsync git git-lfs \
    && apt-get -y install --no-install-recommends fuse s3fs
#<bioconda_dep> && apt-get -y install --no-install-recommends libgl-dev default-jre

RUN conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main && \
    conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r
#<bioconda_dep> && conda tos accept --override-channels --channel https://bioconda.github.io/recipes

RUN /opt/conda/bin/conda init bash && \
    /opt/conda/bin/conda config --add channels default && \
    #<bioconda_dep> /opt/conda/bin/conda config --add channels bioconda && \
    /opt/conda/bin/conda config --add channels conda-forge && \
    /opt/conda/bin/conda update --all -y -n base && \
    /opt/conda/bin/conda env update -f /tmp/conda-tmp/environment.yml && \
    #<bioconda_dep> /opt/conda/bin/conda env update -f /tmp/conda-tmp/environment_bioconda.yml && \
    /opt/conda/bin/conda update --all -y -n venv && \
    /opt/conda/bin/conda clean -afy

RUN rm -rf /tmp/conda-tmp


ENV PATH /opt/conda/bin:$PATH

RUN echo "conda activate venv" >> ~/.bashrc
ENTRYPOINT ["bash", "-l", "-c"]
