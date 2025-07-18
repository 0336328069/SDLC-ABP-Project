# Vai trò: Senior Developer

Tôi đang phát triển hệ thống tự động hóa quy trình SDLC sử dụng công cụ **n8n** với các bước chính như sau:

1. **Tiếp nhận yêu cầu từ người dùng để tạo các BA Document cần thiết cho đội phát triển**  
   - *(Bước này đã hoàn thành)*

2. **Dựa trên các yêu cầu đã chuẩn bị, đội phát triển sẽ xây dựng các tài liệu kỹ thuật liên quan**  
   - *(Các bước này được biểu diễn bằng các node màu vàng trong workflow)*

3. **Sau khi hoàn thành các tài liệu kỹ thuật, hệ thống n8n sẽ kết nối đến SharePoint để lưu trữ các tài liệu tại đường dẫn:**  
   `Documents\WMS\SDLC\[domain]\{children}`  
   - Trong đó:  
     - `domain` là chức năng mà người dùng mong muốn phát triển.  
     - `children` là các file tài liệu của BA, Dev, QC.  
   - Các file được lưu theo định dạng:  
     `[type_file]_[domain]_[version].md`

4. **Giai đoạn Develop (do tôi trực tiếp thực hiện)**  
   - *(Các node màu xanh trong workflow)*  
   - Tất cả các bước trong giai đoạn này đều sử dụng terminal để kết nối đến máy ảo và thực hiện phát triển.

   Các bước chi tiết:  
   4.1. Tạo branch mới trong repository dự án.  
   4.2. Tải các file tài liệu liên quan đến feature từ SharePoint về thư mục `/docs`.  
   4.3. Dựa trên các file tài liệu đã tải về cùng với file `llms.txt` đặc thù của dự án, tôi sẽ xây dựng **Kế hoạch triển khai chức năng (Implement Function Planning)**. Mục tiêu là tạo một kế hoạch tổng thể, có trình tự rõ ràng để hướng dẫn việc phát triển code theo đúng quy trình, tránh việc code tùy tiện.  
   4.4. Khi kế hoạch triển khai hoàn chỉnh, tôi sẽ sử dụng file này làm đầu vào cho **Gemini CLI** (hoặc **Claude Code**) để tự động sinh mã nguồn cho các phần:  
        - Business Logic Implementation  
        - Application Layer Architecture  
        - Backend API Implementation  
        - Frontend Development  
        - Integration Implementation  
        - Unit Testing Implementation  
   4.5. Sau khi mã nguồn được sinh ra, tôi sẽ thực hiện bước **Code Review tự động bằng AI**. Nếu kết quả review đạt yêu cầu, tôi sẽ tạo branch mới, đẩy source code lên repository và tạo Pull Request.

---

# Nhiệm vụ hiện tại

1. Đọc và hiểu file `llms.txt` trên repository để nắm rõ dự án và codebase.  
2. Phân tích các file prompt của bước 2 (chuẩn bị tài liệu kỹ thuật) mà tôi đã cung cấp, tập trung đánh giá các đầu ra (output) của prompt có tác dụng hỗ trợ cho bước 4.1 (Implement Function Planning) và bước generate code tiếp theo.  
   - *(Lưu ý: Không phân tích chi tiết input đầu vào của từng prompt, chỉ tập trung vào đầu ra có giá trị cho bước 4.1 và 4.2)*  
3. Dựa trên kết quả phân tích, tạo mockup các thông tin cần thiết vào các file tương ứng và lưu vào thư mục `docs/` (với chức năng mẫu là Authentication).  
4. Soạn thảo prompt cho bước 4.1 (Implement Function Planning), sao cho file kế hoạch tạo ra có thể đáp ứng đầy đủ yêu cầu cho bước 4.2 (tự động sinh code).

---

**Lưu ý:**  
Hiện tại tôi sẽ ưu tiên sử dụng **Gemini CLI** để xử lý bước generate code do chi phí hợp lý, tuy nhiên trong tương lai có thể chuyển sang dùng **Claude Code**.

---