# 绿幕视频转透明背景精灵图

## 完整流程（推荐）

### 步骤 1：生成序列帧（降低分辨率 + 去绿幕）

```bash
ffmpeg -i "input.mp4" -vf "scale=500:667,fps=24,chromakey=0x00FF00:0.25:0.08,despill=green" -pix_fmt rgba "temp_frames\frame_%04d.png"
```

### 步骤 2：合并成精灵图（使用 FFmpeg）

FFmpeg 一步到位生成精灵图：

```bash
# 视频1
ffmpeg -i "video1.mp4" -vf "select='eq(n\,0)+between(n\,9\,89)',scale=500:667,fps=24,chromakey=0x00FF00:0.25:0.08,despill=green,tile=82x1" -frames:v 1 "sprite1.png"

# 视频2
ffmpeg -i "video2.mp4" -vf "select='eq(n\,0)+between(n\,9\,89)',scale=500:667,fps=24,chromakey=0x00FF00:0.25:0.08,despill=green,tile=82x1" -frames:v 1 "sprite2.png"
```

**参数说明：**
- `select='eq(n\,0)+between(n\,9\,89)'`: 选择第1帧（索引0）和第10-90帧（索引9-89），共82帧
- `tile=82x1`: 将82帧横向排列成1行

### 步骤 3：有损压缩精灵图

```bash
pngquant --quality=80-90 --ext .png --force sprite.png
```

**效果：** 
- 单帧方案：97张图片，总计 46MB（压缩后 8-12MB）
- 精灵图方案：1张图片，25MB → 压缩后 7MB
- 加载速度：97次请求 → 1次请求

## 参数说明

| 参数 | 值 | 说明 |
|------|-----|------|
| `-i` | input.mp4 | 输入视频文件 |
| `scale` | 500:667 | 降低分辨率到60%（原始834×1112） |
| `fps` | 24 | 输出帧率，每秒24帧（匹配原视频） |
| `chromakey` | 0x00FF00:0.25:0.08 | 绿幕抠图滤镜 |
| `despill` | green | 去除人物边缘绿色溢出 |
| `-pix_fmt` | rgba | 输出带Alpha透明通道 |
| `frame_%04d.png` | - | 输出文件名，4位数字编号 |

## pngquant 压缩参数

| 参数 | 值 | 说明 |
|------|-----|------|
| `--quality` | 80-90 | 质量范围，平衡画质和大小（推荐） |
| `--ext` | .png | 直接覆盖原文件 |
| `--force` | - | 强制覆盖已存在的文件 |

## chromakey 参数详解

```
chromakey=颜色:相似度:混合度
```

- **颜色** `0x00FF00`: 标准绿幕色（#00FF00）
- **相似度** `0.25`: 颜色匹配阈值，越大去除范围越广
  - 太小（如0.15）：绿幕去不干净
  - 太大（如0.3）：可能影响衣服/头发
- **混合度** `0.08`: 边缘羽化程度，越大边缘越柔和

## 滤镜顺序（重要）

```
chromakey → despill
```

必须先抠图，再去绿边。如果顺序反过来，despill 会把绿色变成灰色，导致 chromakey 无法识别。

## 调参建议

| 问题 | 解决方案 |
|------|----------|
| 绿幕去不干净 | 增大相似度（如 0.3） |
| 衣服/头发模糊 | 减小相似度（如 0.2） |
| 边缘有绿线 | 添加 despill=green |
| 边缘太硬 | 增大混合度（如 0.1） |

## 示例

### 完整示例：生成精灵图

**方式一：使用 FFmpeg 一步到位（推荐）**

```bash
# 视频1：生成序列帧 + 抠图 + 选帧 + 拼接
ffmpeg -i "data\video1.mp4" -vf "select='eq(n\,0)+between(n\,9\,89)',scale=500:667,fps=24,chromakey=0x00FF00:0.25:0.08,despill=green,tile=82x1" -frames:v 1 "data\frames\sprite1.png"

# 视频2
ffmpeg -i "data\video2.mp4" -vf "select='eq(n\,0)+between(n\,9\,89)',scale=500:667,fps=24,chromakey=0x00FF00:0.25:0.08,despill=green,tile=82x1" -frames:v 1 "data\frames\sprite2.png"

# 压缩精灵图
pngquant --quality=80-90 --ext .png --force data\frames\sprite*.png
```

**方式二：使用脚本（Windows）**

```bash
create_sprite.bat video1.mp4 video2.mp4
```

**方式三：使用脚本（Linux/Mac）**

```bash
./create_sprite.sh video1.mp4 video2.mp4
```

**文件大小对比：**
- 单帧方案：97张图片 × 2 = 194张，总计 ~92MB（压缩后 ~20MB）
- 精灵图方案：2张精灵图，总计 ~50MB → 压缩后 ~13MB
- 加载速度：194次请求 → 2次请求

### 精灵图结构

| 内容 | 帧数 | 用途 |
|------|------|------|
| 第1帧（索引0） | 1帧 | 暂停时显示（嘴巴闭着） |
| 第10-90帧（索引1-81） | 81帧 | 乒乓播放动画 |
| 总计 | 82帧 | 精灵图尺寸：41000×667 |

## 分辨率选择

| 分辨率 | 用途 | 单帧大小 | 精灵图大小（82帧） |
|--------|------|---------|-------------------|
| 834×1112 | 高清展示 | ~900KB | ~74MB → 压缩后 ~20MB |
| 625×834 | 桌面端 | ~600KB | ~49MB → 压缩后 ~12MB |
| 500×667 | 网页通用（推荐） | ~500KB | ~41MB → 压缩后 ~7MB |
| 417×556 | 移动端/弱网 | ~300KB | ~25MB → 压缩后 ~5MB |

**推荐配置：500×667 + 质量 80-90**  
平衡清晰度和文件大小，适合 90% 的场景。

## 前端使用

### HTML 结构

```html
<div class="digital-human">
  <div class="digital-human-sprite" style="background-image: url('sprite.png');"></div>
</div>
```

### CSS 样式

```css
.digital-human {
  width: 500px;
  height: 667px;
  overflow: hidden;
}
.digital-human-sprite {
  width: 41000px; /* 500px × 82帧 */
  height: 667px;
  background-repeat: no-repeat;
  background-size: 41000px 667px;
}
```

### JavaScript 控制

```javascript
const frameWidth = 500;
const currentIndex = 0; // 0-81

// 切换到指定帧
function showFrame(index) {
  const offsetX = -index * frameWidth;
  sprite.style.backgroundPosition = `${offsetX}px 0`;
}
```
