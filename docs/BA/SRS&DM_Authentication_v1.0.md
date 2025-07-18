# Lean SRS & Domain Model: Tính năng Xác thực

Tài liệu này đặc tả chi tiết các yêu cầu kỹ thuật, yêu cầu chức năng, phi chức năng, và mô hình dữ liệu cho tính năng Xác thực.

## 1. Yêu cầu chức năng (Functional Requirements)

### 1.1. Đăng ký tài khoản (FR-REG)

| ID          | Mô tả yêu cầu                                                                                                    |
|-------------|------------------------------------------------------------------------------------------------------------------|
| **FR-REG-01** | Hệ thống **PHẢI** cung cấp một trang/giao diện cho phép người dùng thực hiện việc đăng ký tài khoản mới.              |
| **FR-REG-02** | Biểu mẫu đăng ký **PHẢI** chứa các trường sau: `Email`, `Mật khẩu` (Password), `Xác nhận Mật khẩu` (Confirm Password). |
| **FR-REG-03** | Hệ thống **PHẢI** kiểm tra tính hợp lệ của địa chỉ email theo chuẩn RFC 5322.                                         |
| **FR-REG-04** | Hệ thống **PHẢI** kiểm tra email đăng ký có tồn tại trong cơ sở dữ liệu hay không. Nếu đã tồn tại, hệ thống **PHẢI** hiển thị thông báo lỗi: `Email này đã được sử dụng.` và không tạo tài khoản. |
| **FR-REG-05** | Hệ thống **PHẢI** yêu cầu mật khẩu có độ phức tạp tối thiểu: ít nhất 8 ký tự, chứa ít nhất 1 chữ hoa, 1 chữ thường, và 1 chữ số. |
| **FR-REG-06** | Hệ thống **PHẢI** hiển thị các yêu cầu về độ phức tạp của mật khẩu một cách rõ ràng cho người dùng ngay trên giao diện. |
| **FR-REG-07** | Hệ thống **PHẢI** kiểm tra giá trị của trường `Mật khẩu` và `Xác nhận Mật khẩu` phải trùng khớp. Nếu không, hệ thống **PHẢI** hiển thị thông báo lỗi: `Mật khẩu xác nhận không khớp.` |
| **FR-REG-08** | Sau khi người dùng nhấn nút "Đăng ký" và tất cả dữ liệu hợp lệ, hệ thống **PHẢI** tạo một bản ghi người dùng mới trong cơ sở dữ liệu. |
| **FR-REG-09** | Sau khi tạo tài khoản thành công, hệ thống **PHẢI** tự động đăng nhập cho người dùng và chuyển hướng họ đến trang chính. |

### 1.2. Đăng nhập (FR-LOG)

| ID          | Mô tả yêu cầu                                                                                                                                |
|-------------|----------------------------------------------------------------------------------------------------------------------------------------------|
| **FR-LOG-01** | Hệ thống **PHẢI** cung cấp một trang/giao diện cho phép người dùng đăng nhập.                                                                 |
| **FR-LOG-02** | Biểu mẫu đăng nhập **PHẢI** chứa các trường sau: `Email` và `Mật khẩu`.                                                                      |
| **FR-LOG-03** | Khi người dùng nhập đúng email và mật khẩu, hệ thống **PHẢI** xác thực thành công và tạo một phiên làm việc (session) cho người dùng.           |
| **FR-LOG-04** | Khi người dùng nhập sai email hoặc mật khẩu, hệ thống **PHẢI** hiển thị một thông báo lỗi chung: `Email hoặc mật khẩu không chính xác.`          |
| **FR-LOG-05** | Hệ thống **PHẢI** đếm số lần đăng nhập thất bại liên tiếp cho một tài khoản.                                                                 |
| **FR-LOG-06** | Nếu một tài khoản đăng nhập thất bại 5 lần liên tiếp trong vòng 15 phút, hệ thống **PHẢI** tạm thời khóa tài khoản đó trong 15 phút.            |
| **FR-LOG-07** | Khi tài khoản bị khóa, nếu người dùng cố gắng đăng nhập, hệ thống **PHẢI** hiển thị thông báo: `Tài khoản của bạn đã bị tạm khóa. Vui lòng thử lại sau 15 phút.` |

### 1.3. Đặt lại mật khẩu (FR-RP)

| ID          | Mô tả yêu cầu                                                                                                                                                             |
|-------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **FR-RP-01**  | Hệ thống **PHẢI** cung cấp một liên kết "Quên mật khẩu?" trên trang Đăng nhập.                                                                                            |
| **FR-RP-02**  | Khi nhấn vào "Quên mật khẩu?", hệ thống **PHẢI** điều hướng người dùng đến trang yêu cầu đặt lại mật khẩu, chỉ yêu cầu nhập `Email`.                                         |
| **FR-RP-03**  | Khi người dùng gửi yêu cầu với một email, hệ thống **PHẢI** kiểm tra xem email đó có tồn tại trong CSDL hay không.                                                          |
| **FR-RP-04**  | Nếu email không tồn tại, hệ thống **PHẢI** hiển thị một thông báo chung: `Nếu email của bạn tồn tại trong hệ thống, bạn sẽ nhận được một liên kết để đặt lại mật khẩu.`     |
| **FR-RP-05**  | Nếu email tồn tại, hệ thống **PHẢI** tạo một token đặt lại mật khẩu duy nhất, an toàn và có thời gian hết hạn.                                                             |
| **FR-RP-06**  | Hệ thống **PHẢI** lưu trữ token đã băm (hashed token) và thời gian hết hạn của nó, liên kết với tài khoản người dùng tương ứng.                                             |
| **FR-RP-07**  | Hệ thống **PHẢI** gửi một email đến địa chỉ của người dùng, chứa một liên kết duy nhất để đặt lại mật khẩu. Nội dung email phải rõ ràng và chuyên nghiệp.                     |
| **FR-RP-08**  | Khi người dùng truy cập liên kết, hệ thống **PHẢI** xác thực token. Nếu token không hợp lệ hoặc đã hết hạn, hệ thống **PHẢI** hiển thị thông báo lỗi: `Liên kết đặt lại mật khẩu không hợp lệ hoặc đã hết hạn.` |
| **FR-RP-09**  | Nếu token hợp lệ, hệ thống **PHẢI** hiển thị một biểu mẫu cho phép người dùng nhập `Mật khẩu mới` và `Xác nhận mật khẩu mới`.                                             |
| **FR-RP-10**  | Mật khẩu mới **PHẢI** tuân thủ các quy tắc về độ phức tạp giống như khi đăng ký (Yêu cầu FR-REG-05).                                                                        |
| **FR-RP-11**  | Sau khi người dùng cập nhật mật khẩu mới thành công, hệ thống **PHẢI** cập nhật mật khẩu đã băm trong CSDL và vô hiệu hóa token đặt lại mật khẩu đã sử dụng.                |
| **FR-RP-12**  | Hệ thống **PHẢI** hiển thị thông báo `Đặt lại mật khẩu thành công!` và điều hướng người dùng đến trang Đăng nhập.                                                          |


### 1.4. Đăng xuất (FR-OUT)

| ID          | Mô tả yêu cầu                                                                                        |
|-------------|------------------------------------------------------------------------------------------------------|
| **FR-OUT-01** | Hệ thống **PHẢI** cung cấp một nút hoặc liên kết "Đăng xuất" ở vị trí dễ thấy cho người dùng đã đăng nhập. |
| **FR-OUT-02** | Khi người dùng nhấn "Đăng xuất", hệ thống **PHẢI** hủy phiên làm việc hiện tại của người dùng.              |
| **FR-OUT-03** | Sau khi đăng xuất, hệ thống **PHẢI** chuyển hướng người dùng về trang chủ hoặc trang đăng nhập.          |

## 2. Yêu cầu phi chức năng (Non-Functional Requirements)

| ID           | Thể loại      | Mô tả yêu cầu                                                                                                                            |
|--------------|---------------|------------------------------------------------------------------------------------------------------------------------------------------|
| **NFR-SEC-01** | **Bảo mật**   | Mật khẩu người dùng **PHẢI** được băm (hash) bằng thuật toán `Bcrypt` với chi phí (cost factor) tối thiểu là 12.                             |
| **NFR-SEC-02** | **Bảo mật**   | Dữ liệu xác thực (session/reset token) **PHẢI** được truyền qua kênh mã hóa `HTTPS (TLS 1.2+).`                                           |
| **NFR-SEC-03** | **Bảo mật**   | Phiên làm việc của người dùng (session token) **PHẢI** tự động hết hạn sau 24 giờ không hoạt động.                                         |
| **NFR-SEC-04** | **Bảo mật**   | Token đặt lại mật khẩu **PHẢI** hết hạn trong vòng 60 phút sau khi được tạo.                                                               |
| **NFR-PER-01** | **Hiệu năng** | Các API xác thực (login, register, reset password) **PHẢI** có thời gian phản hồi phía máy chủ dưới 800ms ở mức 95th percentile.          |
| **NFR-USA-01** | **Khả dụng**  | Các dịch vụ xác thực và gửi email **PHẢI** đạt độ sẵn sàng `99.9%` (uptime).                                                                 |
| **NFR-SCA-01** | **Khả năng mở rộng** | Hệ thống xác thực **PHẢI** có khả năng phục vụ đồng thời 1,000 yêu cầu/giây mà không làm tăng thời gian phản hồi quá 20%.         |

## 3. Mô hình miền & Thuật ngữ (Domain Model & Glossary)

Phần này định nghĩa các khái niệm và thuật ngữ cốt lõi trong miền nghiệp vụ Xác thực, nhằm mục đích tạo ra một "Ngôn ngữ chung" (Ubiquitous Language) cho cả đội ngũ kinh doanh và kỹ thuật.

### 3.1. User Account (Tài khoản Người dùng)

*   **Định nghĩa**: Là một thực thể đại diện cho danh tính số (digital identity) của một người dùng trong hệ thống. Mỗi tài khoản cho phép một cá nhân được định danh, truy cập các tính năng và dữ liệu được cá nhân hóa sau khi xác thực thành công.
*   **Thuộc tính (Attributes)**:
    *   `Email Address`: Địa chỉ email, đóng vai trò là định danh viên (identifier) duy nhất cho mỗi tài khoản trong toàn hệ thống. Nó cũng được dùng làm kênh liên lạc chính (ví dụ: gửi thông báo, đặt lại mật khẩu).
    *   `Password`: Một chuỗi ký tự bí mật do người dùng thiết lập, được dùng làm yếu tố xác thực chính để chứng minh quyền sở hữu tài khoản.
    *   `Account Status`: Trạng thái hiện tại của tài khoản, quyết định khả năng truy cập của người dùng. Các trạng thái bao gồm:
        *   `Active`: Tài khoản đang hoạt động bình thường.
        *   `Locked`: Tài khoản bị tạm thời khóa, không thể đăng nhập do các hoạt động đáng ngờ (ví dụ: nhập sai mật khẩu nhiều lần).
        *   `Inactive`: Tài khoản chưa được kích hoạt hoặc đã bị vô hiệu hóa.

### 3.2. Session (Phiên làm việc)

*   **Định nghĩa**: Đại diện cho một khoảng thời gian tương tác liên tục và được xác thực của người dùng với ứng dụng. Một phiên làm việc bắt đầu khi người dùng đăng nhập thành công và kết thúc khi họ đăng xuất hoặc hết thời gian chờ.
*   **Thuộc tính**:
    *   `Associated User Account`: Tài khoản người dùng mà phiên làm việc này thuộc về.
    *   `Start Time`: Thời điểm phiên làm việc bắt đầu.
    *   `Expiration Time`: Thời điểm phiên làm việc sẽ tự động hết hiệu lực nếu không có hoạt động nào.

### 3.3. Password Reset Token (Mã đặt lại mật khẩu)

*   **Định nghĩa**: Là một mã thông báo (token) dùng một lần, có giới hạn thời gian, được tạo ra một cách an toàn khi người dùng yêu cầu quy trình đặt lại mật khẩu. Nó hoạt động như một chiếc chìa khóa tạm thời để cho phép thay đổi mật khẩu mà không cần đăng nhập.
*   **Thuộc tính**:
    *   `Associated User Account`: Tài khoản người dùng mà mã này được cấp cho.
    *   `Expiration Time`: Thời điểm mã thông báo hết hiệu lực (ví dụ: 60 phút sau khi được tạo).
    *   `Status`: Trạng thái của mã, cho biết nó có thể được sử dụng hay không. Các trạng thái bao gồm: `Valid` (Hợp lệ), `Used` (Đã sử dụng), `Expired` (Hết hạn). 