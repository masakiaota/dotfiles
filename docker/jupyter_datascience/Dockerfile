# FROM jupyter/datascience-notebook@sha256:73a577b006b496e1a1c02f5be432f4aab969c456881c4789e0df77c89a0a60c2
FROM jupyter/datascience-notebook:lab-2.2.8

SHELL ["/bin/bash", "-l", "-c"]

RUN yes | bash -c "$(wget -q -O - https://linux.kite.com/dls/linux/current)"

# RUN conda install --quiet --yes --freeze-installed -c conda-forge jupyterlab=2.2.0

# jupyter系の設定
RUN jupyter labextension install --no-build @jupyterlab/toc @lckr/jupyterlab_variableinspector @kiteco/jupyterlab-kite &&\
    jupyter lab build --dev-build=False --minimize=True

#passwordの無効化
RUN echo "c.NotebookApp.token = '' ; c.NotebookApp.password = ''" >> /home/jovyan/.jupyter/jupyter_notebook_config.py

# pip install系
RUN pip install --upgrade jupyter-kite &&\
    pip install japanize-matplotlib dtreeviz lifelines tabulate&&\
    pip install streamlit &&\
    pip install --upgrade protobuf &&\
    pip install lightgbm


#passの回避
USER root
# apt-get系
RUN apt-get update &&\
    apt-get install -y fish htop
USER jovyan


# 以下実行しなくてもまあ困らんので...
# RUN conda clean --all -f -y &&\
#     rm -rf $CONDA_DIR/share/jupyter/lab/staging /home/$NB_USER/.cache/yarn &&\
#     fix-permissions $CONDA_DIR &&\
#     fix-permissions /home/$NB_USER


