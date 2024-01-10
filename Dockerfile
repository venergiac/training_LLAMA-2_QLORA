#FROM nvidia/cuda:12.3.1-devel-ubuntu22.04
FROM nvidia/cuda:12.1.1-base-ubuntu20.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# cer
COPY *.crt /usr/local/share/ca-certificates
RUN update-ca-certificates

ENV REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt

# Install system dependencies
RUN apt-get update
RUN apt-get install -y \
        git \
        python3-pip \
        python3-dev \
        python3-opencv \
        libglib2.0-0

# Install PyTorch and torchvision
RUN pip3 install torch torchvision torchaudio -f https://download.pytorch.org/whl/cu121
		
# Install any python packages you need
COPY requirements.txt requirements.txt
RUN python3 -m pip install -r requirements.txt

RUN python3 -m pip install -U numpy

# configuration of jupyter
run mkdir /root/.jupyter/
COPY jupyter_notebook_config.py /root/.jupyter/

# Upgrade pip
RUN python3 -m pip install --upgrade pip



# Set the working directory
WORKDIR /

EXPOSE 8888                                           
ENTRYPOINT ["jupyter", "notebook","--allow-root","--ip=0.0.0.0","--port=8888","--no-browser"]