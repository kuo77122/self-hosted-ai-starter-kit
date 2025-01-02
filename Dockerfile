FROM n8nio/n8n:1.73.0

USER root

ARG PYTHON_VERSION=3.11.11

# install build dependencies and needed tools
RUN apk add \
    wget \
    gcc \
    make \
    zlib-dev \
    libffi-dev \
    openssl-dev \
    musl-dev

# download and extract python sources
RUN cd /opt \
    && wget https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz \
    && tar xzf Python-${PYTHON_VERSION}.tgz

# build python and remove left-over sources
RUN cd /opt/Python-${PYTHON_VERSION} \
    && ./configure --prefix=/usr --enable-optimizations --with-ensurepip=install \
    && make install \
    && rm /opt/Python-${PYTHON_VERSION}.tgz /opt/Python-${PYTHON_VERSION} -rf

# install poetry
RUN pip3 install poetry==1.2.0
# install pytorch(CPU)
RUN pip install torch==2.0.0 torchvision==0.15.1 torchaudio==2.0.1 --index-url https://download.pytorch.org/whl/cpu
# install whisperx
RUN pip install git+https://github.com/m-bain/whisperx.git
# install RapidOCR
RUN pip install rapidocr_onnxruntime
# install pandas, numpy and pyarrow
RUN pip install pandas numpy pyarrow
