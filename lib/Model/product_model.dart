class Product {
  final String name;
  final String description;
  final double price;
  final String img;
  int quantity;

  Product({
    required this.name,
    required this.description,
    required this.price,
    required this.img,
    this.quantity = 1,
  });
}
