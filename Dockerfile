ARG CUDA_VERSION=11.2.1
ARG CUDNN_VERSION=8
ARG BASE_IMAGE=nvidia/cuda:${CUDA_VERSION}-cudnn${CUDNN_VERSION}-devel

FROM ${BASE_IMAGE}

ENV LC_ALL=en_US.UTF-8 \
    TZ=Europe/Ireland
# Greenwich Mean Time

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    apt-get update && \
	DEBIAN_FRONTEND="noninteractive" apt-get -y --no-install-suggests --no-install-recommends install \
        wget \
        build-essential \
        cmake \
        locales \
        git \
        libatlas-base-dev \
        libprotobuf-dev \
        libleveldb-dev \
        libsnappy-dev \
        libhdf5-serial-dev \
        protobuf-compiler \
        libboost-all-dev \
        libgflags-dev \
        libgoogle-glog-dev \
        liblmdb-dev \
        pciutils \
        opencl-headers \
        ocl-icd-opencl-dev \
        libviennacl-dev \
        libcanberra-gtk-module \
        libopencv-dev && \
	echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen

RUN git clone https://github.com/CMU-Perceptual-Computing-Lab/openpose.git && \
    cd openpose && \
    git checkout 1f1aa9c59fe59c90cca685b724f4f97f76137224 && \
	mkdir ./build && \
	cd ./build && \
	cmake \
	    -D DOWNLOAD_BODY_25_MODEL=ON \
	    -D DOWNLOAD_FACE_MODEL=OFF \
	    -D BUILD_SHARED_LIBS=OFF \
	    -D DOWNLOAD_HAND_MODEL=OFF .. && \
	make -j`nproc`

RUN mkdir -p /openpose/models/pose/body_25b/ && \
    wget -P /openpose/models/pose/body_25b/ \
	    http://posefs1.perception.cs.cmu.edu/OpenPose/models/pose/\
1_25BSuperModel11FullVGG/body_25b/pose_iter_XXXXXX.caffemodel && \
	wget -P /openpose/models/pose/body_25b/ \
	    https://raw.githubusercontent.com/CMU-Perceptual-Computing-Lab/\
openpose_train/6a6bb9cc2b56359cfb219dcda7ef3be4f3d18b1d/experimental_models/\
1_25BSuperModel11FullVGG/body_25b/pose_deploy.prototxt

WORKDIR /openpose

ENTRYPOINT ["/openpose/build/examples/openpose/openpose.bin"]
