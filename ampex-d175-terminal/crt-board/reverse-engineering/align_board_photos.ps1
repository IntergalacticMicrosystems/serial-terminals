param(
    [string]$Root = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
)

$ErrorActionPreference = "Stop"

$overlayDir = Join-Path $PSScriptRoot "overlays"
New-Item -ItemType Directory -Force $overlayDir | Out-Null

$front = Join-Path $Root "Front.jpg"
$back = Join-Path $Root "Back.jpg"

$frontAuto = Join-Path $overlayDir "front_auto.png"
$backAutoMirrored = Join-Path $overlayDir "back_auto_mirrored.png"

& magick $front -auto-orient $frontAuto
& magick $back -auto-orient -flop $backAutoMirrored

# Canonical board coordinate image. The source landmarks are approximate board
# corners in the raw photos after EXIF correction. The front lower-right corner
# is partly hidden by the CRT/heatsink assembly and is inferred from the board
# rectangle; refine these numbers if a better straight-on front photo is added.
$boardW = 2400
$boardH = 3200

$frontPerspective = "240,268 0,0 2720,280 $boardW,0 2680,3524 $boardW,$boardH 300,3512 0,$boardH"
$backPerspective = "142,470 0,0 4125,482 $boardW,0 4074,5179 $boardW,$boardH 221,5174 0,$boardH"

$frontRectified = Join-Path $overlayDir "front_board_rectified.png"
$backRectified = Join-Path $overlayDir "back_board_rectified.png"

& magick $frontAuto -virtual-pixel transparent -define "distort:viewport=${boardW}x${boardH}+0+0" -distort Perspective $frontPerspective $frontRectified
& magick $backAutoMirrored -virtual-pixel transparent -define "distort:viewport=${boardW}x${boardH}+0+0" -distort Perspective $backPerspective $backRectified

& magick $frontRectified -resize 25% (Join-Path $overlayDir "front_board_rectified_small.jpg")
& magick $backRectified -resize 25% (Join-Path $overlayDir "back_board_rectified_small.jpg")

$blend = Join-Path $overlayDir "front_back_rectified_blend.png"
& magick $frontRectified $backRectified -define compose:args=45 -compose blend -composite $blend
& magick $blend -resize 25% (Join-Path $overlayDir "front_back_rectified_blend_small.jpg")

& magick montage $frontRectified $backRectified -label "%f" -geometry "900x1200+20+36" -tile "2x1" (Join-Path $overlayDir "rectified_full_front_back_montage.jpg")

# Starter crops in canonical board coordinates.
& magick $frontRectified -crop "850x900+0+2300" (Join-Path $overlayDir "rectified_front_j1_power.png")
& magick $backRectified -crop "850x900+0+2300" (Join-Path $overlayDir "rectified_back_j1_power.png")
& magick $blend -crop "850x900+0+2300" (Join-Path $overlayDir "rectified_blend_j1_power.png")
& magick montage (Join-Path $overlayDir "rectified_front_j1_power.png") (Join-Path $overlayDir "rectified_back_j1_power.png") (Join-Path $overlayDir "rectified_blend_j1_power.png") -label "%f" -geometry "600x700+20+36" -tile "3x1" (Join-Path $overlayDir "rectified_j1_power_montage.jpg")

& magick $frontRectified -crop "900x950+0+0" (Join-Path $overlayDir "rectified_front_cpu_harness.png")
& magick $backRectified -crop "900x950+0+0" (Join-Path $overlayDir "rectified_back_cpu_harness.png")
& magick $blend -crop "900x950+0+0" (Join-Path $overlayDir "rectified_blend_cpu_harness.png")

& magick $frontRectified -crop "900x1200+0+850" (Join-Path $overlayDir "rectified_front_crt_neck.png")
& magick $backRectified -crop "900x1200+0+850" (Join-Path $overlayDir "rectified_back_crt_neck.png")
& magick $blend -crop "900x1200+0+850" (Join-Path $overlayDir "rectified_blend_crt_neck.png")

& magick $frontRectified -crop "900x1750+0+780" (Join-Path $overlayDir "rectified_front_crt_video_tall.png")
& magick $backRectified -crop "900x1750+0+780" (Join-Path $overlayDir "rectified_back_crt_video_tall.png")
& magick $blend -crop "900x1750+0+780" (Join-Path $overlayDir "rectified_blend_crt_video_tall.png")
& magick montage (Join-Path $overlayDir "rectified_front_crt_video_tall.png") (Join-Path $overlayDir "rectified_back_crt_video_tall.png") (Join-Path $overlayDir "rectified_blend_crt_video_tall.png") -label "%f" -geometry "560x1000+18+34" -tile "3x1" (Join-Path $overlayDir "rectified_crt_video_tall_montage.jpg")

Write-Host "Generated board-rectified front/back overlays in $overlayDir"
