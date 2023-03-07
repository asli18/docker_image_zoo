ARG UBUNTU_VER
FROM ubuntu:${UBUNTU_VER}

ARG UBUNTU_VER
RUN echo "FROM ubuntu:${UBUNTU_VER}"

RUN export DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get upgrade -y

## install kernel
#RUN apt-get install -y linux-image-$(uname -r) \
#                       linux-headers-$(uname -r) \
#                       linux-modules-$(uname -r) \
#                       linux-modules-extra-$(uname -r)

ENV TZ=Asia/Taipei
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone && \
    ln -fs /usr/share/zoneinfo/Asia/Taipei /etc/localtime

RUN apt-get install -y vim wget git sudo tzdata lsb-release tree xxd cmake make gcc g++

## dependencies of AI Framework
#RUN apt-get install -y gettext pkg-config python3-xcbgen bc bison flex kmod cpio swig \
#                       libtool automake build-essential yasm llvm-11 qemu-user-static \
#                       libglib2.0-dev libicu-dev libgoogle-glog-dev libboost-dev libssl-dev \
#                       libevent-dev libgtest-dev libopenblas-dev device-tree-compiler
## dependencies of MKL
#RUN apt-get install -y libboost-dev libboost-program-options-dev \
#                       libboost-filesystem-dev libboost-regex-dev

## for py3.8
RUN apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:deadsnakes/ppa && \
    dpkg-reconfigure --frontend noninteractive tzdata && \
    apt-get install -y python3.8 python3.8-dev python3.8-venv \
                       python3.8-distutils python3.8-lib2to3 python3.8-gdbm
RUN wget https://bootstrap.pypa.io/get-pip.py -O get-pip.py && \
    python3.8 get-pip.py
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 1 && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3.8 1 && \
    update-alternatives --config python3 && \
    update-alternatives --config python

#RUN python3 -m pip install -U setuptools pip
RUN pip3 install -U setuptools pip
RUN pip3 install opencv-python decorator scipy psutil attrs pytest Pillow \
                 tornado imageio networkx IPython xgboost cloudpickle \
                 onnx onnxruntime==1.10.0 onnx-simplifier onnxsim \
                 tflite==2.1.0 tensorflow==2.7.0

RUN apt-get clean

WORKDIR /
CMD ["/bin/bash"]
