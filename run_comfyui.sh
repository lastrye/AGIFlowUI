#!/bin/bash
source /opt/miniconda3/etc/profile.d/conda.sh
conda activate comfyui
cd "/run/media/lastrye/Dev/AIGC/ComfyUI/ComfyUI"
# 挂载代理 (保证模型下载正常)
export http_proxy=socks5://127.0.0.1:10089
export https_proxy=socks5://127.0.0.1:10089
export all_proxy=socks5://127.0.0.1:10089
echo "Starting ComfyUI..."
python start.py --port 9999 --front-end-root web_source/dist --tls-keyfile ~/.ssh/comfyuikeys/key.pem --tls-certfile ~/.ssh/comfyuikeys/cert.pem --listen 0.0.0.0 "$@"
