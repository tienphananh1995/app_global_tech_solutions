import 'package:flutter/material.dart';
import '../models/event_model.dart';
import 'registration_form_screen.dart'; // Chúng ta sẽ tạo file này tiếp theo

class EventDetailScreen extends StatelessWidget {
  final Event event;

  const EventDetailScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết sự kiện'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hình ảnh minh họa (Nếu bạn có URL ảnh từ Strapi)
            event.imageUrl != null
                ? Image.network(
              event.imageUrl!, // Thêm dấu ! vì bạn đã check null ở trên
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              // (Tùy chọn) Thêm loading để mượt mà hơn
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  width: double.infinity,
                  height: 200,
                  color: Colors.grey[200],
                  child: const Center(child: CircularProgressIndicator()),
                );
              },
              // (Tùy chọn) Xử lý nếu link ảnh bị hỏng (404)
              errorBuilder: (context, error, stackTrace) => Container(
                width: double.infinity,
                height: 200,
                color: Colors.grey[300],
                child: const Icon(Icons.broken_image, size: 100, color: Colors.grey),
              ),
            )
                : Container(
              width: double.infinity,
              height: 200,
              color: Colors.grey[300],
              child: const Icon(Icons.image, size: 100, color: Colors.grey),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tiêu đề sự kiện
                  Text(
                    event.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Row chứa thời gian hoặc địa điểm (giả định)
                  const Row(
                    children: [
                      Icon(Icons.calendar_today, size: 18, color: Colors.blue),
                      SizedBox(width: 8),
                      Text("Ngày: 20/12/2024", style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  const Divider(height: 30),

                  // Mô tả chi tiết
                  const Text(
                    "Giới thiệu sự kiện:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    event.description,
                    style: const TextStyle(fontSize: 16),
                  ),

                  const SizedBox(height: 40),

                  // Nút Đăng ký
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        // Chuyển sang màn hình Form đăng ký
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegistrationFormScreen(event: event),
                          ),
                        );
                      },
                      child: const Text(
                        "ĐĂNG KÝ THAM GIA NGAY",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}