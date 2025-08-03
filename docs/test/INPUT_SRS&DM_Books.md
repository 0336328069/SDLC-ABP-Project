# Lean SRS & Domain Model: Tính năng Quản lý Sách

Tài liệu này đặc tả chi tiết các yêu cầu kỹ thuật, yêu cầu chức năng, phi chức năng, và mô hình dữ liệu cho tính năng Quản lý Sách trong hệ thống thư viện số.

## 1. Yêu cầu chức năng (Functional Requirements)

### 1.1. Quản lý danh mục sách (FR-CAT)

| ID          | Mô tả yêu cầu                                                                                                    |
|-------------|------------------------------------------------------------------------------------------------------------------|
| **FR-CAT-01** | Hệ thống **PHẢI** cung cấp giao diện cho quản lý thư viện để thêm sách mới vào danh mục.              |
| **FR-CAT-02** | Biểu mẫu thêm sách **PHẢI** chứa các trường: `ISBN`, `Tựa đề`, `Tác giả` (ít nhất một), `Thể loại`, `Nhà xuất bản`, `Năm xuất bản`, `Số lượng`. |
| **FR-CAT-03** | Hệ thống **PHẢI** kiểm tra tính hợp lệ của ISBN theo chuẩn ISBN-10 hoặc ISBN-13.                                         |
| **FR-CAT-04** | Hệ thống **PHẢI** kiểm tra ISBN có tồn tại trong cơ sở dữ liệu hay không. Nếu đã tồn tại, hệ thống **PHẢI** hiển thị thông báo lỗi: `ISBN này đã tồn tại trong hệ thống.` |
| **FR-CAT-05** | Hệ thống **PHẢI** yêu cầu tựa đề sách có độ dài từ 3 đến 200 ký tự và không chứa ký tự đặc biệt không hợp lệ. |
| **FR-CAT-06** | Hệ thống **PHẢI** cho phép thêm nhiều tác giả cho một cuốn sách và yêu cầu ít nhất một tác giả. |
| **FR-CAT-07** | Hệ thống **PHẢI** yêu cầu năm xuất bản phải là số và không được lớn hơn năm hiện tại. |
| **FR-CAT-08** | Sau khi thêm sách thành công, hệ thống **PHẢI** tạo mã QR cho sách và hiển thị thông báo thành công. |
| **FR-CAT-09** | Hệ thống **PHẢI** cho phép chỉnh sửa thông tin sách đã có, ngoại trừ ISBN. |
| **FR-CAT-10** | Hệ thống **PHẢI** cho phép xóa sách khỏi danh mục nếu sách không có ai đang mượn hoặc đặt chỗ. |

### 1.2. Tìm kiếm và lọc sách (FR-SEARCH)

| ID          | Mô tả yêu cầu                                                                                                                                |
|-------------|----------------------------------------------------------------------------------------------------------------------------------------------|
| **FR-SEARCH-01** | Hệ thống **PHẢI** cung cấp thanh tìm kiếm cho phép người dùng tìm sách theo từ khóa.                                                                 |
| **FR-SEARCH-02** | Hệ thống **PHẢI** hỗ trợ tìm kiếm theo các tiêu chí: `Tựa đề`, `Tác giả`, `ISBN`, `Thể loại`.                                                                      |
| **FR-SEARCH-03** | Hệ thống **PHẢI** hiển thị kết quả tìm kiếm với thông tin: Tựa đề, tác giả, thể loại, tình trạng có sẵn.           |
| **FR-SEARCH-04** | Hệ thống **PHẢI** cho phép lọc kết quả theo tình trạng: `Có sẵn`, `Đang được mượn`, `Đã đặt chỗ`.          |
| **FR-SEARCH-05** | Hệ thống **PHẢI** hỗ trợ lọc theo thể loại sách với danh sách dropdown.                                                                 |
| **FR-SEARCH-06** | Hệ thống **PHẢI** hiển thị tối đa 20 kết quả mỗi trang và hỗ trợ phân trang.            |
| **FR-SEARCH-07** | Hệ thống **PHẢI** cho phép sắp xếp kết quả theo: `Tên A-Z`, `Tên Z-A`, `Năm xuất bản mới nhất`, `Năm xuất bản cũ nhất`.            |

### 1.3. Hệ thống đặt chỗ (FR-RESERVE)

| ID          | Mô tả yêu cầu                                                                                                                                                             |
|-------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **FR-RESERVE-01**  | Hệ thống **PHẢI** cho phép người dùng đặt chỗ sách đang được mượn.                                                                                            |
| **FR-RESERVE-02**  | Khi đặt chỗ, hệ thống **PHẢI** hiển thị vị trí trong hàng đợi và thời gian ước tính có sách.                                         |
| **FR-RESERVE-03**  | Hệ thống **PHẢI** giới hạn tối đa 10 người trong hàng đợi cho mỗi cuốn sách.                                                          |
| **FR-RESERVE-04**  | Hệ thống **PHẢI** tự động gửi thông báo email khi sách có sẵn cho người đầu tiên trong hàng đợi.     |
| **FR-RESERVE-05**  | Người dùng **PHẢI** có 24 giờ để đến mượn sách sau khi nhận thông báo, sau đó đặt chỗ tự động hủy.                                                             |
| **FR-RESERVE-06**  | Hệ thống **PHẢI** cho phép người dùng hủy đặt chỗ bất kỳ lúc nào.                                             |
| **FR-RESERVE-07**  | Hệ thống **PHẢI** ưu tiên đặt chỗ theo thứ tự: Giảng viên > Sinh viên > Độc giả ngoài.                     |

### 1.4. Quản lý mượn sách (FR-BORROW)

| ID          | Mô tả yêu cầu                                                                                        |
|-------------|------------------------------------------------------------------------------------------------------|
| **FR-BORROW-01** | Hệ thống **PHẢI** kiểm tra giới hạn mượn của người dùng trước khi cho phép mượn sách. |
| **FR-BORROW-02** | Giới hạn mượn: Sinh viên 5 quyển, Giảng viên 10 quyển, Độc giả ngoài 3 quyển.              |
| **FR-BORROW-03** | Hệ thống **PHẢI** tính toán ngày trả dự kiến dựa trên loại sách: Sách thường 14 ngày, Sách tham khảo 7 ngày.          |
| **FR-BORROW-04** | Hệ thống **PHẢI** cập nhật trạng thái sách thành `Đang được mượn` và giảm số lượng có sẵn.          |
| **FR-BORROW-05** | Hệ thống **PHẢI** tạo phiếu mượn với thông tin: Mã phiếu, người mượn, sách, ngày mượn, ngày trả dự kiến.          |
| **FR-BORROW-06** | Hệ thống **PHẢI** gửi email xác nhận mượn sách và nhắc nhở trước 3 ngày và 1 ngày khi sắp hết hạn.          |
| **FR-BORROW-07** | Hệ thống **PHẢI** cho phép gia hạn sách 1 lần nếu không có người đặt chỗ.          |

### 1.5. Quản lý trả sách và phạt (FR-RETURN)

| ID          | Mô tả yêu cầu                                                                                        |
|-------------|------------------------------------------------------------------------------------------------------|
| **FR-RETURN-01** | Hệ thống **PHẢI** cho phép thủ thư quét mã QR hoặc nhập thông tin để xử lý trả sách. |
| **FR-RETURN-02** | Hệ thống **PHẢI** kiểm tra tình trạng vật lý của sách khi trả: Tốt, Hư hỏng nhẹ, Hư hỏng nặng.              |
| **FR-RETURN-03** | Hệ thống **PHẢI** tự động tính phạt cho sách trả muộn: 2,000 VND/ngày cho sách thường, 5,000 VND/ngày cho sách tham khảo.          |
| **FR-RETURN-04** | Hệ thống **PHẢI** tính phạt hư hỏng: 10% giá trị sách cho hư hỏng nhẹ, 50% cho hư hỏng nặng.          |
| **FR-RETURN-05** | Hệ thống **PHẢI** cập nhật trạng thái sách về `Có sẵn` và tăng số lượng có sẵn sau khi trả.          |
| **FR-RETURN-06** | Nếu có người đặt chỗ, hệ thống **PHẢI** tự động thông báo cho người đầu tiên trong hàng đợi.          |
| **FR-RETURN-07** | Hệ thống **PHẢI** lưu lịch sử mượn/trả cho mục đích báo cáo và kiểm toán.          |

## 2. Yêu cầu phi chức năng (Non-Functional Requirements)

| ID           | Thể loại      | Mô tả yêu cầu                                                                                                                            |
|--------------|---------------|------------------------------------------------------------------------------------------------------------------------------------------|
| **NFR-PER-01** | **Hiệu năng**   | Thời gian tìm kiếm sách **PHẢI** dưới 2 giây với cơ sở dữ liệu 10,000+ đầu sách.                             |
| **NFR-PER-02** | **Hiệu năng**   | Hệ thống **PHẢI** hỗ trợ ít nhất 500 người dùng truy cập đồng thời mà không ảnh hưởng hiệu năng.                                           |
| **NFR-SEC-01** | **Bảo mật**   | Dữ liệu cá nhân trong lịch sử mượn sách **PHẢI** được mã hóa và chỉ lưu trữ trong thời gian cần thiết.                                         |
| **NFR-SEC-02** | **Bảo mật**   | Chỉ thủ thư và quản lý **PHẢI** có quyền chỉnh sửa thông tin sách và xử lý mượn/trả.                                                               |
| **NFR-USA-01** | **Khả dụng**  | Hệ thống **PHẢI** hoạt động 24/7 với thời gian downtime tối đa 1 giờ/tháng.                                                                 |
| **NFR-USA-02** | **Khả dụng**  | Dữ liệu **PHẢI** được sao lưu hàng ngày và có khả năng khôi phục trong 4 giờ.         |
| **NFR-UX-01** | **Trải nghiệm** | Giao diện **PHẢI** hỗ trợ đa ngôn ngữ (Tiếng Việt, Tiếng Anh).         |
| **NFR-UX-02** | **Trải nghiệm** | Giao diện **PHẢI** responsive và hoạt động tốt trên mobile, tablet, desktop.         |

## 3. Mô hình miền & Thuật ngữ (Domain Model & Glossary)

Phần này định nghĩa các khái niệm và thuật ngữ cốt lõi trong miền nghiệp vụ Quản lý Sách, nhằm mục đích tạo ra một "Ngôn ngữ chung" (Ubiquitous Language) cho cả đội ngũ kinh doanh và kỹ thuật.

### 3.1. Book (Sách)

*   **Định nghĩa**: Là thực thể chính đại diện cho một đầu sách trong thư viện, chứa tất cả thông tin mô tả và quản lý tồn kho.
*   **Thuộc tính (Attributes)**:
    *   `ISBN`: Mã số tiêu chuẩn quốc tế định danh duy nhất cho sách, có thể là ISBN-10 hoặc ISBN-13.
    *   `Title`: Tựa đề chính của sách, độ dài từ 3-200 ký tự.
    *   `Subtitle`: Tựa đề phụ của sách (tùy chọn).
    *   `Authors`: Danh sách tác giả, ít nhất phải có một tác giả.
    *   `Publisher`: Nhà xuất bản của sách.
    *   `Publication Date`: Ngày xuất bản, không được lớn hơn ngày hiện tại.
    *   `Category`: Thể loại/phân loại của sách (Văn học, Khoa học, Lịch sử, v.v.).
    *   `Language`: Ngôn ngữ chính của sách.
    *   `Pages`: Số trang của sách.
    *   `Description`: Mô tả chi tiết về nội dung sách.
    *   `Cover Image URL`: Đường dẫn đến ảnh bìa sách.
    *   `Total Quantity`: Tổng số lượng sách có trong thư viện.
    *   `Available Quantity`: Số lượng sách hiện có sẵn để mượn.
    *   `Book Type`: Loại sách (Sách thường, Sách tham khảo, Sách mới phát hành).

### 3.2. Category (Thể loại)

*   **Định nghĩa**: Hệ thống phân loại sách theo chủ đề hoặc lĩnh vực, giúp tổ chức và tìm kiếm sách hiệu quả.
*   **Thuộc tính**:
    *   `Name`: Tên thể loại (Văn học, Khoa học, Công nghệ, v.v.).
    *   `Description`: Mô tả chi tiết về thể loại.
    *   `Parent Category`: Thể loại cha (để tạo cấu trúc phân cấp).
    *   `Is Active`: Trạng thái hoạt động của thể loại.
    *   `Display Order`: Thứ tự hiển thị trong danh sách.

### 3.3. Book Reservation (Đặt chỗ sách)

*   **Định nghĩa**: Đại diện cho việc một người dùng đặt chỗ một cuốn sách đang được mượn, tạo hàng đợi chờ.
*   **Thuộc tính**:
    *   `Book`: Sách được đặt chỗ.
    *   `User`: Người dùng đặt chỗ.
    *   `Reservation Date`: Ngày đặt chỗ.
    *   `Expiration Date`: Ngày hết hạn đặt chỗ (24 giờ sau khi sách có sẵn).
    *   `Queue Position`: Vị trí trong hàng đợi.
    *   `Status`: Trạng thái đặt chỗ (Đang chờ, Có sẵn, Đã hủy, Hết hạn).

### 3.4. Book Borrow (Mượn sách)

*   **Định nghĩa**: Đại diện cho việc một người dùng mượn một cuốn sách, tạo phiếu mượn với thời hạn trả.
*   **Thuộc tính**:
    *   `Book`: Sách được mượn.
    *   `User`: Người mượn sách.
    *   `Borrow Date`: Ngày mượn sách.
    *   `Due Date`: Ngày hết hạn trả sách.
    *   `Return Date`: Ngày thực tế trả sách (null nếu chưa trả).
    *   `Status`: Trạng thái mượn (Đang mượn, Đã trả, Quá hạn).
    *   `Is Renewed`: Đã gia hạn hay chưa.
    *   `Return Condition`: Tình trạng sách khi trả (Tốt, Hư hỏng nhẹ, Hư hỏng nặng).

### 3.5. Fine (Phạt)

*   **Định nghĩa**: Đại diện cho các khoản phạt mà người dùng phải thanh toán do trả sách muộn hoặc hư hỏng sách.
*   **Thuộc tính**:
    *   `User`: Người dùng bị phạt.
    *   `Book Borrow`: Phiếu mượn liên quan đến khoản phạt.
    *   `Fine Type`: Loại phạt (Trả muộn, Hư hỏng, Mất sách).
    *   `Amount`: Số tiền phạt.
    *   `Description`: Mô tả chi tiết lý do phạt.
    *   `Issue Date`: Ngày phát sinh phạt.
    *   `Payment Date`: Ngày thanh toán phạt (null nếu chưa thanh toán).
    *   `Status`: Trạng thái phạt (Chưa thanh toán, Đã thanh toán, Được miễn).

### 3.6. Author (Tác giả)

*   **Định nghĩa**: Thông tin về tác giả của sách, có thể có nhiều tác giả cho một cuốn sách.
*   **Thuộc tính**:
    *   `First Name`: Tên.
    *   `Last Name`: Họ.
    *   `Middle Name`: Tên đệm (tùy chọn).
    *   `Biography`: Tiểu sử tác giả.
    *   `Birth Date`: Ngày sinh.
    *   `Death Date`: Ngày mất (nếu có).
    *   `Nationality`: Quốc tịch.

### 3.7. Library Member (Thành viên thư viện)

*   **Định nghĩa**: Mở rộng từ User Account, bao gồm thông tin đặc biệt liên quan đến việc sử dụng thư viện.
*   **Thuộc tính**:
    *   `Membership Type`: Loại thành viên (Sinh viên, Giảng viên, Độc giả ngoài).
    *   `Member ID`: Mã thành viên duy nhất.
    *   `Registration Date`: Ngày đăng ký thành viên.
    *   `Expiration Date`: Ngày hết hạn thành viên.
    *   `Borrow Limit`: Giới hạn số sách có thể mượn cùng lúc.
    *   `Current Borrowed Count`: Số sách đang mượn hiện tại.
    *   `Total Fine Amount`: Tổng số tiền phạt chưa thanh toán.

## 4. Quy tắc nghiệp vụ (Business Rules)

### 4.1. Quy tắc mượn sách
*   Một người dùng không thể mượn cùng một cuốn sách nhiều lần cùng lúc.
*   Người dùng không thể mượn sách mới nếu có phạt chưa thanh toán quá 100,000 VND.
*   Sách tham khảo chỉ có thể mượn trong 7 ngày và không được gia hạn.
*   Gia hạn chỉ được phép 1 lần và chỉ khi không có người đặt chỗ.

### 4.2. Quy tắc đặt chỗ
*   Một người dùng không thể đặt chỗ sách mà họ đang mượn.
*   Đặt chỗ tự động hủy nếu không đến mượn trong 24 giờ sau thông báo.
*   Thứ tự ưu tiên: Giảng viên > Sinh viên > Độc giả ngoài.
*   Tối đa 10 người trong hàng đợi cho mỗi cuốn sách.

### 4.3. Quy tắc phạt
*   Phạt trả muộn được tính từ ngày đầu tiên quá hạn.
*   Phạt tối đa cho mỗi cuốn sách là 500,000 VND.
*   Sau 30 ngày quá hạn, sách được coi là "Mất" và tính phạt toàn bộ giá trị.
*   Phạt hư hỏng được đánh giá bởi thủ thư dựa trên tình trạng thực tế.

### 4.4. Quy tắc quản lý danh mục
*   ISBN phải duy nhất trong toàn hệ thống.
*   Sách chỉ có thể xóa nếu không có ai đang mượn hoặc đặt chỗ.
*   Thông tin sách có thể chỉnh sửa trừ ISBN.
*   Thể loại phải tồn tại trước khi gán cho sách.

## 5. Ràng buộc tích hợp (Integration Constraints)

### 5.1. Tích hợp với hệ thống Authentication
*   Sử dụng thông tin User từ hệ thống Authentication đã có.
*   Kiểm tra quyền hạn người dùng trước khi cho phép thực hiện các thao tác.
*   Đồng bộ thông tin cơ bản của người dùng.

### 5.2. Tích hợp với hệ thống Email
*   Gửi thông báo đặt chỗ thành công.
*   Nhắc nhở trước khi sách hết hạn.
*   Thông báo phạt và yêu cầu thanh toán.

### 5.3. Tích hợp với hệ thống thanh toán (tương lai)
*   Chuẩn bị interface cho việc thanh toán phạt online.
*   Lưu trữ lịch sử giao dịch thanh toán.

## 6. Giả định hệ thống (System Assumptions)

*   Thư viện có đủ thiết bị quét mã QR cho việc mượn/trả sách.
*   Nhân viên thư viện được đào tạo đầy đủ về hệ thống mới.
*   Kết nối mạng ổn định để đồng bộ dữ liệu real-time.
*   Hệ thống backup hoạt động đáng tin cậy.
*   Có đủ tài nguyên máy chủ để xử lý tải cao trong giờ cao điểm.