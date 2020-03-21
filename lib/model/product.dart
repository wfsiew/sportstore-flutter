class Product {
  int productID;
  String name;
  String description;
  double price;
  String category;

  Product({
    this.productID,
    this.name,
    this.description,
    this.price,
    this.category
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productID: json['productID'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      category: json['category']
    );
  }

  Map<String, dynamic> toJson() => {
    'productID': productID,
    'name': name,
    'description': description,
    'price': price,
    'category': category
  };
}