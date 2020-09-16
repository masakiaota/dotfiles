FROM gcr.io/kaggle-images/python:v78

# apt-get系
RUN apt-get install -y fish htop

# conda系
RUN conda install -y graphviz pygraphviz &&\
    pip install --upgrade pip

# jupyter系の設定
RUN pip install --upgrade jupyterlab &&\
    rm -rf /.jupyter/ &&\
    rm -rf /root/.jupyter/ &&\
    jupyter notebook --generate-config &&\
    echo "c.NotebookApp.token = 'asdf'" >> /root/.jupyter/jupyter_notebook_config.py &&\
    jupyter labextension install @jupyterlab/toc @lckr/jupyterlab_variableinspector

# pip install系
RUN pip install japanize-matplotlib dtreeviz lifelines&&\
    pip install streamlit &&\
    # protobufがないとstreamlitが動かんぽい
    pip install --upgrade protobuf    
    # git clone https://github.com/masakiaota/sklearn-hierarchical-classification.git &&\
    # cd sklearn-hierarchical-classification &&\
    # pip install . &&\

RUN pip install jupyter-kite &&\
    jupyter labextension install "@kiteco/jupyterlab-kite"




