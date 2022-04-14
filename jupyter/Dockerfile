FROM python:3

COPY ./requirements.txt .

RUN pip install -r requirements.txt

# RUN useradd -m jupyter
# USER jupyter
# WORKDIR /home/jupter/

# COPY notebooks /notebooks/

WORKDIR /notebooks

CMD ["jupyter", "lab", "--ip", "0.0.0.0", "--port", "8888", "--NotebookApp.token=''", "--NotebookApp.password=''", "--no-browser", "--allow-root"]