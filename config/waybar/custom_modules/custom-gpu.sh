#!/bin/bash
TEMP=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits | head -n1)
MEM_USED=$(nvidia-smi --query-gpu=memory.used --format=csv,noheader,nounits | head -n1)
MEM_TOTAL=$(nvidia-smi --query-gpu=memory.total --format=csv,noheader,nounits | head -n1)

echo -e " ${TEMP}°C\n ${MEM_USED}/${MEM_TOTAL} MiB"