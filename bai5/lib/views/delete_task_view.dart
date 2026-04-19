import 'package:flutter/material.dart';
import '../controllers/todo_controller.dart';
import '../models/todo.dart';

class DeleteTaskView extends StatefulWidget {
  const DeleteTaskView({super.key});

  @override
  State<DeleteTaskView> createState() => _DeleteTaskViewState();
}

class _DeleteTaskViewState extends State<DeleteTaskView> {
  final TodoController _controller = TodoController();

  List<Todo> _todos = [];
  bool _isLoading = true;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    setState(() {
      _isLoading = true;
      _errorText = null;
    });
    try {
      final todos = await _controller.fetchTodos();
      setState(() {
        _todos = todos;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorText = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteTask(int id, int index) async {
    try {
      await _controller.deleteTask(id);

      setState(() {
        _todos.removeAt(index);
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đã xóa task #$id'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: ${e.toString()}'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  void _confirmDelete(int id, int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc muốn xóa task #$id không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _deleteTask(id, index);
            },
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý Task'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadTodos,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorText != null
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _errorText!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _loadTodos,
              child: const Text('Thử lại'),
            ),
          ],
        ),
      )
          : _todos.isEmpty
          ? const Center(child: Text('Danh sách trống'))
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _todos.length,
              itemBuilder: (context, index) {
                final todo = _todos[index];
                return Dismissible(
                  key: Key(todo.id.toString()),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  confirmDismiss: (_) async {
                    bool confirmed = false;
                    await showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Xác nhận xóa'),
                        content: Text(
                            'Bạn có chắc muốn xóa task #${todo.id} không?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              confirmed = false;
                              Navigator.pop(ctx);
                            },
                            child: const Text('Hủy'),
                          ),
                          TextButton(
                            onPressed: () {
                              confirmed = true;
                              Navigator.pop(ctx);
                            },
                            child: const Text('Xóa',
                                style: TextStyle(
                                    color: Colors.red)),
                          ),
                        ],
                      ),
                    );
                    return confirmed;
                  },
                  onDismissed: (_) => _deleteTask(todo.id, index),
                  child: ListTile(
                    leading: Text(
                      '#${todo.id}',
                      style: const TextStyle(
                          color: Colors.grey, fontSize: 13),
                    ),
                    title: Text(
                      todo.title,
                      style: TextStyle(
                        decoration: todo.completed
                            ? TextDecoration.lineThrough
                            : null,
                        color: todo.completed
                            ? Colors.grey
                            : null,
                      ),
                    ),
                    subtitle: Text(
                      todo.completed ? 'Hoàn thành' : 'Chưa xong',
                      style: TextStyle(
                        fontSize: 12,
                        color: todo.completed
                            ? Colors.green
                            : Colors.orange,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline,
                          color: Colors.red),
                      onPressed: () =>
                          _confirmDelete(todo.id, index),
                    ),
                  ),
                );
              },
            ),
          ),

          // Footer MSSV
          const Divider(height: 1),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              '6451071021 - Phạm Công Đức',
              style:
              TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}