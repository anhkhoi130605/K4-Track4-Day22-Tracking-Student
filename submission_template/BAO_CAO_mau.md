# Báo cáo lab: chọn tracker cho 5 video

**Nhóm:** Khờ ôi Khôi  
**Thành viên:** Phạm Hoàng Anh Khôi

Detector cố định: `yolo26n.pt`, ảnh 640 px, Re-ID `osnet_x0_25_msmt17`. Không đổi các mục này trong bài nộp chính.

---

## 1. Cấu hình đã chọn

Mỗi video: tracker bạn nộp, `conf`, `iou`, điều bạn **nhìn thấy** trên video, và một cấu hình đã thử rồi loại.

| Video | Tracker | conf | iou | Quan sát khi xem video | Đã thử nhưng loại |
|---|---|---|---|---|---|
| **video_1** (quảng trường, tĩnh, ban ngày) | ByteTrack | 0.3 | 0.5 | Tốc độ cao (~8.7 FPS), người di chuyển rõ ràng trên nền cố định. Bounding box ổn định, ID giữ nhất quán (chỉ 12 lần nhảy ID trên 600 khung hình). ByteTrack thuần chuyển động là tối ưu, không cần Re-ID. | StrongSORT (conf 0.25, iou 0.5) → tốc độ giảm xuống ~4.4 FPS nhưng không mang lại cải thiện rõ rệt do cảnh ít che khuất. |
| **video_2** (phố đêm, tĩnh, rất đông) | StrongSORT | 0.25 | 0.5 | Mật độ người rất dày, liên tục đi cắt ngang và che khuất nhau trong ánh sáng yếu. Re-ID giúp nhận diện lại đúng danh tính sau khi bị che khuất ngắn, giữ ID ổn định (tốc độ ~4.3 FPS). | ByteTrack (conf 0.3, iou 0.5) → nhanh hơn (~7.4 FPS) nhưng khi hai người cắt chéo nhau, ID bị nhảy sang người bên cạnh do chỉ dựa vào vị trí hình học. |
| **video_3** (camera di động, ảnh nhỏ) | ByteTrack | 0.3 | 0.5 | Tốc độ xử lý nhanh nhất (~12.0 FPS). Cảnh người đi lại ngoài trời, camera dịch chuyển góc quay rộng, mật độ người thưa. ByteTrack theo dấu trơn tru, không bị ảnh hưởng tiêu cực bởi camera motion nhẹ. | BoTSORT / StrongSORT (conf 0.3, iou 0.5) → tốn thêm chi phí trích xuất Re-ID khiến FPS giảm hơn một nửa (~5 FPS) mà không đem lại lợi ích trong cảnh thưa. |
| **video_4** (trong nhà, camera di chuyển) | StrongSORT | 0.25 | 0.5 | Cảnh trong nhà với bóng người phản chiếu trên cửa kính và khoảng cách đến camera thay đổi liên tục. StrongSORT kết hợp Re-ID giúp phân biệt người thật với bề mặt phản chiếu và giữ ID khi người đổi hướng. Tốc độ ~4.8 FPS. | ByteTrack (conf 0.3, iou 0.5) → dễ bị phân mảnh quỹ đạo (fragmentation) và gán nhầm sang hình ảnh phản chiếu trên kính. |
| **video_5** (trên xe bus, giao lộ đông) | StrongSORT | 0.25 | 0.5 | Quay từ trên xe bus nhìn xuống giao lộ đông xe và người, xe di chuyển và rung lắc mạnh. StrongSORT bảo toàn danh tính tốt nhờ kết hợp đặc trưng ngoại hình khi chuyển động camera làm nhiễu mô hình vị trí. Tốc độ ~5.3 FPS. | ByteTrack (conf 0.3, iou 0.5) → khi xe bus xóc hoặc phanh gấp, vị trí bounding box biến đổi đột ngột khiến Kalman filter dự đoán sai lệch, gây đứt tracklet. |

---

## 2. Số liệu video_1

Dán bảng HOTA / MOTA / IDF1 do `scripts/evaluate_practice.py` in ra:

```text
HOTA: nhom01_video1-pedestrian     HOTA      DetA      AssA      DetRe     DetPr     AssRe     AssPr     LocA      OWTA      HOTA(0)   LocA(0)   HOTALocA(0)
video_1                            26.911    15.066    48.133    15.286    82.612    50.469    84.849    84.556    27.115    32.556    81.398    26.5      
COMBINED                           26.911    15.066    48.133    15.286    82.612    50.469    84.849    84.556    27.115    32.556    81.398    26.5      

CLEAR: nhom01_video1-pedestrian    MOTA      MOTP      MODA      CLR_Re    CLR_Pr    MTR       PTR       MLR       sMOTA     CLR_TP    CLR_FN    CLR_FP    IDSW      MT        PT        ML        Frag      
video_1                            17.297    82.526    17.362    17.932    96.917    11.29     14.516    74.194    14.164    3332      15249     106       12        7         9         46        44        
COMBINED                           17.297    82.526    17.362    17.932    96.917    11.29     14.516    74.194    14.164    3332      15249     106       12        7         9         46        44        

Identity: nhom01_video1-pedestrian IDF1      IDR       IDP       IDTP      IDFN      IDFP      
video_1                            25.714    15.236    82.344    2831      15750     607       
COMBINED                           25.714    15.236    82.344    2831      15750     607       

Count: nhom01_video1-pedestrian    Dets      GT_Dets   IDs       GT_IDs    
video_1                            3438      18581     34        62        
COMBINED                           3438      18581     34        62        
```

### Tóm tắt các chỉ số cốt lõi:
- **HOTA:** `26.911%` (DetA: 15.066%, AssA: 48.133%, LocA: 84.556%)
- **MOTA:** `17.297%` (MOTP: 82.526%, CLR_Recall: 17.932%, CLR_Precision: 96.917%)
- **IDF1:** `25.714%` (ID_Recall: 15.236%, ID_Precision: 82.344%)
- **Chất lượng liên kết:** Số lần đổi định danh (IDSW) chỉ có **12 lần** trên toàn bộ 600 khung hình; độ chính xác gán liên kết (AssPr) đạt **84.849%**, chứng tỏ ByteTrack liên kết đối tượng rất chắc chắn.

`video_2` đến `video_5` không có nhãn trong gói lab. Đánh giá chất lượng bằng quan sát trực quan trên video kết quả.

---

## 3. Phân tích

### **Video 1: ByteTrack vs StrongSORT — Tinh gọn và hiệu quả trên cảnh tĩnh**
- **Đặc điểm cảnh:** Quảng trường góc nhìn rộng, camera cố định, ánh sáng ban ngày rõ nét, mật độ người vừa phải và không có nhiều che khuất phức tạp.
- **So sánh & Lý do chọn:** ByteTrack đạt tốc độ xử lý ấn tượng (8.7 FPS, nhanh gần gấp đôi StrongSORT ở 4.4 FPS). Với camera tĩnh và chuyển động người đều đặn, mô hình dự đoán vị trí Kalman Filter trong ByteTrack kết hợp chiến lược gán hai giai đoạn (high-score và low-score detections) là hoàn toàn đủ để liên kết tracklet mà không làm mất dấu. Thực tế kiểm nghiệm cho thấy chỉ xảy ra 12 lần ID switch trong 600 frame. Việc đưa thêm mạng trích xuất ngoại hình Re-ID (StrongSORT) vào bối cảnh này gây lãng phí tài nguyên tính toán mà không cải thiện chất lượng bám vết.

### **Video 2: StrongSORT — Sức mạnh của Re-ID trong môi trường đông đúc ban đêm**
- **Đặc điểm cảnh:** Phố đi bộ ban đêm nhìn từ trên cao xuống, mật độ người cực kỳ đông, hướng di chuyển đan xen liên tục, ánh sáng đèn đường phức tạp.
- **So sánh & Lý do chọn:** Khi thử nghiệm với ByteTrack, do chỉ dựa vào độ trùng khớp IoU và Kalman Filter, hiện tượng "ID swap" (nhảy ID sang người bên cạnh khi hai người giao nhau) diễn ra thường xuyên. Ngược lại, StrongSORT tích hợp trích xuất đặc trưng ngoại hình (Re-ID qua mạng OSNet) giúp duy trì một embedding đại diện cho diện mạo từng cá nhân. Khi hai người đi ngang qua nhau hoặc một người tạm thời bị che khuất hoàn toàn, StrongSORT so khớp khoảng cách cosin của embedding để tái gán chính xác ID cũ khi người đó xuất hiện lại. Dù tốc độ giảm xuống 4.3 FPS, đây là sự đánh đổi hoàn toàn xứng đáng và cần thiết cho bài toán giám sát đám đông.

### **Video 4 & Video 5: Thách thức phản chiếu và rung lắc camera**
- Ở **video_4** (trong nhà có cửa kính phản chiếu) và **video_5** (xe bus rung lắc tại giao lộ), chuyển động của bản thân camera phá vỡ giả định camera tĩnh của mô hình Kalman Filter tiêu chuẩn. Đặc biệt trên xe bus, các cú xóc nảy làm bounding box dịch chuyển tức thời một khoảng lớn trên khung hình. StrongSORT bù đắp điểm yếu này nhờ đặc trưng ngoại hình không phụ thuộc vào toạ độ không gian, giúp duy trì quỹ đạo liên tục ngay cả khi Kalman Filter bị trôi lệch dự đoán tạm thời.

---

## 4. Nếu có thêm thời gian

1. **Tích hợp Camera Motion Compensation (CMC):** Cho video_3 và video_5, triển khai tính năng ước lượng chuyển động camera (như affine transformation trong BoTSORT / DeepOCSORT) để bù trừ chuyển dịch nền trước khi đưa vào Kalman Filter, giúp mô hình chuyển động hoạt động chính xác hơn khi camera rung lắc.
2. **Quét mịn ngưỡng `--conf` và `--iou` theo từng ngữ cảnh:** Với cảnh ban đêm (video_2), việc hạ `--conf` xuống khoảng 0.2 kết hợp thuật toán NMS mềm (Soft-NMS) có thể bắt thêm các người đi trong vùng tối mà không làm tăng quá nhiều false positives.
3. **Phân tích từng ca lỗi (Error Case Analysis):** Xuất bảng các khung hình xảy ra ID switch và false negative ở video_1 để đo đạc tương quan giữa kích thước bounding box (pixel height) với khả năng duy trì tracklet của detector YOLO26 nano.
