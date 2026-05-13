import 'product_model.dart';

class CartModel {
  final String cartId;
  final int numOfCartItems;
  final double totalCartPrice;
  final List<CartItem> products;

  CartModel({
    required this.cartId,
    required this.numOfCartItems,
    required this.totalCartPrice,
    required this.products,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    try {
      print(' Parsing CartModel from JSON');
      print(' Raw JSON: $json');

      final data = json['data'] ?? json;
      print(' Data object: $data');

      final productsList = data['products'] as List<dynamic>? ?? [];
      print(' Products list length: ${productsList.length}');

      final validProducts = <CartItem>[];
      for (var item in productsList) {
        try {
          print(' Parsing product item: $item');

          if (item != null) {
            final cartItem = CartItem.fromJson(item as Map<String, dynamic>);

            if (cartItem.product != null) {
              validProducts.add(cartItem);
              print(' Product with details added');
            } else {
              print(' Skipping cart item without product details');
            }
          }
        } catch (e) {
          print(' Error parsing cart item, skipping: $e');
        }
      }

      print(' Valid products count: ${validProducts.length}');

      return CartModel(
        cartId: data['_id'] ?? '',
        numOfCartItems: (json['numOfCartItems'] as num?)?.toInt() ?? 0,
        totalCartPrice: (data['totalCartPrice'] as num?)?.toDouble() ?? 0.0,
        products: validProducts,
      );
    } catch (e) {
      print(' Error parsing CartModel: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'data': {
        '_id': cartId,
        'products': products.map((p) => p.toJson()).toList(),
        'totalCartPrice': totalCartPrice,
      },
      'numOfCartItems': numOfCartItems,
    };
  }
}

class CartItem {
  final String id;
  final int count;
  final double price;
  final Product? product;

  CartItem({
    required this.id,
    required this.count,
    required this.price,
    this.product,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    try {
      print(' Parsing CartItem from JSON: $json');

      Product? productObj;
      final productData = json['product'];

      if (productData != null) {
        if (productData is Map<String, dynamic>) {
          productObj = Product.fromJson(productData);
          print(' Product parsed as Object');
        } else if (productData is String) {
          print(' Product is just an ID string: $productData');
          productObj = null;
        }
      }

      return CartItem(
        id: json['_id'] ?? '',
        count: (json['count'] as num?)?.toInt() ?? 1,
        price: (json['price'] as num?)?.toDouble() ?? 0.0,
        product: productObj,
      );
    } catch (e) {
      print(' Error parsing CartItem: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'count': count,
      'price': price,
      'product': product?.toJson(),
    };
  }

  double get totalPrice => price * count;
}
