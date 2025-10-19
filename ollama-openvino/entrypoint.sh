#!/bin/bash

# Source OpenVINO environment
source /opt/intel/openvino_2025.3.0.0/setupvars.sh

# Set OpenVINO device
export OPENVINO_DEVICE=NPU

# Start ollama serve in the background
/bin/ollama serve &
pid=$!

# Wait for the server to start
echo "Waiting for ollama server to start..."
while ! curl -s http://localhost:11434/ > /dev/null; do
    sleep 1
done
echo "Ollama server started."

# Create the model
echo "Creating model..."
/bin/ollama create Qwen3-8B-int4-sym-ov-npu:v1 -f /home/openvino/Modelfile
echo "Model created."

# Wait for the ollama serve process to exit
wait $pid
