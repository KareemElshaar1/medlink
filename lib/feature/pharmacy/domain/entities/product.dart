class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final String manufacturer;
  final int stockQuantity;
  final bool isAvailable;
  final Map<String, String> attributes;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.manufacturer,
    required this.stockQuantity,
    required this.isAvailable,
    required this.attributes,
  });
}
