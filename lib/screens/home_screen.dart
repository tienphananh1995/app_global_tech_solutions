import 'package:flutter/material.dart';
import '../models/event_model.dart';
import '../services/api_service.dart';
import 'event_detail_screen.dart'; // Chúng ta sẽ tạo file này sau

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Event>> _eventsFuture;

  @override
  void initState() {
    super.initState();
    // Gọi API ngay khi khởi tạo màn hình
    _eventsFuture = ApiService.fetchEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách sự kiện'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Event>>(
        future: _eventsFuture,
        builder: (context, snapshot) {
          // 1. Trạng thái đang tải dữ liệu
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Trạng thái lỗi
          if (snapshot.hasError) {
            return Center(
              child: Text('Đã xảy ra lỗi: ${snapshot.error}'),
            );
          }

          // 3. Trạng thái không có dữ liệu
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Không có sự kiện nào sắp tới.'));
          }

          // 4. Hiển thị danh sách nếu thành công
          final events = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(
                    event.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      event.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // Chuyển sang trang chi tiết sự kiện
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventDetailScreen(event: event),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}