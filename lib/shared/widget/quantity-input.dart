import 'package:flutter/material.dart';

class QuantityInput extends StatefulWidget {
  QuantityInput({Key key, this.value, this.productID, this.onQuantityChanged}) : super(key: key);

  final String value;
  final int productID;
  final void Function(int, int) onQuantityChanged;

  @override
  _QuantityInputState createState() => _QuantityInputState(
    value: value, 
    productID: productID
  );
}

class _QuantityInputState extends State<QuantityInput> {

  String value = '0';
  int productID;

  _QuantityInputState({
    this.value,
    this.productID
  });

  void minusQty() {
    int x = int.tryParse(value) ?? 1;
    if (x > 1) {
      x--;
    }
    upDateTextQty(x);
  }

  void addQty() {
    int x = int.tryParse(value) ?? 1;
    x++;
    upDateTextQty(x);
  }

  void setQty(String s) {
    int x = int.tryParse(s) ?? 1;
    upDateTextQty(x);
  }

  void upDateTextQty(int quantity) {
    String v = '$quantity';
    widget.onQuantityChanged(productID, quantity);
    setState(() {
     value = v;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        IconButton(icon: Icon(Icons.remove), color: Colors.red,
          onPressed: value == '1' ? null : minusQty,
        ),
        FittedBox(
          child: Container(
            padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
            color: Colors.black12,
            child: Center(
              child: Text('$value'),
            ),
          ),
        ),
        IconButton(icon: Icon(Icons.add), color: Colors.red,
          onPressed: addQty,
        ),
      ],
    );
  }
}