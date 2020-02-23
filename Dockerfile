# Your version: 0.6.0 Latest version: 0.6.0
# Generated by Neurodocker version 0.6.0
# Timestamp: 2020-02-23 03:18:47 UTC
# 
# Thank you for using Neurodocker. If you discover any issues
# or ways to improve this software, please submit an issue or
# pull request on our GitHub repository:
# 
#     https://github.com/kaczmarj/neurodocker

FROM neurodebian:stretch-non-free

ARG DEBIAN_FRONTEND="noninteractive"

ENV LANG="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8" \
    ND_ENTRYPOINT="/neurodocker/startup.sh"
RUN export ND_ENTRYPOINT="/neurodocker/startup.sh" \
    && apt-get update -qq \
    && apt-get install -y -q --no-install-recommends \
           apt-utils \
           bzip2 \
           ca-certificates \
           curl \
           locales \
           unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && update-locale LANG="en_US.UTF-8" \
    && chmod 777 /opt && chmod a+s /opt \
    && mkdir -p /neurodocker \
    && if [ ! -f "$ND_ENTRYPOINT" ]; then \
         echo '#!/usr/bin/env bash' >> "$ND_ENTRYPOINT" \
    &&   echo 'set -e' >> "$ND_ENTRYPOINT" \
    &&   echo 'export USER="${USER:=`whoami`}"' >> "$ND_ENTRYPOINT" \
    &&   echo 'if [ -n "$1" ]; then "$@"; else /usr/bin/env bash; fi' >> "$ND_ENTRYPOINT"; \
    fi \
    && chmod -R 777 /neurodocker && chmod a+s /neurodocker

ENTRYPOINT ["/neurodocker/startup.sh"]

RUN bash -c 'apt-get update'

RUN apt-get update -qq \
    && apt-get install -y -q --no-install-recommends \
           git \
           datalad \
           graphviz \
           num-utils \
           gcc \
           g++ \
           curl \
           build-essential \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN test "$(getent passwd repronim)" || useradd --no-user-group --create-home --shell /bin/bash repronim
USER repronim

ENV CONDA_DIR="/opt/miniconda-latest" \
    PATH="/opt/miniconda-latest/bin:$PATH"
RUN export PATH="/opt/miniconda-latest/bin:$PATH" \
    && echo "Downloading Miniconda installer ..." \
    && conda_installer="/tmp/miniconda.sh" \
    && curl -fsSL --retry 5 -o "$conda_installer" https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && bash "$conda_installer" -b -p /opt/miniconda-latest \
    && rm -f "$conda_installer" \
    && conda update -yq -nbase conda \
    && conda config --system --prepend channels conda-forge \
    && conda config --system --set auto_update_conda false \
    && conda config --system --set show_channel_urls true \
    && sync && conda clean --all && sync \
    && conda create -y -q --name repronim \
    && conda install -y -q --name repronim \
           "python=3.7" \
           "notebook" \
           "ipython" \
           "numpy" \
           "pandas" \
           "traits" \
           "jupyter" \
           "jupyterlab" \
           "matplotlib" \
           "scikit-image" \
           "scikit-learn" \
           "seaborn" \
           "vtk" \
    && sync && conda clean --all && sync \
    && bash -c "source activate repronim \
    &&   pip install --no-cache-dir  \
             "ipywidgets" \
             "ipyevents" \
             "jupytext" \
             "nilearn" \
             "nistats" \
             "nibabel" \
             "jupytext" \
             "nipype" \
             "nilearn" \
             "datalad" \
             "ipywidgets" \
             "pythreejs" \
             "pybids" \
             "pynidm" \
             "reprozip" \
             "reproman"" \
    && rm -rf ~/.cache/pip/* \
    && sync \
    && sed -i '$isource activate repronim' $ND_ENTRYPOINT

RUN mkdir -p ~/.jupyter && echo c.NotebookApp.ip = \"0.0.0.0\" > ~/.jupyter/jupyter_notebook_config.py

ENTRYPOINT ["/neurodocker/startup.sh"]

COPY [".", "/home/repronim/module-stats"]

CMD ["jupyter", "notebook"]

RUN echo '{ \
    \n  "pkg_manager": "apt", \
    \n  "instructions": [ \
    \n    [ \
    \n      "base", \
    \n      "neurodebian:stretch-non-free" \
    \n    ], \
    \n    [ \
    \n      "run_bash", \
    \n      "apt-get update" \
    \n    ], \
    \n    [ \
    \n      "install", \
    \n      [ \
    \n        "git", \
    \n        "datalad", \
    \n        "graphviz", \
    \n        "num-utils", \
    \n        "gcc", \
    \n        "g++", \
    \n        "curl", \
    \n        "build-essential" \
    \n      ] \
    \n    ], \
    \n    [ \
    \n      "user", \
    \n      "repronim" \
    \n    ], \
    \n    [ \
    \n      "miniconda", \
    \n      { \
    \n        "conda_install": [ \
    \n          "python=3.7", \
    \n          "notebook", \
    \n          "ipython", \
    \n          "numpy", \
    \n          "pandas", \
    \n          "traits", \
    \n          "jupyter", \
    \n          "jupyterlab", \
    \n          "matplotlib", \
    \n          "scikit-image", \
    \n          "scikit-learn", \
    \n          "seaborn", \
    \n          "vtk" \
    \n        ], \
    \n        "pip_install": [ \
    \n          "ipywidgets", \
    \n          "ipyevents", \
    \n          "jupytext", \
    \n          "nilearn", \
    \n          "nistats", \
    \n          "nibabel", \
    \n          "jupytext", \
    \n          "nipype", \
    \n          "nilearn", \
    \n          "datalad", \
    \n          "ipywidgets", \
    \n          "pythreejs", \
    \n          "pybids", \
    \n          "pynidm", \
    \n          "reprozip", \
    \n          "reproman" \
    \n        ], \
    \n        "create_env": "repronim", \
    \n        "activate": true \
    \n      } \
    \n    ], \
    \n    [ \
    \n      "run", \
    \n      "mkdir -p ~/.jupyter && echo c.NotebookApp.ip = \\\"0.0.0.0\\\" > ~/.jupyter/jupyter_notebook_config.py" \
    \n    ], \
    \n    [ \
    \n      "entrypoint", \
    \n      "/neurodocker/startup.sh" \
    \n    ], \
    \n    [ \
    \n      "copy", \
    \n      [ \
    \n        ".", \
    \n        "/home/repronim/module-stats" \
    \n      ] \
    \n    ], \
    \n    [ \
    \n      "cmd", \
    \n      [ \
    \n        "jupyter", \
    \n        "notebook" \
    \n      ] \
    \n    ] \
    \n  ] \
    \n}' > /neurodocker/neurodocker_specs.json
