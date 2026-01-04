import 'package:flutter/material.dart';
import '../models/event_model.dart';
import '../services/api_service.dart';

class RegistrationFormScreen extends StatefulWidget {
  final Event event;

  const RegistrationFormScreen({super.key, required this.event});

  @override
  State<RegistrationFormScreen> createState() => _RegistrationFormScreenState();
}

class _RegistrationFormScreenState extends State<RegistrationFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Các controller để lấy dữ liệu từ ô nhập liệu
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  bool _isLoading = false;

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Chuẩn bị dữ liệu theo cấu trúc Strapi yêu cầu
      Map<String, String> userData = {
        "full_name": _nameController.text,
        "email": _emailController.text,
        "phone": _phoneController.text,
        "address": _addressController.text,
      };

      try {
        bool success = await ApiService.registerEvent(widget.event.id, userData);

        setState(() => _isLoading = false);

        if (success) {
          _showDialog("Thành công", "Bạn đã đăng ký tham gia sự kiện thành công!");
        } else {
          _showDialog("Thất bại", "Có lỗi xảy ra, vui lòng thử lại sau.");
        }
      } catch (e) {
        setState(() => _isLoading = false);
        _showDialog("Lỗi", "Không thể kết nối đến máy chủ.");
      }
    }
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx); // Đóng dialog
              if (title == "Thành công") Navigator.pop(context); // Quay về trang chi tiết
            },
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Đăng ký tham gia")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                "Sự kiện: ${widget.event.title}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
              const SizedBox(height: 20),

              _buildTextField(_nameController, "Họ và tên", Icons.person, "Vui lòng nhập họ tên"),
              _buildTextField(_emailController, "Email", Icons.email, "Vui lòng nhập email", isEmail: true),
              _buildTextField(_phoneController, "Số điện thoại", Icons.phone, "Vui lòng nhập số điện thoại"),
              _buildTextField(_addressController, "Địa chỉ", Icons.location_on, "Vui lòng nhập địa chỉ"),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Colors.blueAccent,
                ),
                child: const Text("GỬI ĐĂNG KÝ", style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, String errorMsg, {bool isEmail = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) return errorMsg;
          if (isEmail && !value.contains("@")) return "Email không hợp lệ";
          return null;
        },
      ),
    );
  }
}