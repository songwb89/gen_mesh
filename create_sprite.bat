@echo off
REM 绿幕视频转精灵图脚本 (Windows)
REM 用法: create_sprite.bat video1.mp4 video2.mp4

set VIDEO1=%1
set VIDEO2=%2
set OUTPUT_DIR=data\frames

echo 生成精灵图...

REM 生成第一个视频的精灵图
echo 处理视频1: %VIDEO1%
ffmpeg -i "%VIDEO1%" -vf "select='eq(n\,0)+between(n\,9\,89)',scale=500:667,fps=24,chromakey=0x00FF00:0.25:0.08,despill=green,tile=82x1" -frames:v 1 "%OUTPUT_DIR%\sprite1.png"

REM 生成第二个视频的精灵图
echo 处理视频2: %VIDEO2%
ffmpeg -i "%VIDEO2%" -vf "select='eq(n\,0)+between(n\,9\,89)',scale=500:667,fps=24,chromakey=0x00FF00:0.25:0.08,despill=green,tile=82x1" -frames:v 1 "%OUTPUT_DIR%\sprite2.png"

REM 压缩精灵图
echo 压缩精灵图...
pngquant --quality=80-90 --ext .png --force "%OUTPUT_DIR%\sprite*.png"

echo 完成！精灵图已保存到 %OUTPUT_DIR%
dir "%OUTPUT_DIR%\sprite*.png"
