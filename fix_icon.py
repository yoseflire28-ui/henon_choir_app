from PIL import Image

# Open original icon image
img = Image.open("assets/images/app_icon.png").convert("RGBA")

# Create a 1024x1024 navy background canvas
canvas = Image.new("RGBA", (1024, 1024), "#0D0B26")

# Scale original image to 68% so text stays inside Android's safe zone
scaled_size = (int(1024 * 0.68), int(1024 * 0.68))
img_resized = img.resize(scaled_size, Image.Resampling.LANCZOS)

# Center the resized icon on the canvas
offset = ((1024 - scaled_size[0]) // 2, (1024 - scaled_size[1]) // 2)
canvas.paste(img_resized, offset, img_resized if img_resized.mode == 'RGBA' else None)

# Overwrite image
canvas.save("assets/images/app_icon.png")
print("Icon safe-zone padding applied successfully!")
