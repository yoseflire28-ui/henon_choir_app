Add-Type -AssemblyName System.Drawing
$srcPath = Join-Path (Get-Location) "assets\images\app_icon.png"
$dstPath = Join-Path (Get-Location) "assets\images\app_icon_foreground.png"

$src = [System.Drawing.Bitmap]::FromFile($srcPath)
$fg = New-Object System.Drawing.Bitmap 1024, 1024
$g = [System.Drawing.Graphics]::FromImage($fg)
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic

$targetW = 600
$targetH = 600
$offX = [int]((1024 - 600) / 2)
$offY = [int]((1024 - 600) / 2)

$g.DrawImage($src, $offX, $offY, $targetW, $targetH)
$fg.Save($dstPath, [System.Drawing.Imaging.ImageFormat]::Png)

$src.Dispose()
$fg.Dispose()
$g.Dispose()

Write-Output "app_icon_foreground.png created with 0% edge clipping!"
