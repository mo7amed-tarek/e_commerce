class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final double? priceAfterDiscount;
  final String imageCover;
  final List<String> images;
  final double ratingsAverage;
  final int ratingsQuantity;
  final int quantity;
  final int sold;
  final Category? category;
  final Brand? brand;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    this.priceAfterDiscount,
    required this.imageCover,
    required this.images,
    required this.ratingsAverage,
    required this.ratingsQuantity,
    required this.quantity,
    required this.sold,
    this.category,
    this.brand,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      priceAfterDiscount: (json['priceAfterDiscount'] as num?)?.toDouble(),
      imageCover: json['imageCover'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      ratingsAverage: (json['ratingsAverage'] as num?)?.toDouble() ?? 0.0,
      ratingsQuantity: (json['ratingsQuantity'] as num?)?.toInt() ?? 0,
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      sold: (json['sold'] as num?)?.toInt() ?? 0,
      category: json['category'] != null
          ? Category.fromJson(json['category'])
          : null,
      brand: json['brand'] != null ? Brand.fromJson(json['brand']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'price': price,
      'priceAfterDiscount': priceAfterDiscount,
      'imageCover': imageCover,
      'images': images,
      'ratingsAverage': ratingsAverage,
      'ratingsQuantity': ratingsQuantity,
      'quantity': quantity,
      'sold': sold,
      'category': category?.toJson(),
      'brand': brand?.toJson(),
    };
  }
}

class Category {
  final String id;
  final String name;
  final String image;
  final String slug;

  Category({
    required this.id,
    required this.name,
    required this.image,
    required this.slug,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      slug: json['slug'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name, 'image': image, 'slug': slug};
  }
}

class Brand {
  final String id;
  final String name;
  final String image;

  Brand({required this.id, required this.name, required this.image});

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name, 'image': image};
  }
}
