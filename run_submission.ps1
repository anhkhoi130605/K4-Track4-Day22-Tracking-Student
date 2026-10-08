# Script chạy bản nộp 5 video (đủ frame)
# Sử dụng: .\run_submission.ps1

Write-Host "=== CHẠY BẢN NỘP 5 VIDEO (ĐỦ FRAME) ===" -ForegroundColor Cyan
Write-Host "Lưu kết quả vào: runs/nop_bai/" -ForegroundColor Green
Write-Host ""

# Kiểm tra LAB_DATA
if (-not $env:LAB_DATA) {
    Write-Host "LỖI: Chưa set LAB_DATA!" -ForegroundColor Red
    Write-Host "Chạy: `$env:LAB_DATA = 'D:\VinUni\DeepTrack\K4-Track4-Day22-Tracking-Student\data_lab21'" -ForegroundColor Yellow
    exit 1
}

Write-Host "LAB_DATA: $env:LAB_DATA" -ForegroundColor Green
Write-Host ""

# Tạo thư mục nộp nếu chưa có
New-Item -ItemType Directory -Path "runs/nop_bai" -Force | Out-Null

# Video 1: ByteTrack (nhanh, đủ tốt cho quảng trường)
Write-Host "[1/5] Video 1 - ByteTrack conf=0.3 iou=0.5..." -ForegroundColor Cyan
python scripts/run_tracking.py --source "$env:LAB_DATA/video_1/img1" --seq-name video_1 --tracker bytetrack --conf 0.3 --iou 0.5 --out runs/nop_bai --save-video
Write-Host "[OK] Xong video_1" -ForegroundColor Green
Write-Host ""

# Video 2: StrongSORT (cảnh đông, cần Re-ID)
Write-Host "[2/5] Video 2 - StrongSORT conf=0.25 iou=0.5..." -ForegroundColor Cyan
python scripts/run_tracking.py --source "$env:LAB_DATA/video_2/img1" --seq-name video_2 --tracker strongsort --conf 0.25 --iou 0.5 --out runs/nop_bai --save-video
Write-Host "[OK] Xong video_2" -ForegroundColor Green
Write-Host ""

# Video 3: ByteTrack (camera di chuyển, nhanh)
Write-Host "[3/5] Video 3 - ByteTrack conf=0.3 iou=0.5..." -ForegroundColor Cyan
python scripts/run_tracking.py --source "$env:LAB_DATA/video_3/img1" --seq-name video_3 --tracker bytetrack --conf 0.3 --iou 0.5 --out runs/nop_bai --save-video
Write-Host "[OK] Xong video_3" -ForegroundColor Green
Write-Host ""

# Video 4: StrongSORT (ánh sáng yếu, cần Re-ID)
Write-Host "[4/5] Video 4 - StrongSORT conf=0.25 iou=0.5..." -ForegroundColor Cyan
python scripts/run_tracking.py --source "$env:LAB_DATA/video_4/img1" --seq-name video_4 --tracker strongsort --conf 0.25 --iou 0.5 --out runs/nop_bai --save-video
Write-Host "[OK] Xong video_4" -ForegroundColor Green
Write-Host ""

# Video 5: StrongSORT (cảnh rất đông, cần Re-ID)
Write-Host "[5/5] Video 5 - StrongSORT conf=0.25 iou=0.5..." -ForegroundColor Cyan
python scripts/run_tracking.py --source "$env:LAB_DATA/video_5/img1" --seq-name video_5 --tracker strongsort --conf 0.25 --iou 0.5 --out runs/nop_bai --save-video
Write-Host "[OK] Xong video_5" -ForegroundColor Green
Write-Host ""

Write-Host "=== HOÀN THÀNH ===" -ForegroundColor Green
Write-Host "Kết quả: runs/nop_bai/" -ForegroundColor Yellow
ls runs/nop_bai/ -Filter "*.txt" | ForEach-Object { Write-Host "  [OK] $_" }
Write-Host ""
Write-Host "Bước tiếp theo: Chạy evaluate_practice.py để chấm video_1" -ForegroundColor Cyan
