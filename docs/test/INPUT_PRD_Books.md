# Lean PRD: Tính năng Quản lý Sách (Book Management)

Tài liệu này mô tả chi tiết sản phẩm, chân dung người dùng, các luồng tính năng và tiêu chí nghiệm thu cho tính năng Quản lý Sách trong hệ thống thư viện số.

## 1. Mục tiêu & Chỉ số (Goals & Metrics)

*   **Mục tiêu 1**: **Tăng hiệu quả quản lý thư viện** bằng cách số hóa quy trình mượn/trả sách và theo dõi tồn kho.
    *   **Chỉ số chính**: Giảm 70% thời gian xử lý mượn/trả sách so với quy trình thủ công.
    *   **Chỉ số phụ**: Độ chính xác trong việc theo dõi tồn kho đạt 99.5%.
*   **Mục tiêu 2**: **Cải thiện trải nghiệm người dùng** trong việc tìm kiếm và mượn sách.
    *   **Chỉ số chính**: Tăng tỷ lệ hài lòng của người dùng lên 85% thông qua khảo sát.
    *   **Chỉ số phụ**: Thời gian tìm kiếm sách trung bình dưới 30 giây.
*   **Mục tiêu 3**: **Tối ưu hóa việc sử dụng tài nguyên thư viện** thông qua hệ thống đặt chỗ thông minh.
    *   **Chỉ số chính**: Tăng 40% tỷ lệ sử dụng sách trong thư viện.
    *   **Chỉ số phụ**: Giảm 60% số lượng sách bị quá hạn không được trả.

## 2. Chân dung người dùng (Personas)

*   **Persona 1: Mai - Sinh viên đại học**
    *   **Tiểu sử**: 20 tuổi, sinh viên ngành Văn học, thường xuyên cần mượn nhiều sách tham khảo cho nghiên cứu.
    *   **Mục tiêu**: Tìm kiếm nhanh chóng các sách liên quan đến chuyên ngành và đặt chỗ để đảm bảo có sách khi cần.
    *   **Trở ngại**: Khó khăn trong việc theo dõi sách đã mượn và ngày trả, lo lắng về việc quên trả sách đúng hạn.

*   **Persona 2: Tuấn - Thủ thư**
    *   **Tiểu sử**: 35 tuổi, có 10 năm kinh nghiệm làm thủ thư, chịu trách nhiệm quản lý kho sách và hỗ trợ người dùng.
    *   **Mục tiêu**: Quản lý hiệu quả việc mượn/trả sách, theo dõi tình trạng sách và xử lý các vấn đề liên quan đến quá hạn.
    *   **Trở ngại**: Mất nhiều thời gian xử lý thủ tục thủ công, khó khăn trong việc theo dõi tình trạng tất cả sách trong thư viện.

*   **Persona 3: Hùng - Độc giả yêu sách**
    *   **Tiểu sử**: 45 tuổi, kỹ sư phần mềm, đam mê đọc sách về công nghệ và khoa học.
    *   **Mục tiêu**: Khám phá sách mới, đặt chỗ sách phổ biến và theo dõi lịch sử đọc cá nhân.
    *   **Trở ngại**: Thường xuyên thất vọng khi sách muốn mượn đã hết, khó khăn trong việc nhận thông báo khi sách có sẵn.

*   **Persona 4: Lan - Quản lý thư viện**
    *   **Tiểu sử**: 40 tuổi, quản lý thư viện trường đại học, chịu trách nhiệm về hoạt động tổng thể của thư viện.
    *   **Mục tiêu**: Theo dõi báo cáo thống kê, quản lý danh mục sách và đảm bảo vận hành hiệu quả.
    *   **Trở ngại**: Thiếu dữ liệu chi tiết về việc sử dụng thư viện, khó khăn trong việc ra quyết định mua sách mới.

## 3. Tổng quan tính năng (Feature Overview)

*   **Quản lý danh mục sách**: Thêm, sửa, xóa thông tin sách bao gồm ISBN, tựa đề, tác giả, thể loại, số lượng và vị trí trong thư viện.
*   **Tìm kiếm và lọc sách**: Người dùng có thể tìm kiếm sách theo nhiều tiêu chí như tên, tác giả, thể loại, ISBN và xem tình trạng có sẵn.
*   **Hệ thống đặt chỗ**: Người dùng có thể đặt chỗ sách đang được mượn và nhận thông báo khi sách có sẵn.
*   **Quản lý mượn/trả sách**: Xử lý quy trình mượn sách, theo dõi ngày hết hạn và quản lý việc trả sách.
*   **Hệ thống phạt**: Tự động tính toán và quản lý phí phạt cho sách trả quá hạn hoặc bị hư hỏng.
*   **Báo cáo và thống kê**: Cung cấp báo cáo về tình trạng sử dụng thư viện, sách phổ biến và hiệu quả hoạt động.

## 4. Luồng người dùng (User Flows)

### 4.1. Luồng tìm kiếm và mượn sách thành công
1. Người dùng truy cập trang chủ thư viện và sử dụng thanh tìm kiếm.
2. Hệ thống hiển thị kết quả tìm kiếm với thông tin sách và tình trạng có sẵn.
3. Người dùng nhấn vào sách muốn mượn và xem chi tiết.
4. Nếu sách có sẵn, người dùng nhấn nút "Mượn sách".
5. Hệ thống xác nhận thông tin người dùng và thời gian mượn.
6. Hệ thống tạo phiếu mượn và cập nhật tình trạng sách.
7. Hệ thống gửi thông báo xác nhận và ngày trả dự kiến cho người dùng.

### 4.2. Luồng đặt chỗ sách đang được mượn
1. Người dùng tìm kiếm sách và thấy trạng thái "Đang được mượn".
2. Người dùng nhấn nút "Đặt chỗ" bên cạnh thông tin sách.
3. Hệ thống hiển thị thông tin về vị trí trong hàng đợi và thời gian ước tính.
4. Người dùng xác nhận đặt chỗ.
5. Hệ thống tạo đơn đặt chỗ và thêm người dùng vào hàng đợi.
6. Khi sách được trả, hệ thống tự động thông báo cho người đầu tiên trong hàng đợi.
7. Người dùng có 24 giờ để đến mượn sách sau khi nhận thông báo.

### 4.3. Luồng trả sách và xử lý phạt
1. Người dùng đến quầy thư viện để trả sách.
2. Thủ thư quét mã hoặc nhập thông tin sách cần trả.
3. Hệ thống hiển thị thông tin mượn sách và kiểm tra tình trạng sách.
4. Thủ thư đánh giá tình trạng vật lý của sách (tốt, hư hỏng nhẹ, hư hỏng nặng).
5. Nếu sách trả quá hạn hoặc bị hư hỏng, hệ thống tính toán phí phạt.
6. Hệ thống cập nhật trạng thái sách về "Có sẵn" và ghi nhận việc trả sách.
7. Nếu có người đặt chỗ, hệ thống tự động gửi thông báo cho người đầu tiên trong hàng đợi.

### 4.4. Luồng quản lý sách cho thủ thư
1. Thủ thư đăng nhập vào hệ thống quản lý với quyền hạn cao hơn.
2. Thủ thư truy cập mục "Quản lý danh mục" để thêm sách mới.
3. Hệ thống hiển thị form nhập thông tin sách bao gồm ISBN, tựa đề, tác giả, thể loại, số lượng.
4. Thủ thư nhập đầy đủ thông tin và nhấn "Thêm sách".
5. Hệ thống xác thực thông tin (kiểm tra ISBN trùng lặp) và lưu vào cơ sở dữ liệu.
6. Hệ thống tự động gán vị trí lưu trữ và tạo mã QR cho sách.
7. Thủ thư in nhãn mã QR và dán lên sách thực tế.

## 5. Tiêu chí nghiệm thu cấp cao (High-level Acceptance Criteria)

*   Người dùng có thể tìm kiếm sách theo tên, tác giả, ISBN hoặc thể loại và xem kết quả chính xác.
*   Người dùng có thể mượn sách có sẵn và nhận thông báo xác nhận với ngày trả dự kiến.
*   **Người dùng có thể đặt chỗ sách đang được mượn và nhận thông báo khi sách có sẵn.**
*   **Hệ thống tự động tính toán phí phạt cho sách trả quá hạn dựa trên quy định của thư viện.**
*   **Thủ thư có thể thêm, sửa, xóa thông tin sách và quản lý tồn kho.**
*   Hệ thống phải cập nhật tình trạng sách theo thời gian thực khi có thao tác mượn/trả.
*   Người dùng có thể xem lịch sử mượn sách và trạng thái các sách đang mượn.
*   **Hệ thống phải gửi nhắc nhở tự động trước 3 ngày và 1 ngày khi sách sắp hết hạn.**

## 6. Chức năng chi tiết theo role

### 6.1. Người dùng thường (Reader)
*   **Tìm kiếm sách**: Sử dụng bộ lọc nâng cao theo thể loại, tác giả, năm xuất bản.
*   **Xem chi tiết sách**: Thông tin đầy đủ, đánh giá, sách liên quan.
*   **Mượn sách**: Chọn thời gian mượn (7, 14, 21 ngày tùy loại sách).
*   **Đặt chỗ sách**: Xem vị trí trong hàng đợi, ước tính thời gian chờ.
*   **Quản lý tài khoản**: Xem sách đang mượn, lịch sử, phí phạt chưa thanh toán.
*   **Gia hạn sách**: Nếu không có người đặt chỗ và chưa gia hạn trước đó.

### 6.2. Thủ thư (Librarian)
*   **Quản lý mượn/trả**: Xử lý mượn/trả sách tại quầy, quét mã QR.
*   **Quản lý đặt chỗ**: Xem danh sách đặt chỗ, xử lý hủy đặt chỗ quá hạn.
*   **Xử lý phạt**: Thu phí phạt, miễn phạt trong trường hợp đặc biệt.
*   **Hỗ trợ người dùng**: Tìm kiếm sách thay người dùng, hướng dẫn sử dụng hệ thống.
*   **Kiểm kê**: Báo cáo sách thất lạc, hư hỏng, cần bảo trì.

### 6.3. Quản lý thư viện (Admin)
*   **Quản lý danh mục**: Thêm/sửa/xóa sách, thể loại, tác giả.
*   **Cấu hình hệ thống**: Thiết lập thời gian mượn, mức phạt, quy định thư viện.
*   **Báo cáo thống kê**: Sách được mượn nhiều nhất, thống kê người dùng, hiệu quả vận hành.
*   **Quản lý người dùng**: Khóa/mở khóa tài khoản, phân quyền thủ thư.
*   **Backup và bảo trì**: Sao lưu dữ liệu, cập nhật hệ thống.

## 7. Quy định nghiệp vụ (Business Rules)

### 7.1. Quy định mượn sách
*   **Giới hạn mượn**: Sinh viên tối đa 5 quyển, giảng viên tối đa 10 quyển, độc giả ngoài tối đa 3 quyển.
*   **Thời gian mượn**: Sách giáo khoa 14 ngày, sách tham khảo 7 ngày, sách mới phát hành 7 ngày.
*   **Gia hạn**: Được gia hạn 1 lần, thêm 7 ngày nếu không có người đặt chỗ.
*   **Điều kiện mượn**: Tài khoản không bị khóa, không có phạt quá 100,000 VND chưa thanh toán.

### 7.2. Quy định phạt
*   **Trả muộn**: 2,000 VND/ngày/quyển cho sách thường, 5,000 VND/ngày/quyển cho sách tham khảo.
*   **Mất sách**: Bồi thường 200% giá trị sách hoặc mua sách thay thế cùng phiên bản.
*   **Hư hỏng**: 10% giá trị sách cho hư hỏng nhẹ, 50% cho hư hỏng nặng.
*   **Phạt tối đa**: 500,000 VND/quyển, sau đó chuyển sang yêu cầu bồi thường.

### 7.3. Quy định đặt chỗ
*   **Thời gian giữ chỗ**: 24 giờ sau khi nhận thông báo sách có sẵn.
*   **Hàng đợi tối đa**: 10 người/quyển sách.
*   **Hủy tự động**: Đặt chỗ bị hủy nếu không đến mượn trong 24 giờ.
*   **Ưu tiên**: Giảng viên > Sinh viên > Độc giả ngoài trong cùng thời điểm đặt chỗ.

## 8. Giả định & Ràng buộc (Assumptions & Constraints)

*   **Giả định (Assumptions)**:
    *   Người dùng có smartphone hoặc máy tính để truy cập hệ thống.
    *   Thư viện có kết nối internet ổn định và hệ thống quét mã QR.
    *   Nhân viên thư viện được đào tạo sử dụng hệ thống mới.
    *   Hệ thống email và SMS hoạt động để gửi thông báo.

*   **Ràng buộc (Constraints)**:
    *   **Kỹ thuật**:
        *   Hệ thống phải đồng bộ với cơ sở dữ liệu hiện tại của thư viện.
        *   Thời gian phản hồi của tìm kiếm phải dưới 2 giây với 10,000+ đầu sách.
        *   Hỗ trợ ít nhất 500 người dùng truy cập đồng thời.
    *   **Sản phẩm**:
        *   Giao diện phải đơn giản, phù hợp với mọi lứa tuổi.
        *   Hỗ trợ đa ngôn ngữ (Tiếng Việt, Tiếng Anh).
    *   **Vận hành**:
        *   Hệ thống phải hoạt động 24/7 với thời gian downtime tối đa 1 giờ/tháng.
        *   Dữ liệu phải được sao lưu hàng ngày.

## 9. Tiêu chí thành công (Success Criteria)

*   **Ngắn hạn (3 tháng)**:
    *   90% người dùng có thể tìm kiếm và mượn sách thành công ngay lần đầu sử dụng.
    *   Giảm 50% thời gian xử lý mượn/trả sách tại quầy.
    *   100% sách trong thư viện được số hóa và có thể tìm kiếm được.

*   **Trung hạn (6 tháng)**:
    *   Tăng 30% lượng sách được mượn so với trước khi có hệ thống.
    *   Giảm 80% số sách bị quá hạn không được trả đúng hẹn.
    *   95% người dùng hài lòng với hệ thống qua khảo sát.

*   **Dài hạn (1 năm)**:
    *   Hệ thống tự vận hành với tối thiểu sự can thiệp thủ công.
    *   Dữ liệu thống kê hỗ trợ hiệu quả việc mua sắm sách mới.
    *   Mở rộng tích hợp với các thư viện khác trong khu vực.