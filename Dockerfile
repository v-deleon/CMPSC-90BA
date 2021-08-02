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
RUN npm install crypto
RUN npm install codemirror
RUN \
    # Notebook extensions (TOC extension)
    pip install jupyter_contrib_nbextensions && \
    jupyter contrib nbextension install --sys-prefix && \
    jupyter nbextension enable toc2/main --sys-prefix && \
    jupyter nbextension enable table_beautifier/main --sys-prefix && \
    jupyter nbextension enable toggle_all_line_numbers/main --sys-prefix && \
    \
    # jupyter lab extensions
    #jupyter labextension install @jupyterlab/toc --clean && \
    \
    # remove cache
    rm -rf ~/.cache/pip ~/.cache/matplotlib ~/.cache/yarn && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER
ARG RPY2_CFFI_MODE=ABI
RUN \
    pip install \
        pandas==1.0.3 \
        cvxpy \
        nltk \
        quandl \ 
        altair vega_datasets \
        otter-grader==2.2.4 \
        pip install ipywebrtc \
        ipympl && \
    \
    rm -rf ~/.cache/pip ~/.cache/matplotlib ~/.cache/yarn && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER
    #Need to revisit
    #jupyter labextension install @jupyter-widgets/jupyterlab-manager jupyter-webrtc --clean
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
    jupyter nbextension enable nbzip --py --sys-prefix && \
    jupyter lab build
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
RUN jupyter labextension install jupyter-matplotlib --no-build && \ 
    jupyter labextension update --all && \
    rm -f /opt/conda/share/jupyter/lab/extensions/jupyter-matplotlib-0.4.*
RUN jupyter labextension install jupyterlab-jupytext@v1.1.1 --no-build
RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager@v1.1.0 --no-build
RUN jupyter labextension install nbdime-jupyterlab@v1.0.0 --no-build
RUN \
    conda update -n base conda && \
    npm install crypto codemirror && \
    conda update jupyterlab -y && \
    pip install jupyter_bokeh && \
    pip install jupytext --upgrade && \
    jupyter nbextension enable table_beautifier/main --sys-prefix && \
    jupyter nbextension enable toggle_all_line_numbers/main --sys-prefix 
RUN jupyter labextension install jupyter-matplotlib@v0.9.0 --no-build
RUN jupyter lab build --minimize=False

#jupyter labextension install @jupyterlab/toc
#jupyter labextension install @jupyter-widgets/jupyterlab-manager --no-build