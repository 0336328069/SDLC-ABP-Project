# User Stories & Acceptance Criteria: Tính năng Quản lý Sách

Tài liệu này chuyển đổi các yêu cầu thành các User Story có thể thực thi, tập trung vào giá trị mang lại cho người dùng cuối. Mỗi story đi kèm với các tiêu chí nghiệm thu chi tiết để kiểm thử.

---

### **Epic: Quản lý Thư viện Số**

---

### **User Story 1: Tìm kiếm sách trong thư viện**

*   **As a** (Với vai trò là) một độc giả,
*   **I want to** (tôi muốn) tìm kiếm sách theo nhiều tiêu chí khác nhau
*   **So that** (để) tôi có thể nhanh chóng tìm được sách mình cần.
*   **Độ ưu tiên**: Cao nhất
*   **Ghi chú**: Story này liên quan đến các yêu cầu `FR-SEARCH-01` đến `FR-SEARCH-07`.

#### **Tiêu chí nghiệm thu (Acceptance Criteria)**

**Kịch bản 1: Tìm kiếm sách thành công theo tên**
*   **Given** (Cho rằng) tôi đang ở trang chủ thư viện
*   **When** (Khi) tôi nhập "Harry Potter" vào thanh tìm kiếm
*   **And** (Và) tôi nhấn nút "Tìm kiếm"
*   **Then** (Thì) hệ thống hiển thị danh sách các sách có chứa từ khóa "Harry Potter" trong tựa đề
*   **And** (Và) mỗi kết quả hiển thị: tựa đề, tác giả, thể loại, tình trạng có sẵn
*   **And** (Và) kết quả được sắp xếp theo độ liên quan

**Kịch bản 2: Tìm kiếm với bộ lọc thể loại**
*   **Given** (Cho rằng) tôi đang ở trang tìm kiếm
*   **When** (Khi) tôi chọn thể loại "Khoa học viễn tưởng" từ dropdown
*   **And** (Và) tôi nhập "robot" vào thanh tìm kiếm
*   **Then** (Thì) hệ thống chỉ hiển thị sách khoa học viễn tưởng có chứa từ "robot"
*   **And** (Và) số lượng kết quả được hiển thị ở đầu danh sách

**Kịch bản 3: Lọc theo tình trạng có sẵn**
*   **Given** (Cho rằng) tôi đang xem kết quả tìm kiếm
*   **When** (Khi) tôi chọn bộ lọc "Chỉ hiển thị sách có sẵn"
*   **Then** (Thì) hệ thống chỉ hiển thị những sách có thể mượn ngay
*   **And** (Và) những sách đang được mượn hoặc đã đặt chỗ sẽ bị ẩn

**Kịch bản 4: Không tìm thấy kết quả**
*   **Given** (Cho rằng) tôi đang ở trang tìm kiếm
*   **When** (Khi) tôi tìm kiếm "sách không tồn tại xyz123"
*   **Then** (Thì) hệ thống hiển thị thông báo: "Không tìm thấy sách nào phù hợp với từ khóa của bạn"
*   **And** (Và) gợi ý một số sách phổ biến hoặc sách mới

---

### **User Story 2: Mượn sách có sẵn**

*   **As a** (Với vai trò là) một thành viên thư viện,
*   **I want to** (tôi muốn) mượn sách có sẵn một cách nhanh chóng
*   **So that** (để) tôi có thể đọc sách ở nhà trong thời gian cho phép.
*   **Độ ưu tiên**: Cao nhất
*   **Ghi chú**: Story này liên quan đến các yêu cầu `FR-BORROW-01` đến `FR-BORROW-07`.

#### **Tiêu chí nghiệm thu (Acceptance Criteria)**

**Kịch bản 1: Mượn sách thành công**
*   **Given** (Cho rằng) tôi đã đăng nhập và đang xem chi tiết một cuốn sách có sẵn
*   **And** (Và) tôi chưa đạt giới hạn mượn sách (5 quyển cho sinh viên)
*   **When** (Khi) tôi nhấn nút "Mượn sách"
*   **Then** (Thì) hệ thống tạo phiếu mượn với ngày trả sau 14 ngày (sách thường)
*   **And** (Và) trạng thái sách chuyển thành "Đang được mượn"
*   **And** (Và) tôi nhận được email xác nhận với thông tin phiếu mượn và ngày trả
*   **And** (Và) sách xuất hiện trong danh sách "Sách đang mượn" của tôi

**Kịch bản 2: Không thể mượn do đã đạt giới hạn**
*   **Given** (Cho rằng) tôi đã mượn 5 quyển sách (giới hạn sinh viên)
*   **When** (Khi) tôi cố gắng mượn thêm một cuốn sách nữa
*   **Then** (Thì) hệ thống hiển thị thông báo: "Bạn đã đạt giới hạn mượn sách. Vui lòng trả một cuốn trước khi mượn tiếp."
*   **And** (Và) nút "Mượn sách" bị vô hiệu hóa

**Kịch bản 3: Không thể mượn do có phạt chưa thanh toán**
*   **Given** (Cho rằng) tôi có khoản phạt 150,000 VND chưa thanh toán
*   **When** (Khi) tôi cố gắng mượn sách
*   **Then** (Thì) hệ thống hiển thị thông báo: "Bạn cần thanh toán phạt trước khi mượn sách mới. Số tiền phạt: 150,000 VND"
*   **And** (Và) có liên kết đến trang thanh toán phạt

**Kịch bản 4: Gia hạn sách đã mượn**
*   **Given** (Cho rằng) tôi có một cuốn sách đang mượn chưa hết hạn
*   **And** (Và) sách này chưa có ai đặt chỗ
*   **And** (Và) tôi chưa gia hạn sách này trước đó
*   **When** (Khi) tôi nhấn "Gia hạn" trong danh sách sách đang mượn
*   **Then** (Thì) ngày trả được gia hạn thêm 7 ngày
*   **And** (Và) tôi nhận được email xác nhận gia hạn với ngày trả mới

---

### **User Story 3: Đặt chỗ sách đang được mượn**

*   **As a** (Với vai trò là) một độc giả quan tâm,
*   **I want to** (tôi muốn) đặt chỗ sách đang được người khác mượn
*   **So that** (để) tôi có thể mượn sách ngay khi nó có sẵn mà không phải liên tục kiểm tra.
*   **Độ ưu tiên**: Cao
*   **Ghi chú**: Story này liên quan đến các yêu cầu `FR-RESERVE-01` đến `FR-RESERVE-07`.

#### **Tiêu chí nghiệm thu (Acceptance Criteria)**

**Kịch bản 1: Đặt chỗ sách thành công**
*   **Given** (Cho rằng) tôi đang xem chi tiết một cuốn sách có trạng thái "Đang được mượn"
*   **When** (Khi) tôi nhấn nút "Đặt chỗ"
*   **Then** (Thì) hệ thống tạo đơn đặt chỗ và thêm tôi vào hàng đợi
*   **And** (Và) hiển thị vị trí của tôi trong hàng đợi (ví dụ: "Bạn đang ở vị trí thứ 3")
*   **And** (Và) hiển thị thời gian ước tính: "Ước tính có sách sau 6 tuần"
*   **And** (Và) tôi nhận được email xác nhận đặt chỗ

**Kịch bản 2: Nhận thông báo khi sách có sẵn**
*   **Given** (Cho rằng) tôi đang ở vị trí đầu tiên trong hàng đợi
*   **When** (Khi) người đang mượn trả sách
*   **Then** (Thì) tôi nhận được email thông báo: "Sách bạn đặt chỗ đã có sẵn"
*   **And** (Và) email chứa liên kết để xác nhận mượn sách
*   **And** (Và) tôi có 24 giờ để đến thư viện mượn sách

**Kịch bản 3: Hủy đặt chỗ tự động sau 24 giờ**
*   **Given** (Cho rằng) tôi đã nhận thông báo sách có sẵn
*   **When** (Khi) tôi không đến mượn sách trong 24 giờ
*   **Then** (Thì) đặt chỗ của tôi bị hủy tự động
*   **And** (Và) sách được thông báo cho người tiếp theo trong hàng đợi
*   **And** (Và) tôi nhận email thông báo hủy đặt chỗ

**Kịch bản 4: Không thể đặt chỗ khi hàng đợi đầy**
*   **Given** (Cho rằng) một cuốn sách đã có 10 người trong hàng đợi
*   **When** (Khi) tôi cố gắng đặt chỗ
*   **Then** (Thì) hệ thống hiển thị: "Hàng đợi đã đầy. Vui lòng thử lại sau."
*   **And** (Và) nút "Đặt chỗ" bị vô hiệu hóa

---

### **User Story 4: Trả sách và thanh toán phạt**

*   **As a** (Với vai trò là) một người mượn sách,
*   **I want to** (tôi muốn) trả sách và biết rõ mọi khoản phạt phát sinh
*   **So that** (để) tôi hoàn thành nghĩa vụ mượn sách và duy trì uy tín tài khoản.
*   **Độ ưu tiên**: Cao
*   **Ghi chú**: Story này liên quan đến các yêu cầu `FR-RETURN-01` đến `FR-RETURN-07`.

#### **Tiêu chí nghiệm thu (Acceptance Criteria)**

**Kịch bản 1: Trả sách đúng hạn, tình trạng tốt**
*   **Given** (Cho rằng) tôi đến thư viện để trả sách trước ngày hết hạn
*   **When** (Khi) thủ thư quét mã QR của sách
*   **And** (Và) đánh giá tình trạng sách là "Tốt"
*   **Then** (Thì) hệ thống cập nhật trạng thái sách về "Có sẵn"
*   **And** (Và) phiếu mượn được đóng với trạng thái "Đã trả"
*   **And** (Và) không có khoản phạt nào phát sinh
*   **And** (Và) tôi nhận được xác nhận trả sách thành công

**Kịch bản 2: Trả sách muộn với phạt**
*   **Given** (Cho rằng) tôi trả sách sau 3 ngày quá hạn
*   **When** (Khi) thủ thư xử lý trả sách
*   **Then** (Thì) hệ thống tính phạt: 3 ngày × 2,000 VND = 6,000 VND
*   **And** (Và) hiển thị thông tin phạt cho thủ thư và tôi
*   **And** (Và) khoản phạt được thêm vào tài khoản của tôi
*   **And** (Và) tôi có thể thanh toán ngay hoặc thanh toán sau

**Kịch bản 3: Trả sách bị hư hỏng**
*   **Given** (Cho rằng) tôi trả sách với tình trạng "Hư hỏng nhẹ"
*   **When** (Khi) thủ thư đánh giá và xác nhận mức độ hư hỏng
*   **Then** (Thì) hệ thống tính phạt hư hỏng: 10% × giá trị sách
*   **And** (Và) hiển thị chi tiết: "Phạt hư hỏng: 50,000 VND (10% × 500,000 VND)"
*   **And** (Và) tôi có thể xem ảnh chụp tình trạng sách để đối chiếu

**Kịch bản 4: Thông báo người đặt chỗ khi trả sách**
*   **Given** (Cho rằng) sách tôi trả có người đặt chỗ
*   **When** (Khi) việc trả sách hoàn tất
*   **Then** (Thì) hệ thống tự động gửi email cho người đầu tiên trong hàng đợi
*   **And** (Và) trạng thái sách chuyển thành "Đã đặt chỗ" thay vì "Có sẵn"
*   **And** (Và) thủ thư nhận thông báo để giữ sách cho người đặt chỗ

---

### **User Story 5: Quản lý danh mục sách (Thủ thư/Admin)**

*   **As a** (Với vai trò là) một thủ thư hoặc quản lý thư viện,
*   **I want to** (tôi muốn) thêm, sửa, xóa thông tin sách trong hệ thống
*   **So that** (để) danh mục sách luôn được cập nhật và chính xác.
*   **Độ ưu tiên**: Cao
*   **Ghi chú**: Story này liên quan đến các yêu cầu `FR-CAT-01` đến `FR-CAT-10`.

#### **Tiêu chí nghiệm thu (Acceptance Criteria)**

**Kịch bản 1: Thêm sách mới thành công**
*   **Given** (Cho rằng) tôi đăng nhập với quyền thủ thư
*   **When** (Khi) tôi truy cập trang "Quản lý sách" và nhấn "Thêm sách mới"
*   **And** (Và) tôi điền đầy đủ thông tin: ISBN, tựa đề, tác giả, thể loại, nhà xuất bản, năm xuất bản, số lượng
*   **And** (Và) tôi nhấn "Lưu sách"
*   **Then** (Thì) sách được thêm vào danh mục
*   **And** (Và) hệ thống tự động tạo mã QR cho sách
*   **And** (Và) hiển thị thông báo: "Thêm sách thành công. Mã QR đã được tạo."

**Kịch bản 2: Không thể thêm sách với ISBN trùng lặp**
*   **Given** (Cho rằng) tôi đang thêm sách mới
*   **When** (Khi) tôi nhập ISBN đã tồn tại trong hệ thống
*   **And** (Và) tôi nhấn "Lưu sách"
*   **Then** (Thì) hệ thống hiển thị lỗi: "ISBN này đã tồn tại trong hệ thống"
*   **And** (Và) form không được submit
*   **And** (Và) trường ISBN được highlight màu đỏ

**Kịch bản 3: Chỉnh sửa thông tin sách**
*   **Given** (Cho rằng) tôi đang xem chi tiết một cuốn sách
*   **When** (Khi) tôi nhấn "Chỉnh sửa" và thay đổi số lượng từ 3 thành 5
*   **And** (Và) tôi nhấn "Cập nhật"
*   **Then** (Thì) thông tin sách được cập nhật
*   **And** (Và) số lượng có sẵn tăng thêm 2 (nếu không có sách nào đang được mượn)
*   **And** (Và) hệ thống ghi log thay đổi với timestamp và người thực hiện

**Kịch bản 4: Không thể xóa sách đang được mượn**
*   **Given** (Cho rằng) một cuốn sách đang có người mượn hoặc đặt chỗ
*   **When** (Khi) tôi cố gắng xóa sách đó
*   **Then** (Thì) hệ thống hiển thị cảnh báo: "Không thể xóa sách đang được mượn hoặc đã được đặt chỗ"
*   **And** (Và) nút "Xóa" bị vô hiệu hóa
*   **And** (Và) hiển thị danh sách người đang mượn/đặt chỗ

---

### **User Story 6: Xem báo cáo thống kê thư viện**

*   **As a** (Với vai trò là) một quản lý thư viện,
*   **I want to** (tôi muốn) xem các báo cáo thống kê về hoạt động thư viện
*   **So that** (để) tôi có thể đưa ra quyết định quản lý và mua sắm sách hiệu quả.
*   **Độ ưu tiên**: Trung bình
*   **Ghi chú**: Story này hỗ trợ việc ra quyết định chiến lược cho thư viện.

#### **Tiêu chí nghiệm thu (Acceptance Criteria)**

**Kịch bản 1: Xem báo cáo sách phổ biến**
*   **Given** (Cho rằng) tôi đăng nhập với quyền quản lý
*   **When** (Khi) tôi truy cập trang "Báo cáo" và chọn "Sách được mượn nhiều nhất"
*   **Then** (Thì) hệ thống hiển thị top 20 sách có số lượt mượn cao nhất trong 3 tháng gần đây
*   **And** (Và) mỗi sách hiển thị: tên, tác giả, số lần mượn, thời gian mượn trung bình
*   **And** (Và) có biểu đồ visualization cho dữ liệu

**Kịch bản 2: Báo cáo người dùng hoạt động**
*   **Given** (Cho rằng) tôi đang xem báo cáo
*   **When** (Khi) tôi chọn "Thống kê người dùng" với khoảng thời gian "Tháng này"
*   **Then** (Thì) hiển thị: tổng số người dùng đăng ký mới, số lượt mượn, số người dùng hoạt động
*   **And** (Và) so sánh với tháng trước (tăng/giảm bao nhiêu %)
*   **And** (Và) breakdown theo loại thành viên (sinh viên, giảng viên, độc giả ngoài)

**Kịch bản 3: Báo cáo tài chính từ phạt**
*   **Given** (Cho rằng) tôi cần xem tình hình thu phạt
*   **When** (Khi) tôi chọn báo cáo "Phạt và thu nhập" với quý này
*   **Then** (Thì) hiển thị: tổng số tiền phạt phát sinh, đã thu, chưa thu
*   **And** (Và) phân loại theo loại phạt: trả muộn, hư hỏng, mất sách
*   **And** (Và) danh sách các khoản phạt lớn chưa thanh toán

---

### **User Story 7: Nhận thông báo và nhắc nhở**

*   **As a** (Với vai trò là) một người dùng đang mượn sách,
*   **I want to** (tôi muốn) nhận thông báo về tình trạng sách tôi mượn
*   **So that** (để) tôi không bỏ lỡ ngày trả và tránh bị phạt.
*   **Độ ưu tiên**: Trung bình
*   **Ghi chú**: Story này giúp cải thiện trải nghiệm người dùng và giảm phạt.

#### **Tiêu chí nghiệm thu (Acceptance Criteria)**

**Kịch bản 1: Nhắc nhở trước 3 ngày hết hạn**
*   **Given** (Cho rằng) tôi có sách sẽ hết hạn sau 3 ngày
*   **When** (Khi) hệ thống chạy job nhắc nhở hàng ngày
*   **Then** (Thì) tôi nhận được email với tiêu đề: "Nhắc nhở: Sách sắp hết hạn trong 3 ngày"
*   **And** (Và) email chứa: tên sách, ngày hết hạn, liên kết gia hạn (nếu được phép)
*   **And** (Và) tôi cũng nhận thông báo trong app nếu đã cài đặt

**Kịch bản 2: Nhắc nhở trước 1 ngày hết hạn**
*   **Given** (Cho rằng) tôi có sách hết hạn vào ngày mai
*   **When** (Khi) hệ thống gửi nhắc nhở khẩn cấp
*   **Then** (Thì) tôi nhận email với tiêu đề: "KHẨN CẤP: Sách hết hạn vào ngày mai"
*   **And** (Và) email có tone nghiêm túc hơn và highlight ngày hết hạn
*   **And** (Và) có thông tin về mức phạt nếu trả muộn

**Kịch bản 3: Thông báo sách quá hạn**
*   **Given** (Cho rằng) tôi có sách đã quá hạn 1 ngày
*   **When** (Khi) hệ thống phát hiện sách quá hạn
*   **Then** (Thì) tôi nhận email: "Sách của bạn đã quá hạn - Vui lòng trả ngay"
*   **And** (Và) email thông báo số tiền phạt hiện tại: "Phạt hiện tại: 2,000 VND"
*   **And** (Và) mỗi ngày sau đó, phạt sẽ tăng thêm 2,000 VND

**Kịch bản 4: Thông báo đặt chỗ thành công**
*   **Given** (Cho rằng) tôi vừa đặt chỗ một cuốn sách
*   **When** (Khi) việc đặt chỗ được xử lý thành công
*   **Then** (Thì) tôi nhận email xác nhận ngay lập tức
*   **And** (Và) email chứa: tên sách, vị trí trong hàng đợi, thời gian ước tính
*   **And** (Và) hướng dẫn cách hủy đặt chỗ nếu không cần nữa

---

### **Performance & Quality Stories**

### **User Story 8: Tìm kiếm nhanh với cơ sở dữ liệu lớn**

*   **As a** (Với vai trò là) bất kỳ người dùng nào,
*   **I want to** (tôi muốn) kết quả tìm kiếm hiển thị nhanh chóng
*   **So that** (để) tôi không phải chờ đợi lâu và có trải nghiệm mượt mà.
*   **Độ ưu tiên**: Cao
*   **Ghi chú**: Đây là yêu cầu phi chức năng được chuyển thành user story.

#### **Tiêu chí nghiệm thu (Acceptance Criteria)**

**Kịch bản 1: Tìm kiếm nhanh với 10,000+ sách**
*   **Given** (Cho rằng) hệ thống có hơn 10,000 đầu sách trong cơ sở dữ liệu
*   **When** (Khi) tôi thực hiện bất kỳ tìm kiếm nào
*   **Then** (Thì) kết quả phải hiển thị trong vòng 2 giây
*   **And** (Và) trang web không bị "đơ" trong quá trình tìm kiếm
*   **And** (Và) có loading indicator để người dùng biết hệ thống đang xử lý

**Kịch bản 2: Xử lý tải cao 500 người dùng đồng thời**
*   **Given** (Cho rằng) có 500 người dùng đang sử dụng hệ thống cùng lúc
*   **When** (Khi) tôi thực hiện các thao tác như tìm kiếm, mượn sách, đặt chỗ
*   **Then** (Thì) hiệu năng không bị ảnh hưởng đáng kể
*   **And** (Và) thời gian phản hồi vẫn dưới 3 giây cho các thao tác cơ bản
*   **And** (Và) hệ thống không bị crash hoặc timeout

---

### **Acceptance Criteria Summary**

#### **Định nghĩa "Done" cho Epic Quản lý Thư viện Số:**

1. **Functional Completeness**: Tất cả user stories được implement và pass acceptance criteria
2. **Performance**: Tìm kiếm < 2s với 10K+ sách, hỗ trợ 500 concurrent users
3. **Security**: Phân quyền đúng, audit log đầy đủ, bảo mật dữ liệu cá nhân
4. **Usability**: Giao diện responsive, đa ngôn ngữ, accessibility compliant
5. **Reliability**: Uptime 99.9%, backup hàng ngày, recovery < 4 giờ
6. **Integration**: Hoạt động mượt mà với hệ thống Authentication hiện có
7. **Documentation**: User guide, admin manual, API documentation
8. **Testing**: Unit tests, integration tests, performance tests pass
9. **Deployment**: CI/CD pipeline hoạt động, staging environment validated