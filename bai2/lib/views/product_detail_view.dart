import 'package:flutter/material.dart';
import '../controllers/product_controller.dart';
import '../models/product.dart';

class ProductDetailView extends StatefulWidget {
  const ProductDetailView({super.key});

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  final ProductController _controller = ProductController();
  late Future<Product> _productFuture;

  @override
  void initState() {
    super.initState();
    _productFuture = _controller.fetchProduct(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết sản phẩm'),
      ),
      body: FutureBuilder<Product>(
        future: _productFuture,
        builder: (context, snapshot) {
          // Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Error
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Đã xảy ra lỗi:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    snapshot.error.toString(),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _productFuture = _controller.fetchProduct(1);
                      });
                    },
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }

          // Data
          if (!snapshot.hasData) {
            return const Center(child: Text('Không có dữ liệu'));
          }

          final product = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ảnh sản phẩm
                Center(
                  child: Image.network(
                    product.image,
                    height: 220,
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 16),

                // Tên sản phẩm
                Text(
                  product.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                // Danh mục
                Text(
                  'Danh mục: ${product.category}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),

                const SizedBox(height: 8),

                // Giá
                Text(
                  'Giá: \$${product.price.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 16),
                ),

                const SizedBox(height: 12),

                const Divider(),

                // Mô tả
                const Text(
                  'Mô tả:',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  product.description,
                  style: const TextStyle(fontSize: 14),
                ),

                const SizedBox(height: 24),

                // MSSV
                const Divider(),
                const Center(
                  child: Text(
                    '6451071021 - Phạm Công Đức',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}