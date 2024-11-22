// lib/models/product.dart

class Product {
  final String productID;
  final String category;
  final String name;
  final double price;
  final double rating;
  final int reviewCount;
  final String description;
  final String imageURL;

  Product({
    required this.productID,
    required this.category,
    required this.name,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.description,
    required this.imageURL,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productID: json['ProductID'],
      category: json['Category'],
      name: json['Name'],
      price: json['Price'].toDouble(),
      rating: json['Rating'].toDouble(),
      reviewCount: json['ReviewCount'],
      description: json['Description'],
      imageURL: json['ImageURL'],
    );
  }
}
