from PIL import Image

def generate_adaptive_icons():
    # Open source icon image
    source = Image.open("assets/images/app_icon.png").convert("RGBA")
    
    # 1. Create transparent foreground canvas (1024x1024)
    fg_canvas = Image.new("RGBA", (1024, 1024), (0, 0, 0, 0))
    
    # Scale icon down to 55% so all text fits inside Android's 66% mask circle
    target_size = (int(1024 * 0.55), int(1024 * 0.55))
    resized_icon = source.resize(target_size, Image.Resampling.LANCZOS)
    
    # Center resized logo on transparent foreground
    offset = ((1024 - target_size[0]) // 2, (1024 - target_size[1]) // 2)
    fg_canvas.paste(resized_icon, offset, resized_icon)
    fg_canvas.save("assets/images/app_icon_foreground.png")
    
    # 2. Create solid background canvas
    bg_canvas = Image.new("RGBA", (1024, 1024), "#0D0B26")
    bg_canvas.save("assets/images/app_icon_background.png")
    
    print("Successfully generated padded foreground and background icon assets!")

if __name__ == "__main__":
    generate_adaptive_icons()
