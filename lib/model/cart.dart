import 'product.dart';

class CartLine {
  int cartLineID;
  Product product;
  int quantity;

  CartLine({
    this.cartLineID,
    this.product,
    this.quantity
  });

  factory CartLine.fromJson(Map<String, dynamic> json) {
    return CartLine(
      cartLineID: json['cartLineID'],
      product: Product.fromJson(json['product']),
      quantity: json['quantity']
    );
  }

  Map<String, dynamic> toJson() => {
    'cartLineID': cartLineID ?? 0,
    'product': product.toJson(),
    'quantity': quantity
  };
}

class CartSummary {
  int totalQuantity;
  double totalPrice;

  CartSummary({
    this.totalQuantity, 
    this.totalPrice
  });

  factory CartSummary.getSummary(List<CartLine> lines) {
    int qty = 0;
    double total = 0;

    lines.forEach((x) {
      qty += x.quantity;
      total += x.product.price * x.quantity;
    });

    return CartSummary(
      totalQuantity: qty,
      totalPrice: total
    );
  }
}