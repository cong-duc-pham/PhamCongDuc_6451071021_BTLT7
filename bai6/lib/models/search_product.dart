class SearchProduct {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String thumbnail;

  SearchProduct({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.thumbnail,
  });

  factory SearchProduct.fromJson(Map<String, dynamic> json) {
    return SearchProduct(
      id: json['id'],
      title: json['title'] ?? '',
      price: (json['price'] as num).toDouble(),
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
    );
  }
}