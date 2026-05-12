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
& magick (Join-Path $overlayDir "rectified_front_j1_power.png") +repage -crop "520x820+0+50" -resize 160% (Join-Path $overlayDir "rectified_front_j1_rectifier_local_160.png")
& magick (Join-Path $overlayDir "rectified_back_j1_power.png") +repage -crop "520x820+0+50" -resize 160% (Join-Path $overlayDir "rectified_back_j1_rectifier_local_160.png")
& magick (Join-Path $overlayDir "rectified_blend_j1_power.png") +repage -crop "520x820+0+50" -resize 160% (Join-Path $overlayDir "rectified_blend_j1_rectifier_local_160.png")
& magick montage (Join-Path $overlayDir "rectified_front_j1_rectifier_local_160.png") (Join-Path $overlayDir "rectified_back_j1_rectifier_local_160.png") (Join-Path $overlayDir "rectified_blend_j1_rectifier_local_160.png") -label "%f" -geometry "832x1312+14+28" -tile "3x1" (Join-Path $overlayDir "rectified_j1_rectifier_local_montage.jpg")
& magick (Join-Path $overlayDir "rectified_front_j1_power.png") +repage -crop "420x360+0+0" -resize 250% (Join-Path $overlayDir "rectified_front_cr105_cr106_band_zoom.png")
& magick (Join-Path $overlayDir "rectified_front_j1_power.png") +repage -crop "420x700+170+150" -resize 220% (Join-Path $overlayDir "rectified_front_cr101_cr104_band_zoom.png")
& magick $backAutoMirrored -crop "1800x1700+0+4100" (Join-Path $overlayDir "back_auto_mirrored_j1_rectifier_hi_res_candidate.png")

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

& magick $frontRectified -crop "650x950+0+1650" (Join-Path $overlayDir "rectified_front_q401_cluster.png")
& magick $backRectified -crop "650x950+0+1650" (Join-Path $overlayDir "rectified_back_q401_cluster.png")
& magick $blend -crop "650x950+0+1650" (Join-Path $overlayDir "rectified_blend_q401_cluster.png")
& magick montage (Join-Path $overlayDir "rectified_front_q401_cluster.png") (Join-Path $overlayDir "rectified_back_q401_cluster.png") (Join-Path $overlayDir "rectified_blend_q401_cluster.png") -label "%f" -geometry "650x950+14+28" -tile "3x1" (Join-Path $overlayDir "rectified_q401_cluster_montage.jpg")

# Bridge crop from the CRT electrode strip down to the Q401 video cluster.
# This is the main working view for deciding whether E2/E3 join the local
# video/reference islands visible around J2, R401-R406, C401, and NS401.
& magick $frontRectified -crop "700x1150+0+1120" (Join-Path $overlayDir "rectified_front_e2_to_q401_bridge.png")
& magick $backRectified -crop "700x1150+0+1120" (Join-Path $overlayDir "rectified_back_e2_to_q401_bridge.png")
& magick $blend -crop "700x1150+0+1120" (Join-Path $overlayDir "rectified_blend_e2_to_q401_bridge.png")
& magick montage (Join-Path $overlayDir "rectified_front_e2_to_q401_bridge.png") (Join-Path $overlayDir "rectified_back_e2_to_q401_bridge.png") (Join-Path $overlayDir "rectified_blend_e2_to_q401_bridge.png") -label "%f" -geometry "650x1068+14+28" -tile "3x1" (Join-Path $overlayDir "rectified_e2_to_q401_bridge_montage.jpg")
& magick (Join-Path $overlayDir "rectified_back_e2_to_q401_bridge.png") -auto-level -modulate 100,140,100 -sharpen 0x1.2 (Join-Path $overlayDir "rectified_back_e2_to_q401_bridge_enhanced.png")
& magick (Join-Path $overlayDir "rectified_back_e2_to_q401_bridge.png") -colorspace Gray -auto-level -canny 0x1+10%+30% (Join-Path $overlayDir "rectified_back_e2_to_q401_bridge_edges.png")
& magick montage (Join-Path $overlayDir "rectified_back_e2_to_q401_bridge.png") (Join-Path $overlayDir "rectified_back_e2_to_q401_bridge_enhanced.png") (Join-Path $overlayDir "rectified_back_e2_to_q401_bridge_edges.png") -label "%f" -geometry "650x1068+14+28" -tile "3x1" (Join-Path $overlayDir "rectified_back_e2_to_q401_bridge_analysis.jpg")
& magick (Join-Path $overlayDir "rectified_back_e2_to_q401_bridge.png") +repage -crop "420x520+0+0" -resize 200% (Join-Path $overlayDir "rectified_back_e2_e3_local_2x.png")
& magick (Join-Path $overlayDir "rectified_blend_e2_to_q401_bridge.png") +repage -auto-level -modulate 100,130,100 -sharpen 0x1.0 -crop "420x520+0+0" -resize 200% (Join-Path $overlayDir "rectified_blend_e2_e3_local_2x.png")
& magick (Join-Path $overlayDir "rectified_back_e2_to_q401_bridge.png") +repage -crop "520x650+0+500" -resize 170% (Join-Path $overlayDir "rectified_back_j2_to_q401_left_bus_2x.png")

# High-resolution source crops, useful when the rectified view answers
# geometry but loses fine copper-edge detail.
& magick $frontAuto -crop "850x1150+80+900" (Join-Path $overlayDir "front_auto_e2_e3_hi_res_candidate.png")
& magick $backAutoMirrored -crop "1600x2400+0+1700" (Join-Path $overlayDir "back_auto_mirrored_e2_q401_hi_res_candidate.png")

Write-Host "Generated board-rectified front/back overlays in $overlayDir"
