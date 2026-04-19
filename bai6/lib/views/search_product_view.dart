import 'package:flutter/material.dart';
import '../controllers/search_controller.dart' as sc;
import '../models/search_product.dart';

class SearchProductView extends StatefulWidget {
  const SearchProductView({super.key});

  @override
  State<SearchProductView> createState() => _SearchProductViewState();
}

class _SearchProductViewState extends State<SearchProductView> {
  final sc.SearchController _controller = sc.SearchController();
  final TextEditingController _searchController = TextEditingController();

  List<SearchProduct> _results = [];
  bool _isLoading = false;
  bool _hasSearched = false;
  String? _errorText;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _search(String keyword) async {
    if (keyword.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
      _hasSearched = true;
      _errorText = null;
      _results = [];
    });

    try {
      final results = await _controller.searchProducts(keyword.trim());
      setState(() {
        _results = results;
        _isLoading = false;
      });
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
        title: const Text('Tìm kiếm sản phẩm'),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              onSubmitted: _search,
              decoration: InputDecoration(
                hintText: 'Nhập tên sản phẩm...',
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 10),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => _search(_searchController.text),
                ),
              ),
            ),
          ),

          // Body
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorText != null
                ? Center(
              child: Text(
                _errorText!,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            )
                : !_hasSearched
                ? const Center(
              child: Text('Nhập từ khóa để tìm kiếm'),
            )
                : _results.isEmpty
                ? const Center(
              child: Text('Không tìm thấy sản phẩm nào'),
            )
                : ListView.separated(
              itemCount: _results.length,
              separatorBuilder: (_, __) =>
              const Divider(height: 1),
              itemBuilder: (context, index) {
                final product = _results[index];
                return ListTile(
                  leading: SizedBox(
                    width: 50,
                    height: 50,
                    child: Image.network(
                      product.thumbnail,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                      const Icon(Icons.image_not_supported),
                    ),
                  ),
                  title: Text(product.title),
                  subtitle: Text(product.category),
                  trailing: Text(
                    '\$${product.price.toStringAsFixed(2)}',
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
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}