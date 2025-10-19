FROM docker.io/openvino/ubuntu24_runtime:2025.3.0 AS openvino
USER root

# Intel® NPU drivers (optional)
RUN apt-get update && \
  apt-get install -y --no-install-recommends software-properties-common libtbb-dev libtbb12 kmod jq tar git ocl-icd-libopencl1 && \
  apt-get clean ; \
  rm -rf /var/lib/apt/lists/* && rm -rf /tmp/*

RUN TMP_DIR=$(mktemp -d) && \
  NPU_DRIVER_URL=$(curl -s https://api.github.com/repos/intel/linux-npu-driver/releases/latest | jq -r '.assets[] | select(.name | contains("ubuntu2404.tar.gz")) | .browser_download_url') && \
  curl -L --output "${TMP_DIR}/linux-npu-driver.tar.gz" --url ${NPU_DRIVER_URL} && \
  tar -xzvf ${TMP_DIR}/linux-npu-driver.tar.gz -C ${TMP_DIR} && \
  dpkg -i ${TMP_DIR}/*.deb && \
  rm -Rf ${TMP_DIR}

RUN apt-get update && apt install -y software-properties-common curl
RUN python -m pip install modelscope
RUN python -m pip install -U huggingface_hub
RUN python -m pip install huggingface_hub[hf_xet]
RUN python -m pip install diffusers
RUN python -m pip install "optimum-intel[neural-compressor]"@git+https://github.com/huggingface/optimum-intel.git
RUN python -m pip install "optimum-intel[openvino]"@git+https://github.com/huggingface/optimum-intel.git
RUN python -m pip install "optimum-intel[ipex]"@git+https://github.com/huggingface/optimum-intel.git

RUN apt-get install -y ca-certificates git wget curl gcc g++ vim \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /home/openvino

ARG GOVERSION=1.25.0
RUN curl -fsSL https://golang.org/dl/go${GOVERSION}.linux-$(case $(uname -m) in x86_64) echo amd64 ;; aarch64) echo arm64 ;; esac).tar.gz | tar xz -C /usr/local
ENV PATH=/usr/local/go/bin:$PATH

ENV GENAI_DIR=/opt/intel/openvino_2025.3.0.0

ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$GENAI_DIR/runtime/3rdparty/tbb/lib:$GENAI_DIR/runtime/lib/intel64

ENV CGO_ENABLED=1
ENV GODEBUG=cgocheck=0

ENV CGO_LDFLAGS=-L$GENAI_DIR/runtime/lib/intel64
ENV CGO_CFLAGS=-I$GENAI_DIR/runtime/include

RUN $GENAI_DIR/setupvars.sh

WORKDIR /home/openvino
RUN git clone https://github.com/openvinotoolkit/openvino_contrib.git
WORKDIR /home/openvino/openvino_contrib/modules/ollama_openvino

RUN go build -o /bin/ollama .

ENV OLLAMA_HOST=0.0.0.0:11434

EXPOSE 11434


# Download and prepare the model
RUN python -m pip install modelscope && \
  modelscope download --model zhaohb/Qwen3-8B-int4-sym-ov-npu --local_dir /home/openvino/Qwen3-8B-int4-sym-ov-npu && \
  tar -zcvf /home/openvino/Qwen3-8B-int4-sym-ov-npu.tar.gz -C /home/openvino Qwen3-8B-int4-sym-ov-npu

# Create the Modelfile
COPY Modelfile /home/openvino/Modelfile

# Copy the entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
