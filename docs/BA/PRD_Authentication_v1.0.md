# Lean PRD: Tính năng Xác thực người dùng (Authentication)

Tài liệu này mô tả chi tiết sản phẩm, chân dung người dùng, các luồng tính năng và tiêu chí nghiệm thu cho tính năng Xác thực.

## 1. Mục tiêu & Chỉ số (Goals & Metrics)

*   **Mục tiêu 1**: **Tăng tỷ lệ giữ chân người dùng (User Retention)** bằng cách cho phép họ tạo và khôi phục tài khoản để lưu trữ dữ liệu cá nhân.
    *   **Chỉ số chính**: Tăng tỷ lệ người dùng quay lại sau 7 ngày lên 15%.
    *   **Chỉ số phụ**: Tỷ lệ đăng ký tài khoản mới đạt 500 tài khoản/tuần.
*   **Mục tiêu 2**: **Nâng cao bảo mật và tin cậy** cho nền tảng.
    *   **Chỉ số chính**: Đạt 0 lỗ hổng bảo mật nghiêm trọng (critical) liên quan đến xác thực trong các đợt kiểm thử.
    *   **Chỉ số phụ**: Thời gian phản hồi của API xác thực luôn dưới 1,5 giây ở mức 95th percentile.

## 2. Chân dung người dùng (Personas)

*   **Persona 1: An - Người dùng khám phá**
    *   **Tiểu sử**: 25 tuổi, nhân viên văn phòng, am hiểu công nghệ. An nghe bạn bè giới thiệu về ứng dụng và muốn dùng thử.
    *   **Mục tiêu**: Đăng ký một tài khoản nhanh nhất có thể để khám phá các tính năng chính.
    *   **Trở ngại**: Ghét các biểu mẫu đăng ký dài dòng, phức tạp và yêu cầu quá nhiều thông tin cá nhân không cần thiết.

*   **Persona 2: Bình - Người dùng trung thành**
    *   **Tiểu sử**: 35 tuổi, quản lý dự án, sử dụng ứng dụng hàng ngày cho công việc.
    *   **Mục tiêu**: Đăng nhập nhanh chóng và an toàn để tiếp tục công việc đang dang dở.
    *   **Trở ngại**: Lo lắng về việc tài khoản bị xâm nhập. Cảm thấy bất tiện nếu quá trình đăng nhập có quá nhiều bước không cần thiết.

*   **Persona 3: Chi - Người dùng đãng trí**
    *   **Tiểu sử**: 40 tuổi, sử dụng nhiều ứng dụng khác nhau và không thể nhớ hết tất cả mật khẩu.
    *   **Mục tiêu**: Lấy lại quyền truy cập vào tài khoản một cách dễ dàng khi quên mật khẩu.
    *   **Trở ngại**: Sợ các quy trình khôi phục phức tạp, đòi hỏi nhiều thông tin hoặc mất thời gian.

## 3. Tổng quan tính năng (Feature Overview)

*   **Đăng ký tài khoản**: Người dùng có thể tạo tài khoản mới bằng email và mật khẩu. Hệ thống sẽ kiểm tra tính hợp lệ của email và độ phức tạp của mật khẩu.
*   **Đăng nhập tài khoản**: Người dùng đã có tài khoản có thể truy cập hệ thống. Hệ thống sẽ khóa tài khoản tạm thời sau 5 lần đăng nhập thất bại liên tiếp.
*   **Đặt lại mật khẩu**: Người dùng đã quên mật khẩu có thể yêu cầu một liên kết đặt lại mật khẩu gửi đến email của họ. Liên kết này sẽ có hiệu lực trong một khoảng thời gian giới hạn.
*   **Đăng xuất tài khoản**: Người dùng có thể đăng xuất khỏi thiết bị hiện tại, hành động này sẽ hủy phiên làm việc.

## 4. Luồng người dùng (User Flows)

### 4.1. Luồng đăng ký thành công
1.  Người dùng truy cập trang chủ và nhấn nút "Đăng ký".
2.  Hệ thống hiển thị trang đăng ký với các trường: Email, Mật khẩu, Xác nhận mật khẩu.
3.  Người dùng nhập thông tin hợp lệ (email chưa tồn tại, mật khẩu đủ mạnh và trùng khớp).
4.  Người dùng nhấn nút "Tạo tài khoản".
5.  Hệ thống xác thực dữ liệu đầu vào.
6.  Hệ thống tạo tài khoản mới trong cơ sở dữ liệu.
7.  Hệ thống tự động đăng nhập cho người dùng.
8.  Hệ thống chuyển hướng người dùng đến trang "Chào mừng" hoặc "Bảng điều khiển".

### 4.2. Luồng đăng nhập thành công
1.  Người dùng truy cập trang chủ và nhấn nút "Đăng nhập".
2.  Hệ thống hiển thị trang đăng nhập với các trường: Email, Mật khẩu.
3.  Người dùng nhập email và mật khẩu chính xác.
4.  Người dùng nhấn nút "Đăng nhập".
5.  Hệ thống xác thực thông tin đăng nhập.
6.  Hệ thống tạo một phiên làm việc mới.
7.  Hệ thống chuyển hướng người dùng đến trang làm việc chính của họ.

### 4.3. Luồng Đặt lại mật khẩu
1.  Từ trang "Đăng nhập", người dùng nhấn vào liên kết "Quên mật khẩu?".
2.  Hệ thống hiển thị trang "Đặt lại mật khẩu", yêu cầu người dùng nhập địa chỉ email của họ.
3.  Người dùng nhập email đã đăng ký và nhấn "Gửi yêu cầu".
4.  Hệ thống xác thực email có tồn tại. Nếu có, hệ thống tạo một mã token đặt lại mật khẩu duy nhất, lưu nó vào cơ sở dữ liệu và gửi một email chứa liên kết đặt lại mật khẩu đến người dùng.
5.  Người dùng mở email và nhấp vào liên kết.
6.  Hệ thống chuyển người dùng đến trang "Tạo mật khẩu mới", yêu cầu nhập `Mật khẩu mới` và `Xác nhận mật khẩu mới`.
7.  Người dùng nhập mật khẩu mới hợp lệ và nhấn "Cập nhật mật khẩu".
8.  Hệ thống xác thực token, kiểm tra hiệu lực và cập nhật mật khẩu mới cho người dùng.
9.  Hệ thống hiển thị thông báo thành công và chuyển hướng người dùng đến trang "Đăng nhập".

## 5. Tiêu chí nghiệm thu cấp cao (High-level Acceptance Criteria)

*   Người dùng có thể tạo một tài khoản mới bằng email và mật khẩu hợp lệ.
*   Người dùng có thể đăng nhập bằng tài khoản đã được tạo thành công.
*   **Người dùng có thể yêu cầu đặt lại mật khẩu và nhận được email chứa liên kết.**
*   **Người dùng có thể sử dụng liên kết hợp lệ để đặt một mật khẩu mới thành công.**
*   **Liên kết đặt lại mật khẩu phải hết hạn sau một khoảng thời gian nhất định.**
*   Hệ thống phải trả về thông báo lỗi rõ ràng khi người dùng nhập sai thông tin đăng nhập.
*   Sau khi đăng nhập, người dùng có thể thực hiện chức năng đăng xuất để kết thúc phiên làm việc.

## 6. Giả định & Ràng buộc (Assumptions & Constraints)

*   **Giả định (Assumptions)**:
    *   Người dùng có quyền truy cập vào địa chỉ email mà họ sử dụng để đăng ký.
    *   Dịch vụ gửi email của bên thứ ba (ví dụ: SendGrid, Mailgun) hoạt động ổn định.
*   **Ràng buộc (Constraints)**:
    *   **Kỹ thuật**:
        *   Mật khẩu phải được băm bằng thuật toán `Bcrypt`.
        *   Token đặt lại mật khẩu phải là duy nhất, ngẫu nhiên và có thời gian hết hạn (ví dụ: 1 giờ).
    *   **Sản phẩm**:
        *   Không hỗ trợ đăng nhập qua mạng xã hội.
    *   **Giao diện người dùng (UI)**:
        *   Giao diện phải tuân thủ theo bộ nhận diện thương hiệu đã có.
        *   Thiết kế phải có tính đáp ứng (responsive). 