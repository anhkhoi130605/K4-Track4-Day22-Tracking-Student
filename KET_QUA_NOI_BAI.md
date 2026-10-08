# 📋 Kết Quả Nộp Bài Lab Tracking

**Ngày hoàn thành:** 09/10/2026 02:58 AM  
**Nhóm:** Khờ ôi Khôi  
**Thành viên:** Phạm Hoàng Anh Khôi

---

## ✅ Danh Sách File Nộp

| File | Frames | Tracker | conf | iou | Thời gian xử lý | FPS |
|------|--------|---------|------|-----|-----------------|-----|
| `runs/nop_bai/video_1.txt` | 600 | ByteTrack | 0.3 | 0.5 | 69.2s | 8.7 |
| `runs/nop_bai/video_2.txt` | 1050 | StrongSORT | 0.25 | 0.5 | 245.2s | 4.3 |
| `runs/nop_bai/video_3.txt` | 837 | ByteTrack | 0.3 | 0.5 | 69.6s | 12.0 |
| `runs/nop_bai/video_4.txt` | 900 | StrongSORT | 0.25 | 0.5 | 187.8s | 4.8 |
| `runs/nop_bai/video_5.txt` | 750 | StrongSORT | 0.25 | 0.5 | 141.9s | 5.3 |

✅ **5/5 file hoàn chỉnh** ✅

---

## 📊 Phân Tích Kết Quả

### ByteTrack (Video 1, 3) — Chuyển động
- **Ưu điểm:** Nhanh (8.7-12.0 FPS), chỉ dùng chuyển động
- **Khi nào dùng:** Camera tĩnh, ánh sáng tốt, cảnh không quá đông
- **Video 1 (quảng trường):** ✓ Chuyển động rõ ràng, ByteTrack đủ tốt
- **Video 3 (camera di động):** ✓ ByteTrack không bị lừa bởi camera chuyển động

### StrongSORT (Video 2, 4, 5) — Chuyển động + Re-ID
- **Ưu điểm:** Re-ID mạnh, giữ ID khi người cắt nhau
- **Nhược điểm:** Chậm hơn (4.3-5.3 FPS)
- **Khi nào dùng:** Cảnh đông, ánh sáng yếu, người che khuất
- **Video 2 (phố đêm đông):** ✓ Re-ID xử lý ID nhảy của ByteTrack
- **Video 4 (trong nhà):** ✓ Ánh sáng yếu → Re-ID cần thiết
- **Video 5 (xe bus đông):** ✓ Cảnh rất đông + rung lắc → Re-ID giúp

---

## 📈 Kết Luận

| Yếu tố Cảnh | Tracker Tốt | Lý Do |
|------------|------------|------|
| **Camera tĩnh + ánh sáng tốt** | ByteTrack | Chuyển động rõ ràng, không cần Re-ID |
| **Cảnh đông** | StrongSORT | Re-ID phân biệt khi người cắt nhau |
| **Camera di chuyển** | ByteTrack | Không bị lừa bởi camera motion |
| **Ánh sáng yếu** | StrongSORT | Re-ID xác định ngoại hình |
| **Cảnh rất đông + rung lắc** | StrongSORT | Re-ID + chuyển động kết hợp |

---

## 📁 Báo Cáo Chi Tiết

**File:** `submission_template/BAO_CAO_mau.md`

Đã điền sẵn:
- ✅ Bảng cấu hình 5 video
- ✅ Phân tích chi tiết video 1 & 2
- ✅ Gợi ý tiếp theo nếu có thêm thời gian

---

## 🎯 Tóm Tắt

Bạn đã hoàn thành:
1. ✅ Chạy tất cả 5 video đủ frame
2. ✅ Chọn tracker phù hợp mỗi cảnh
3. ✅ Viết báo cáo chi tiết
4. ✅ Nộp 5 file `.txt` + báo cáo markdown

**Sẵn sàng nộp bài!** 🚀

---

*Nếu giảng viên yêu cầu HOTA/MOTA/IDF1 của video_1, hãy chạy lại lệnh `evaluate_practice.py` với đúng đường dẫn `eval_config.json` từ giảng viên cung cấp.*
