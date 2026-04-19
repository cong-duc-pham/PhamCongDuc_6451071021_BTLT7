import 'package:flutter/material.dart';
import '../controllers/user_controller.dart';
import '../models/user.dart';

class UpdateUserView extends StatefulWidget {
  const UpdateUserView({super.key});

  @override
  State<UpdateUserView> createState() => _UpdateUserViewState();
}

class _UpdateUserViewState extends State<UpdateUserView> {
  final UserController _controller = UserController();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();

  bool _isLoadingGet = true;
  bool _isLoadingPut = false;
  String? _errorText;
  User? _updatedUser;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  Future<void> _loadUser() async {
    try {
      final user = await _controller.fetchUser(1);
      setState(() {
        _nameController.text = user.name;
        _usernameController.text = user.username;
        _emailController.text = user.email;
        _phoneController.text = user.phone;
        _websiteController.text = user.website;
        _isLoadingGet = false;
      });
    } catch (e) {
      setState(() {
        _errorText = e.toString();
        _isLoadingGet = false;
      });
    }
  }

  Future<void> _submitUpdate() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoadingPut = true;
      _errorText = null;
    });

    try {
      final user = User(
        name: _nameController.text.trim(),
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        website: _websiteController.text.trim(),
      );

      final result = await _controller.updateUser(1, user);

      setState(() {
        _updatedUser = result;
        _isLoadingPut = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cập nhật thông tin thành công!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _errorText = e.toString();
        _isLoadingPut = false;
      });
    }
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            border: const OutlineInputBorder(),
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
          validator: validator,
        ),
        const SizedBox(height: 14),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cập nhật hồ sơ'),
      ),
      body: _isLoadingGet
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Form chỉnh sửa
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildField(
                    label: 'Họ tên',
                    controller: _nameController,
                    hint: 'Nhập họ tên',
                    validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Không được để trống' : null,
                  ),
                  _buildField(
                    label: 'Username',
                    controller: _usernameController,
                    hint: 'Nhập username',
                    validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Không được để trống' : null,
                  ),
                  _buildField(
                    label: 'Email',
                    controller: _emailController,
                    hint: 'Nhập email',
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Không được để trống';
                      if (!v.contains('@')) return 'Email không hợp lệ';
                      return null;
                    },
                  ),
                  _buildField(
                    label: 'Số điện thoại',
                    controller: _phoneController,
                    hint: 'Nhập số điện thoại',
                    keyboardType: TextInputType.phone,
                    validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Không được để trống' : null,
                  ),
                  _buildField(
                    label: 'Website',
                    controller: _websiteController,
                    hint: 'Nhập website',
                    validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Không được để trống' : null,
                  ),
                ],
              ),
            ),

            // Nút cập nhật
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoadingPut ? null : _submitUpdate,
                child: _isLoadingPut
                    ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : const Text('Cập nhật'),
              ),
            ),

            const SizedBox(height: 16),

            // Lỗi
            if (_errorText != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  _errorText!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
              const SizedBox(height: 12),
            ],

            // Dữ liệu mới sau khi update
            if (_updatedUser != null) ...[
              const Divider(),
              const Text(
                'Thông tin sau khi cập nhật:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _infoRow('ID', '${_updatedUser!.id}'),
              _infoRow('Họ tên', _updatedUser!.name),
              _infoRow('Username', _updatedUser!.username),
              _infoRow('Email', _updatedUser!.email),
              _infoRow('Điện thoại', _updatedUser!.phone),
              _infoRow('Website', _updatedUser!.website),
              const SizedBox(height: 12),
            ],

            const Divider(),
            const Center(
              child: Text(
                '6451071021 - Phạm Công Đức',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              '$label:',
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}