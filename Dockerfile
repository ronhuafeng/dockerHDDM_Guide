# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.

# This Dockerfile is for DDM tutorial
# The buid from the base of minimal-notebook, based on python 3.8.8
# 
ARG BASE_CONTAINER=jupyter/minimal-notebook:python-3.8.8
FROM $BASE_CONTAINER

LABEL maintainer="Hu Chuan-Peng <hcp4715@hotmail.com>"

USER root

# ffmpeg for matplotlib anim & dvipng for latex labels
RUN apt-get update && \
    apt-get install -y --no-install-recommends apt-utils && \
    apt-get install -y --no-install-recommends ffmpeg dvipng && \
    # apt-get install -y --no-install-recommends python3.8-gdbm && \
    rm -rf /var/lib/apt/lists/*

USER $NB_UID

# Install Python 3 packages
RUN conda install --quiet --yes \
    'arviz=0.11.4' \
    'beautifulsoup4=4.9.*' \
    'conda-forge::blas=*=openblas' \
    'bokeh=2.4.*' \
    'bottleneck=1.3.*' \
    'cloudpickle=1.4.*' \
    'cython=0.29.*' \
    'dask=2.15.*' \
    # dill must be 0.3.4
    'dill=0.3.4' \
    'git' \
    'h5py=2.10.*' \
    'hdf5=1.10.*' \
    'ipywidgets=7.6.*' \
    'ipympl=0.8.*'\
    'jupyter_bokeh' \
    'jupyterlab_widgets' \
    'matplotlib-base=3.3.*' \
    'mkl-service' \
    'numba=0.54.*' \
    'numexpr=2.7.*' \
    'pandas=1.3.5' \
    'patsy=0.5.*' \
    'protobuf=3.11.*' \
    'pytables=3.6.*' \
    'scikit-image=0.16.*' \
    'scikit-learn=0.22.*' \
    'scipy=1.7.3' \
    'seaborn=0.11.*' \
    'sqlalchemy=1.3.*' \
    'statsmodels=0.11.*' \
    'sympy=1.5.*' \
    'vincent=0.4.*' \
    'widgetsnbextension=3.5.*'\
    'xlrd=1.2.*' \
    'xarray=0.19.0' \
    # 'ipyparallel=6.3.0' \
    'pymc=2.3.8' \
    && \
    conda clean --all -f -y && \
    fix-permissions "/home/${NB_USER}"

# conda install --channel=numba llvmlite
# pip install sparse
# conda install -c conda-forge python-graphviz
  
USER $NB_UID
RUN pip install --upgrade pip && \
    # pip install --no-cache-dir 'kabuki==0.6.4' && \
    pip install --no-cache-dir 'hddm==0.8.0' && \
    # pip install --no-cache-dir 'feather-format' && \
    # install plotly and its chart studio extension
    # pip install --no-cache-dir 'chart_studio==1.1.0' && \
    pip install --no-cache-dir 'plotly==4.14.3' && \
    pip install --no-cache-dir 'cufflinks==0.17.3' && \
    # install ptitprince for raincloud plot in python
    pip install --no-cache-dir 'ptitprince==0.2.*' && \
    # pip install --no-cache-dir 'kabuki==0.6.3' && \
    pip install --no-cache-dir 'multiprocess==0.70.12.2' && \
    pip install --no-cache-dir 'pathos==0.2.8' && \
    pip install --no-cache-dir 'p_tqdm' && \
    # pip install --no-cache-dir 'paranoid-scientist' && \
    # pip install --no-cache-dir 'pyddm' && \
    # pip install --no-cache-dir 'pymc3==3.11.*' && \
    # pip install --no-cache-dir 'bambi==0.6.*' && \
    pip install --no-cache-dir git+https://github.com/hddm-devs/kabuki.git@57338156ffbd449e54227b3123f6b9d0b40179ca && \
    # pip install --no-cache-dir git+https://github.com/hddm-devs/kabuki.git@0616114cb95d8c7d136fa5bd8f67c9907838e5dd && \
    # pip install --no-cache-dir git+https://github.com/hddm-devs/hddm.git@3dcf4af58f2b7ce44c8b7e6a2afb21073d0a5ef9 && \
    fix-permissions "/home/${NB_USER}"

# Import matplotlib the first time to build the font cache.
ENV XDG_CACHE_HOME="/home/${NB_USER}/.cache/"

RUN MPLBACKEND=Agg python -c "import matplotlib.pyplot" &&\
     fix-permissions "/home/${NB_USER}"

# USER $NB_UID
# WORKDIR $HOME

# # Change the configuration of ipyparallel
# RUN sed -i  "/# Configuration file for jupyter-notebook./a c.NotebookApp.server_extensions.append('ipyparallel.nbextension')"  /home/jovyan/.jupyter/jupyter_notebook_config.py

# USER $NB_UID
# RUN jupyter nbextension enable --py widgetsnbextension --sys-prefix && \
#     jupyter labextension install @jupyter-widgets/jupyterlab-manager --no-build && \
#     jupyter labextension install jupyter-matplotlib --no-build && \
#     jupyter lab build && \
#         jupyter lab clean && \
#         jlpm cache clean && \
#         npm cache clean --force && \
#         rm -rf "/home/${NB_USER}/.cache/yarn" && \
#         rm -rf "/home/${NB_USER}/.node-gyp" && \
#     fix-permissions "/home/${NB_USER}"

# # USER root
# RUN jupyter notebook --generate-config -y

USER $NB_UID
WORKDIR $HOME

# Copy example data and scripts to the example folder
RUN mkdir /home/$NB_USER/scripts && \
    rm -r /home/$NB_USER/work && \
    fix-permissions /home/$NB_USER

COPY /temp/Tutorial_DDM_docker.ipynb /home/${NB_USER}/scripts
COPY /scripts/HDDMarviz.py /home/${NB_USER}/scripts
COPY /scripts/plot_ppc_by_cond.py /home/${NB_USER}/scripts
COPY /scripts/pointwise_loglik_gen.py /home/${NB_USER}/scripts
COPY /scripts/post_pred_gen_redefined.py /home/${NB_USER}/scripts
COPY /scripts/InferenceDataFromHDDM.py /home/${NB_USER}/scripts

