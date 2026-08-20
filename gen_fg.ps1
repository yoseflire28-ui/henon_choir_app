Add-Type -AssemblyName System.Drawing
$srcPath = Join-Path (Get-Location) "assets\images\app_icon.png"
$dstPath = Join-Path (Get-Location) "assets\images\app_icon_foreground.png"

$src = [System.Drawing.Bitmap]::FromFile($srcPath)
$fg = New-Object System.Drawing.Bitmap 1024, 1024
$g = [System.Drawing.Graphics]::FromImage($fg)
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic

$targetW = [int](1024 * 0.55)
$targetH = [int](1024 * 0.55)
$offX = [int]((1024 - $targetW) / 2)
$offY = [int]((1024 - $targetH) / 2)

$g.DrawImage($src, $offX, $offY, $targetW, $targetH)
$fg.Save($dstPath, [System.Drawing.Imaging.ImageFormat]::Png)

$src.Dispose()
$fg.Dispose()
$g.Dispose()

Write-Output "Successfully generated app_icon_foreground.png!"
