param(
    [string]$Root = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
)

$ErrorActionPreference = "Stop"

$overlayDir = Join-Path $PSScriptRoot "overlays"
New-Item -ItemType Directory -Force $overlayDir | Out-Null

$front = Join-Path $Root "Front.jpg"
$back = Join-Path $Root "Back.jpg"

magick $front -auto-orient (Join-Path $overlayDir "front_auto.png")
magick $front -auto-orient (Join-Path $overlayDir "front_reference.png")
magick $back -auto-orient (Join-Path $overlayDir "back_auto.png")
magick $back -auto-orient -flop (Join-Path $overlayDir "back_auto_mirrored.png")

# Legacy name retained for existing notes/crops. Prefer back_auto_mirrored.png for new tracing.
magick $back -auto-orient -flop (Join-Path $overlayDir "back_mirrored.png")

$photos = @(
    (Join-Path $Root "Front.jpg"),
    (Join-Path $Root "Back.jpg"),
    (Join-Path $Root "CRT-deflection.jpg"),
    (Join-Path $Root "CRT-deflection2.jpg"),
    (Join-Path $Root "CRT-deflection-conn.jpg"),
    (Join-Path $Root "CRT-Neck-connector.jpg")
) | Where-Object { Test-Path $_ }

if ($photos.Count -gt 0) {
    magick montage @photos -label "%f" -geometry "900x700+24+48" -tile "2x3" (Join-Path $overlayDir "photo_contact_sheet.jpg")
}

Write-Host "Generated overlay images in $overlayDir"
