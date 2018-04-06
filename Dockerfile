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
    apt-get -y install python3-pip && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /opt/pytorch
COPY pytorch .

RUN git submodule update --init

RUN pip3 install pyyaml cffi
RUN TORCH_CUDA_ARCH_LIST="3.5 5.2 6.0 6.1 7.0+PTX" TORCH_NVCC_FLAGS="-Xfatbin -compress-all" \
    CMAKE_PREFIX_PATH="$(dirname $(which python3))/../" \
    pip3 install -v .

# Install torch vision
RUN git clone https://github.com/pytorch/vision.git && cd vision && pip3 install -v .

RUN apt-get update && apt-get install -y \
		wget \
		pkg-config \
	  	libavcodec-dev \
 		libavfilter-dev \
 		libavformat-dev \
	 	libavutil-dev \
	 	ffmpeg && \
  		rm -rf /var/lib/apt/lists/*

# Install nvvl
COPY nvvl/examples/pytorch_superres/docker/libnvcuvid.so /usr/local/cuda/lib64/stubs

RUN pip3 install --upgrade cmake && \
    apt-get install -y pkg-config && \
    cd /tmp && \
    wget https://github.com/NVIDIA/nvvl/archive/master.tar.gz -O nvvl.tar.gz && \
    mkdir nvvl && \
    tar xf nvvl.tar.gz -C nvvl --strip-components 1 && \
    rm nvvl.tar.gz && \
    cd nvvl/pytorch && \
    python3 setup.py install && \
    pip3 uninstall -y cmake && \
    apt-get remove -y pkg-config wget && \
    apt-get autoremove -y

# WORKDIR /workspace
# RUN chmod -R a+w /workspace