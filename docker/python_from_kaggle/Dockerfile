FROM gcr.io/kaggle-images/python:v61


RUN conda install -y graphviz pygraphviz &&\
    pip install -U pip &&\
    pip install japanize-matplotlib dtreeviz &&\
    jupyter notebook --generate-config &&\
    echo "c.NotebookApp.token = 'asdf'" >> /root/.jupyter/jupyter_notebook_config.py
