FROM nvidia/cuda:9.0-cudnn7-devel-ubuntu16.04

RUN apt-get update && apt-get install -y --no-install-recommends \
         build-essential \
         cmake \
         git \
         curl \
         vim \
         ca-certificates \
         libjpeg-dev \
         libpng-dev \
         python3 \
         python3-dev \ 
         &&\
    apt-get -y install python3-pip ffmpeg && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /opt/pytorch
COPY pytorch .

RUN git submodule update --init

RUN pip3 install pyyaml
RUN TORCH_CUDA_ARCH_LIST="3.5 5.2 6.0 6.1 7.0+PTX" TORCH_NVCC_FLAGS="-Xfatbin -compress-all" \
    CMAKE_PREFIX_PATH="$(dirname $(which python3))/../" \
    pip3 install -v .

RUN git clone https://github.com/pytorch/vision.git && cd vision && pip3 install -v .

WORKDIR /workspace
RUN chmod -R a+w /workspace