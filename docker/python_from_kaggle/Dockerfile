FROM gcr.io/kaggle-images/python:v78

RUN conda install -y graphviz pygraphviz &&\
    pip install -U pip &&\
    pip install japanize-matplotlib dtreeviz lifelines&&\
    pip install streamlit &&\
    # git clone https://github.com/masakiaota/sklearn-hierarchical-classification.git &&\
    # cd sklearn-hierarchical-classification &&\
    # pip install . &&\
    rm -rf /.jupyter/ &&\
    rm -rf /root/.jupyter/ &&\
    jupyter notebook --generate-config &&\
    echo "c.NotebookApp.token = 'asdf'" >> /root/.jupyter/jupyter_notebook_config.py &&\
    apt-get install -y fish htop


