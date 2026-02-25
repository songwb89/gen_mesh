#!/bin/bash

# 绿幕视频转精灵图脚本
# 用法: ./create_sprite.sh video1.mp4 video2.mp4

VIDEO1=$1
VIDEO2=$2
OUTPUT_DIR="data/frames"

echo "生成精灵图..."

# 生成第一个视频的精灵图
echo "处理视频1: $VIDEO1"
ffmpeg -i "$VIDEO1" \
  -vf "select='eq(n\,0)+between(n\,9\,89)',scale=500:667,fps=24,chromakey=0x00FF00:0.25:0.08,despill=green,tile=82x1" \
  -frames:v 1 \
  "$OUTPUT_DIR/sprite1.png"

# 生成第二个视频的精灵图
echo "处理视频2: $VIDEO2"
ffmpeg -i "$VIDEO2" \
  -vf "select='eq(n\,0)+between(n\,9\,89)',scale=500:667,fps=24,chromakey=0x00FF00:0.25:0.08,despill=green,tile=82x1" \
  -frames:v 1 \
  "$OUTPUT_DIR/sprite2.png"

# 压缩精灵图
echo "压缩精灵图..."
pngquant --quality=80-90 --ext .png --force "$OUTPUT_DIR"/sprite*.png

echo "完成！精灵图已保存到 $OUTPUT_DIR"
ls -lh "$OUTPUT_DIR"/sprite*.png
