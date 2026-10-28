Add-Type -AssemblyName System.Drawing

# Configuration
$sourcePath = Join-Path $PSScriptRoot "bg1.jpg"
$outputFolder = Join-Path $PSScriptRoot "output_resolutions"

# List of 16 resolutions from lowest to highest
$resolutions = @(
    @{ W = 640;  H = 360  } # bg1
    @{ W = 960;  H = 540  } # bg2
    @{ W = 1280; H = 720  } # bg3
    @{ W = 1440; H = 900  } # bg4
    @{ W = 1920; H = 1024 } # bg5 (Your original size)
    @{ W = 2048; H = 1080 } # bg6
    @{ W = 2048; H = 1152 } # bg7
    @{ W = 2560; H = 1080 } # bg8
    @{ W = 2560; H = 1440 } # bg9
    @{ W = 3200; H = 1800 } # bg10
    @{ W = 3440; H = 1440 } # bg11
    @{ W = 3840; H = 2160 } # bg12
    @{ W = 4096; H = 2160 } # bg13
    @{ W = 5120; H = 1440 } # bg14
    @{ W = 5120; H = 2880 } # bg15
    @{ W = 7680; H = 4320 } # bg16
)

if (-not (Test-Path $sourcePath)) {
    Write-Error "Source image bg1.jpg not found in the script directory."
    exit
}

# Create output folder if it doesn't exist
if (-not (Test-Path $outputFolder)) {
    New-Item -ItemType Directory -Path $outputFolder | Out-Null
}

# Load original image
$srcImg = [System.Drawing.Image]::FromFile($sourcePath)

for ($i = 0; $i -lt $resolutions.Count; $i++) {
    $res = $resolutions[$i]
    $fileNumber = $i + 1
    $fileName = "bg$fileNumber.jpg"
    
    Write-Host "Processing $fileName ($($res.W)x$($res.H))..." -ForegroundColor Cyan
    
    # Create blank canvas
    $destImg = New-Object System.Drawing.Bitmap($res.W, $res.H)
    $graphic = [System.Drawing.Graphics]::FromImage($destImg)
    
    # Set high quality rendering options
    $graphic.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $graphic.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $graphic.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $graphic.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
    
    # Draw and resize
    $graphic.DrawImage($srcImg, 0, 0, $res.W, $res.H)
    
    # Save output to the subfolder
    $outputPath = Join-Path $outputFolder $fileName
    $destImg.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Jpeg)
    
    # Clean up resolution-specific objects
    $graphic.Dispose()
    $destImg.Dispose()
}

# Clean up source image
$srcImg.Dispose()
Write-Host "Finished! Your 16 files (bg1.jpg to bg16.jpg) are in the 'output_resolutions' folder." -ForegroundColor Green
