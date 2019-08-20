FROM gcr.io/kaggle-images/python:v61

RUN conda install -y graphviz pygraphviz &&\
    pip install -U pip &&\
    pip install japanize-matplotlib dtreeviz &&\
    git clone https://github.com/masakiaota/sklearn-hierarchical-classification.git &&\
    cd sklearn-hierarchical-classification &&\
    pip install . &&\
    jupyter notebook --generate-config &&\
    echo "c.NotebookApp.token = 'asdf'" >> /root/.jupyter/jupyter_notebook_config.py &&\
    apt-get install -y fish


