# User Stories & Acceptance Criteria: Tính năng Xác thực

Tài liệu này chuyển đổi các yêu cầu thành các User Story có thể thực thi, tập trung vào giá trị mang lại cho người dùng cuối. Mỗi story đi kèm với các tiêu chí nghiệm thu chi tiết để kiểm thử.

---

### **Epic: Quản lý Tài khoản Người dùng**

---

### **User Story 1: Đăng ký tài khoản**

*   **As a** (Với vai trò là) một người dùng mới,
*   **I want to** (tôi muốn) tạo một tài khoản an toàn bằng email và mật khẩu
*   **So that** (để) tôi có thể truy cập vào các tính năng cá nhân hóa của ứng dụng.
*   **Độ ưu tiên**: Cao nhất
*   **Ghi chú**: Story này liên quan đến các yêu cầu `FR-REG-01` đến `FR-REG-09`.

#### **Tiêu chí nghiệm thu (Acceptance Criteria)**

**Kịch bản 1: Đăng ký thành công với dữ liệu hợp lệ**
*   **Given** (Cho rằng) tôi là người dùng chưa có tài khoản và đang ở trang "Đăng ký"
*   **When** (Khi) tôi nhập một địa chỉ email hợp lệ chưa tồn tại trong hệ thống
*   **And** (Và) tôi nhập một mật khẩu dài 8 ký tự, có chữ hoa, chữ thường và số
*   **And** (Và) tôi nhập lại mật khẩu đó vào trường "Xác nhận mật khẩu"
*   **And** (Và) tôi nhấn nút "Tạo tài khoản"
*   **Then** (Thì) hệ thống tạo tài khoản thành công
*   **And** (Và) tôi được tự động đăng nhập và chuyển hướng đến trang "Bảng điều khiển"
*   **And** (Và) tôi thấy một thông báo chào mừng: `Chào mừng bạn đến với ứng dụng!`

**Kịch bản 2: Đăng ký thất bại do email đã tồn tại**
*   **Given** (Cho rằng) tôi đang ở trang "Đăng ký"
*   **When** (Khi) tôi nhập một địa chỉ email đã được đăng ký trước đó
*   **And** (Và) tôi điền các trường mật khẩu
*   **And** (Và) tôi nhấn nút "Tạo tài khoản"
*   **Then** (Thì) tài khoản không được tạo
*   **And** (Và) tôi vẫn ở lại trang "Đăng ký"
*   **And** (Và) tôi thấy thông báo lỗi bên dưới trường email: `Email này đã được sử dụng.`

**Kịch bản 3: Đăng ký thất bại do mật khẩu không đủ mạnh**
*   **Given** (Cho rằng) tôi đang ở trang "Đăng ký"
*   **When** (Khi) tôi nhập mật khẩu `12345` (không đủ tiêu chuẩn)
*   **And** (Và) tôi nhấn nút "Tạo tài khoản"
*   **Then** (Thì) tài khoản không được tạo
*   **And** (Và) tôi thấy thông báo lỗi: `Mật khẩu phải dài ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường và số.`

**Kịch bản 4: Đăng ký thất bại do mật khẩu xác nhận không khớp**
*   **Given** (Cho rằng) tôi đang ở trang "Đăng ký"
*   **When** (Khi) tôi nhập mật khẩu là `Password123`
*   **And** (Và) tôi nhập mật khẩu xác nhận là `Password456`
*   **And** (Và) tôi nhấn nút "Tạo tài khoản"
*   **Then** (Thì) tài khoản không được tạo
*   **And** (Và) tôi thấy thông báo lỗi bên dưới trường xác nhận mật khẩu: `Mật khẩu xác nhận không khớp.`

---

### **User Story 2: Đăng nhập vào hệ thống**

*   **As a** (Với vai trò là) một người dùng đã có tài khoản,
*   **I want to** (tôi muốn) đăng nhập một cách an toàn
*   **So that** (để) tôi có thể tiếp tục sử dụng các tính năng của ứng dụng.
*   **Độ ưu tiên**: Cao nhất
*   **Ghi chú**: Story này liên quan đến các yêu cầu `FR-LOG-01` đến `FR-LOG-07`.

#### **Tiêu chí nghiệm thu (Acceptance Criteria)**

**Kịch bản 1: Đăng nhập thành công**
*   **Given** (Cho rằng) tôi là người dùng đã có tài khoản và đang ở trang "Đăng nhập"
*   **When** (Khi) tôi nhập đúng email và mật khẩu của mình
*   **And** (Và) tôi nhấn nút "Đăng nhập"
*   **Then** (Thì) tôi được xác thực thành công
*   **And** (Và) tôi được chuyển hướng đến "Bảng điều khiển" của mình.

**Kịch bản 2: Đăng nhập thất bại do thông tin sai**
*   **Given** (Cho rằng) tôi đang ở trang "Đăng nhập"
*   **When** (Khi) tôi nhập email đúng nhưng mật khẩu sai
*   **And** (Và) tôi nhấn nút "Đăng nhập"
*   **Then** (Thì) tôi không thể đăng nhập
*   **And** (Và) tôi thấy thông báo lỗi: `Email hoặc mật khẩu không chính xác.`

**Kịch bản 3: Tài khoản bị khóa tạm thời do đăng nhập sai nhiều lần**
*   **Given** (Cho rằng) tôi là người dùng đã có tài khoản
*   **When** (Khi) tôi cố gắng đăng nhập và nhập sai mật khẩu 5 lần liên tiếp
*   **Then** (Thì) ở lần thử thứ 6, tôi thấy thông báo: `Tài khoản của bạn đã bị tạm khóa. Vui lòng thử lại sau 15 phút.`
*   **And** (Và) tôi không thể đăng nhập ngay cả khi nhập đúng thông tin trong vòng 15 phút tới.

---

### **User Story 3: Đặt lại mật khẩu đã quên**

*   **As a** (Với vai trò là) một người dùng đã quên mật khẩu,
*   **I want to** (tôi muốn) yêu cầu một liên kết để đặt lại mật khẩu của mình một cách an toàn
*   **So that** (để) tôi có thể lấy lại quyền truy cập vào tài khoản.
*   **Độ ưu tiên**: Cao
*   **Ghi chú**: Story này liên quan đến các yêu cầu `FR-RP-01` đến `FR-RP-12`.

#### **Tiêu chí nghiệm thu (Acceptance Criteria)**

**Kịch bản 1: Yêu cầu đặt lại mật khẩu thành công**
*   **Given** (Cho rằng) tôi đang ở trang "Đăng nhập"
*   **When** (Khi) tôi nhấn vào liên kết "Quên mật khẩu?"
*   **And** (Và) tôi nhập địa chỉ email đã đăng ký của mình và nhấn "Gửi yêu cầu"
*   **Then** (Thì) tôi thấy một thông báo: `Nếu email của bạn tồn tại trong hệ thống, bạn sẽ nhận được một liên kết để đặt lại mật khẩu.`
*   **And** (Và) tôi nhận được một email chứa một liên kết duy nhất để đặt lại mật khẩu.

**Kịch bản 2: Đặt lại mật khẩu thành công với liên kết hợp lệ**
*   **Given** (Cho rằng) tôi đã nhận được email đặt lại mật khẩu
*   **When** (Khi) tôi nhấn vào liên kết trong email trong vòng 60 phút
*   **Then** (Thì) tôi được chuyển đến trang "Tạo mật khẩu mới"
*   **When** (Khi) tôi nhập một mật khẩu mới hợp lệ vào cả hai trường `Mật khẩu mới` và `Xác nhận mật khẩu mới`
*   **And** (Và) tôi nhấn "Cập nhật mật khẩu"
*   **Then** (Thì) tôi được chuyển hướng đến trang "Đăng nhập"
*   **And** (Và) tôi thấy một thông báo thành công: `Đặt lại mật khẩu thành công!`
*   **And** (Và) tôi có thể đăng nhập bằng mật khẩu mới của mình.

**Kịch bản 3: Sử dụng liên kết đặt lại mật khẩu đã hết hạn**
*   **Given** (Cho rằng) tôi đã nhận được email đặt lại mật khẩu
*   **When** (Khi) tôi nhấn vào liên kết sau 60 phút
*   **Then** (Thì) tôi được chuyển đến một trang lỗi
*   **And** (Và) tôi thấy thông báo: `Liên kết đặt lại mật khẩu không hợp lệ hoặc đã hết hạn. Vui lòng thử lại.`

**Kịch bản 4: Liên kết đã được sử dụng một lần**
*   **Given** (Cho rằng) tôi đã sử dụng thành công một liên kết để đặt lại mật khẩu
*   **When** (Khi) tôi cố gắng truy cập lại chính liên kết đó
*   **Then** (Thì) tôi sẽ thấy thông báo lỗi tương tự như khi liên kết hết hạn.

---

### **User Story 4: Đăng xuất khỏi hệ thống**

*   **As a** (Với vai trò là) một người dùng đã đăng nhập,
*   **I want to** (tôi muốn) đăng xuất khỏi tài khoản của mình
*   **So that** (để) tôi có thể bảo vệ tài khoản của mình trên các thiết bị dùng chung.
*   **Độ ưu tiên**: Cao
*   **Ghi chú**: Story này liên quan đến các yêu cầu `FR-OUT-01` đến `FR-OUT-03`.

#### **Tiêu chí nghiệm thu (Acceptance Criteria)**

**Kịch bản 1: Đăng xuất thành công**
*   **Given** (Cho rằng) tôi đã đăng nhập vào hệ thống
*   **When** (Khi) tôi nhấn vào nút "Đăng xuất" trên thanh điều hướng
*   **Then** (Thì) phiên làm việc của tôi kết thúc
*   **And** (Và) tôi được chuyển hướng về trang chủ.
*   **And** (Và) nếu tôi cố gắng truy cập lại trang "Bảng điều khiển", tôi sẽ được yêu cầu đăng nhập. 