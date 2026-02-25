from PIL import Image
import os

def create_sprite_sheet(input_folder, output_path, frames_to_use):
    """
    创建精灵图
    frames_to_use: 要使用的帧号列表，如 [1, 10, 11, 12, ..., 90]
    """
    frame_width = 500
    frame_height = 667
    
    # 读取所有需要的帧
    frames = []
    for frame_num in frames_to_use:
        frame_path = os.path.join(input_folder, f"frame_{frame_num:04d}.png")
        if os.path.exists(frame_path):
            img = Image.open(frame_path)
            frames.append(img)
        else:
            print(f"Warning: {frame_path} not found")
    
    if not frames:
        print("No frames found!")
        return
    
    # 计算精灵图尺寸（横向排列）
    total_frames = len(frames)
    sprite_width = frame_width * total_frames
    sprite_height = frame_height
    
    # 创建精灵图
    sprite = Image.new('RGBA', (sprite_width, sprite_height), (0, 0, 0, 0))
    
    # 粘贴每一帧
    for i, frame in enumerate(frames):
        x_offset = i * frame_width
        sprite.paste(frame, (x_offset, 0))
    
    # 保存
    sprite.save(output_path, 'PNG')
    print(f"Sprite sheet created: {output_path}")
    print(f"Size: {sprite_width}x{sprite_height}, Frames: {total_frames}")
    
    return total_frames

# 生成帧列表：第1帧 + 第10-90帧
frames_list = [1] + list(range(10, 91))

# 处理两个视频
print("Creating sprite for video 1...")
frames1_count = create_sprite_sheet('data/temp_frames1', 'data/frames/sprite1.png', frames_list)

print("\nCreating sprite for video 2...")
frames2_count = create_sprite_sheet('data/temp_frames2', 'data/frames/sprite2.png', frames_list)

print(f"\nTotal frames in each sprite: {len(frames_list)}")
