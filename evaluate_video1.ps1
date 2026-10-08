# Script chạy evaluate_practice.py để chấm video_1
# Sử dụng: .\evaluate_video1.ps1

Write-Host "=== CHẤM ĐIỂM VIDEO_1 ===" -ForegroundColor Cyan

if (-not $env:LAB_DATA) {
    Write-Host "LỖI: Chưa set LAB_DATA!" -ForegroundColor Red
    exit 1
}

Write-Host "LAB_DATA: $env:LAB_DATA" -ForegroundColor Green
Write-Host ""

# Chấm số video_1
Write-Host "Đang chấm video_1..." -ForegroundColor Cyan
python scripts/evaluate_practice.py `
  --trackeval-root .\TrackEval `
  --lab-data-root $env:LAB_DATA `
  --submission runs/nop_bai/video_1.txt `
  --run-name nhom_xx_video1

Write-Host ""
Write-Host "✓ Xong! Dán bảng HOTA/MOTA/IDF1 vào báo cáo." -ForegroundColor Green
