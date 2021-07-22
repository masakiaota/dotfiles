# FROM jupyter/datascience-notebook@sha256:73a577b006b496e1a1c02f5be432f4aab969c456881c4789e0df77c89a0a60c2
# FROM jupyter/datascience-notebook:lab-2.2.8
FROM jupyter/datascience-notebook:lab-3.0.16

SHELL ["/bin/bash", "-l", "-c"]

# passの回避
USER root
# apt-get系
RUN apt-get update &&\
    apt-get install -y fish htop
USER jovyan

# RUN yes | bash -c "$(wget -q -O - https://linux.kite.com/dls/linux/current)" #kite is heavy...

# RUN conda install --quiet --yes --freeze-installed -c conda-forge jupyterlab=2.2.0

# jupyter系の設定
RUN jupyter labextension install --no-build @jupyterlab/toc &&\
    # jupyter labextension install --no-build @lckr/jupyterlab_variableinspector @kiteco/jupyterlab-kite &&\
    # jupyter labextension install --no-build 他のなんかの拡張入れようかね
    jupyter lab build --dev-build=False --minimize=True

#passwordの無効化
RUN echo "c.NotebookApp.token = '' ; c.NotebookApp.password = ''" >> /home/jovyan/.jupyter/jupyter_notebook_config.py

# pip install系
RUN pip install --upgrade japanize-matplotlib dtreeviz lifelines tabulate tqdm joblib&&\
    pip install streamlit &&\
    pip install --upgrade protobuf &&\
    pip install lightgbm &&\
    pip install gspread gspread-dataframe &&\
    pip install --upgrade jax jaxlib

RUN pip install opencv-python

# jaxあるしpytorchはいらないかな?
# RUN pip install torch==1.6.0+cpu torchvision==0.7.0+cpu -f https://download.pytorch.org/whl/torch_stable.html


# R系のinstall
RUN R -e "install.packages('tidyverse', repos = 'http://cran.us.r-project.org')" &&\
    R -e "install.packages('broom', repos = 'http://cran.us.r-project.org')" &&\
    R -e "install.packages('devtools', repos = 'http://cran.us.r-project.org')" &&\
    R -e "devtools::install_github('itamarcaspi/experimentdatar')" &&\
    R -e "install.packages('MatchIt', repos = 'http://cran.us.r-project.org')" &&\
    R -e "install.packages('WeightIt', repos = 'http://cran.us.r-project.org')" &&\
    R -e "install.packages('cobalt', repos = 'http://cran.us.r-project.org')" &&\
    R -e "install.packages('Matching', repos = 'http://cran.us.r-project.org')" &&\
    R -e "install.packages('Ecdat', repos = 'http://cran.us.r-project.org')" &&\
    R -e "install.packages('CausalImpact', repos = 'http://cran.us.r-project.org')" &&\
    R -e "install.packages('rddtools', repos = 'http://cran.us.r-project.org')" &&\
    R -e "install.packages('haven', repos = 'http://cran.us.r-project.org')"



# 以下実行しなくてもまあ困らんので...
# RUN conda clean --all -f -y &&\
#     rm -rf $CONDA_DIR/share/jupyter/lab/staging /home/$NB_USER/.cache/yarn &&\
#     fix-permissions $CONDA_DIR &&\
#     fix-permissions /home/$NB_USER


