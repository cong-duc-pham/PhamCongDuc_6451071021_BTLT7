import 'package:flutter/material.dart';
import '../controllers/post_controller.dart';
import '../models/post.dart';

class CreatePostView extends StatefulWidget {
  const CreatePostView({super.key});

  @override
  State<CreatePostView> createState() => _CreatePostViewState();
}

class _CreatePostViewState extends State<CreatePostView> {
  final PostController _controller = PostController();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  bool _isLoading = false;
  String? _responseText;
  String? _errorText;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _submitPost() async {
    final title = _titleController.text.trim();
    final body = _bodyController.text.trim();

    if (title.isEmpty || body.isEmpty) {
      setState(() {
        _errorText = 'Vui lòng nhập đầy đủ tiêu đề và nội dung.';
        _responseText = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorText = null;
      _responseText = null;
    });

    try {
      final newPost = Post(title: title, body: body, userId: 1);
      final result = await _controller.createPost(newPost);

      setState(() {
        _responseText =
        'Post created successfully!\n\n'
            'ID: ${result.id}\n'
            'Title: ${result.title}\n'
            'Body: ${result.body}\n'
            'User ID: ${result.userId}';
        _isLoading = false;
      });

      _titleController.clear();
      _bodyController.clear();
    } catch (e) {
      setState(() {
        _errorText = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tạo bài viết mới'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tiêu đề input
            const Text('Tiêu đề'),
            const SizedBox(height: 6),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Nhập tiêu đề bài viết',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            // Nội dung input
            const Text('Nội dung'),
            const SizedBox(height: 6),
            TextField(
              controller: _bodyController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Nhập nội dung bài viết',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // Nút gửi
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitPost,
                child: _isLoading
                    ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : const Text('Đăng bài'),
              ),
            ),

            const SizedBox(height: 20),

            // Thông báo lỗi
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

            // Response từ server
            if (_responseText != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  _responseText!,
                  style: const TextStyle(color: Colors.green),
                ),
              ),
              const SizedBox(height: 12),
            ],

            const Divider(),

            // MSSV
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
}