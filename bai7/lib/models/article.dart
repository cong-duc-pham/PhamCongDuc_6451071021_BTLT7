class Article {
  final int id;
  final String title;
  final String body;
  final int userId;

  Article({
    required this.id,
    required this.title,
    required this.body,
    required this.userId,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      userId: json['userId'],
    );
  }
}