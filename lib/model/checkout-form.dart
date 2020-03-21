import 'cart.dart';
import 'order.dart';

class CheckoutForm {
  Order order;
  List<CartLine> lines;

  CheckoutForm({
    this.order,
    this.lines
  });

  Map<String, dynamic> toJson() => {
    'order': order.toJson(),
    'lines': List.from(lines.map((x) => x.toJson()))
  };
}