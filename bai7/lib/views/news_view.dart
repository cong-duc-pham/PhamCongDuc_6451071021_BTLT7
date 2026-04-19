import 'package:flutter/material.dart';
import '../controllers/news_controller.dart';
import '../models/article.dart';

class NewsView extends StatefulWidget {
  const NewsView({super.key});

  @override
  State<NewsView> createState() => _NewsViewState();
}

class _NewsViewState extends State<NewsView> {
  final NewsController _controller = NewsController();

  List<Article> _articles = [];
  bool _isLoading = true;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  Future<void> _loadNews() async {
    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    try {
      final articles = await _controller.fetchNews();
      setState(() {
        _articles = articles;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorText = e.toString();
        _isLoading = false;
      });
    }
  }

  // Hàm này dùng cho RefreshIndicator (phải trả về Future<void>)
  Future<void> _onRefresh() async {
    try {
      final articles = await _controller.fetchNews();
      setState(() {
        _articles = articles;
        _errorText = null;
      });
    } catch (e) {
      setState(() {
        _errorText = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tin tức'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadNews,
            tooltip: 'Tải lại',
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
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _loadNews,
              child: const Text('Thử lại'),
            ),
          ],
        ),
      )
          : Column(
        children: [
          // Hướng dẫn kéo
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
                vertical: 6, horizontal: 12),
            color: Colors.grey.shade100,
            child: const Text(
              'Kéo xuống để làm mới dữ liệu',
              style:
              TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ),

          Expanded(
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: _articles.length,
                separatorBuilder: (_, __) =>
                const Divider(height: 1),
                itemBuilder: (context, index) {
                  final article = _articles[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey.shade200,
                      child: Text(
                        '${article.id}',
                        style: const TextStyle(
                            fontSize: 12, color: Colors.grey),
                      ),
                    ),
                    title: Text(
                      article.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      article.body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12),
                    ),
                    isThreeLine: true,
                  );
                },
              ),
            ),
          ),

          // Footer MSSV
          const Divider(height: 1),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              '6451071021 - Phạm Công Đức',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}