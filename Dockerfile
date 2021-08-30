ARG BASE_IMAGE=dddlab/base-scipy:v20200228-18f2534-94fdd01b492f
FROM $BASE_IMAGE
LABEL maintainer="Sang-Yun Oh <syoh@ucsb.edu>"
USER root
RUN apt-get update && \
    apt-get install -y \
        libxtst-dev \
        zsh \
        powerline \
        fonts-powerline \
        less \
        bsdmainutils
USER $NB_USER
 
RUN \
    # Notebook extensions (TOC extension)
    pip install jupyter_contrib_nbextensions && \
    jupyter contrib nbextension install --sys-prefix && \
    jupyter nbextension enable toc2/main --sys-prefix && \
    jupyter nbextension enable table_beautifier/main --sys-prefix && \
    jupyter nbextension enable toggle_all_line_numbers/main --sys-prefix && \
    \
    # remove cache
    rm -rf ~/.cache/pip ~/.cache/matplotlib ~/.cache/yarn && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER
ARG RPY2_CFFI_MODE=ABI
RUN \
    pip install \
        pandas \
        cvxpy \
        nltk \
        quandl \ 
        altair vega_datasets \
        otter-grader==2.2.5 \
        ipywebrtc \
        ipympl \
        #ipywidgets \
        matplotlib \
        jupyter_bokeh \
        nbdime \
        jupytext --upgrade \
        jupyterlab_vim \
        jupyterlab_widgets \
        ipympl \
        jupyter \
        jupyterlab && \
    \
    rm -rf ~/.cache/pip ~/.cache/matplotlib ~/.cache/yarn && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER
    # face_recognition 
    #conda install -c menpo dlib 
RUN \
    pip install --upgrade jupyterlab-git && \
    \
    jupyter nbextension enable export_embedded/main --sys-prefix && \
    \
    pip install nbzip && \
    jupyter serverextension enable nbzip --py --sys-prefix && \
    jupyter nbextension install nbzip --py --sys-prefix && \
    jupyter nbextension enable nbzip --py --sys-prefix 
RUN \
    ## Jupyter Classic Notebook Extensions
    jupyter nbextensions_configurator enable --sys-prefix && \
    \
    pip install --pre rise && \
    jupyter nbextension install rise --py --sys-prefix && \
    jupyter nbextension enable rise --py --sys-prefix && \
    \
    pip install hide_code && \
    jupyter nbextension install --py hide_code --sys-prefix && \
    jupyter nbextension enable --py hide_code --sys-prefix && \
    jupyter serverextension enable --py hide_code --sys-prefix
RUN \
    #jupyter labextension update --all && \
    rm -f /opt/conda/share/jupyter/lab/extensions/jupyter-matplotlib-0.4.* \
    rm -f /opt/conda/share/jupyter/lab/extensions/jupyterlab_bokeh-1.0.0.tgz \
    rm -f /opt/conda/share/jupyter/lab/extensions/jupyterlab_vim-0.11.0.tgz \
    rm -f /opt/conda/share/jupyter/lab/extensions/jupyter-widgets-jupyterlab-manager-1.1.0.tgz \
    rm -f /opt/conda/share/jupyter/lab/extensions/nbdime-jupyterlab-1.0.0.tgz   
RUN \
    #conda update -n base conda && \
    npm install -g npm@latest && \
    #conda update jupyterlab -y && \
    jupyter nbextension enable table_beautifier/main --sys-prefix && \
    jupyter nbextension enable toggle_all_line_numbers/main --sys-prefix 
