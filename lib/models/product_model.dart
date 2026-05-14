class ProductModel {
  final int id;
  final String name;
  final String price;
  final String description;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? 0,
      name: json['name']?.toString() ?? '',
      price: json['price']?.toString() ?? '0',
      description: json['description']?.toString() ?? '',
    );
  }
}
