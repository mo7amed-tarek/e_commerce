class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final List<String> images;
  final List<String> colors;
  final double rating;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.images,
    required this.colors,
    required this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      images: List<String>.from(json['images']),
      colors: List<String>.from(json['colors']),
      rating: json['rating'].toDouble(),
    );
  }
}
