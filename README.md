# 数字人播放器 - 精灵图版本

基于精灵图技术的数字人动画播放器，支持透明背景、乒乓播放。

## 在线演示

打开 `index.html` 即可查看效果。

GitHub Pages 预览：`https://你的用户名.github.io/仓库名/`

## 特性

- ✅ 精灵图技术，只需加载 2 张图片（2次HTTP请求）
- ✅ 透明背景，支持任意背景色
- ✅ 乒乓播放，循环流畅
- ✅ 播放/暂停控制
- ✅ 文件大小优化（单张精灵图 ~6-7MB）

## 技术栈

- 纯 HTML + CSS + JavaScript
- 精灵图（Sprite Sheet）技术
- 透明 PNG 格式

## 文件说明

```
├── index.html  # 主页面
└── data/
    └── frames/
        ├── sprite1.png  # 右侧数字人精灵图
        └── sprite2.png  # 左侧数字人精灵图
```

## 精灵图规格

- 分辨率：500×667（单帧）
- 总尺寸：41000×667（82帧横向排列）
- 帧数：82帧（第1帧 + 第10-90帧）
- 格式：PNG（RGBA，透明背景）
- 压缩：pngquant 质量 80-90

## 使用方法

1. 克隆仓库
```bash
git clone https://github.com/你的用户名/digital-human-player.git
```

2. 直接打开 HTML 文件
```bash
open index.html
```

或者用本地服务器：
```bash
python -m http.server 8000
# 访问 http://localhost:8000
```

## 如何生成自己的精灵图

详见 [生成文档](docs/green_screen_to_frames.md)

需要工具：
- FFmpeg
- pngquant

生成命令：
```bash
ffmpeg -i "video.mp4" \
  -vf "select='eq(n\,0)+between(n\,9\,89)',scale=500:667,fps=24,chromakey=0x00FF00:0.25:0.08,despill=green,tile=82x1" \
  -frames:v 1 \
  "sprite.png"

pngquant --quality=80-90 --ext .png --force sprite.png
```

## 浏览器兼容性

- ✅ Chrome/Edge 90+
- ✅ Firefox 88+
- ✅ Safari 14+

## License

MIT
