import 'package:flutter/material.dart';
import 'dart:async';
import 'package:sportsstore_flutter/service/cart-service.dart';
import 'package:sportsstore_flutter/model/cart.dart';
import 'package:sportsstore_flutter/helpers.dart';
import 'package:sportsstore_flutter/shared/widget/bottom-bar.dart';
import 'package:sportsstore_flutter/shared/widget/quantity-input.dart';
import 'checkout.dart';

class Cart extends StatefulWidget {
  Cart({Key key, this.title}) : super(key: key);

  static const String routeName = '/Cart';

  final String title;

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {

  List<CartLine> lines;
  CartSummary summary;
  int currIndex = 1;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> getData() async {
    var ls = await getLines();
    var cart = CartSummary.getSummary(ls);

    setState(() {
     lines = ls;
     summary = cart;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  void updateQuantity(int productID, int quantity) async {
    await updateItem(productID, quantity);
    await getData();
  }

  Widget buildList() {
    if (lines.length < 1) {
      return Container(
        padding: const EdgeInsets.fromLTRB(8.0, 50.0, 8.0, 8.0),
        child: Column(
          children: <Widget>[
            Center(
              child: Container(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'There are no items in this cart',
                  style: TextStyle(
                    fontSize: 18.0
                  ),
                ),
              ),
            ),
            Center(
              child: RaisedButton(
                elevation: 5,
                child: Text('CONTINUE SHOPPING'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ),
          ],
        ),
      );
    }

    return Container(
      child: ListView.builder(
        itemCount: lines.length + 2,
        padding: const EdgeInsets.all(2.0),
        itemBuilder: (context, index) {
          if (index == lines.length && lines.length > 0) {
            return Card(
              child: ListTile(
                title: Text(
                  'Total:',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 18.0
                  ),
                ),
                trailing: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    child: Text(
                      '${formatAmt(summary.totalPrice)}',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    )
                  ),
                ),
              ),
            );
          }

          else if (index == lines.length + 1 && lines.length > 0) {
            return Container(
              margin: const EdgeInsets.only(left: 5.0, right: 5.0),
              width: MediaQuery.of(context).size.width,
              child: RaisedButton(
                color: Colors.red,
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                child: Text(
                  'Check Out',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                  ),
                ),
                onPressed: () async {
                  final b = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Checkout(title: 'Check out')),
                  ) ?? false;
                  if (b) {
                    final snackBar = SnackBar(content: Text('Your order has been successfully checked out!'), duration: Duration(seconds: 5));
                    scaffoldKey.currentState.showSnackBar(snackBar);
                    getData();
                  }
                },
              ),
            );
          }

          else {
            return Card(
              child: ListTile(
                title: Text(
                  '${lines[index].product.name}',
                  style: TextStyle(
                    fontSize: 18.0
                  ),
                ),
                subtitle: Text(
                  '${formatAmt(lines[index].product.price)}',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                leading: IconButton(
                  icon: Icon(Icons.delete, size: 24.0, color: Colors.red),
                  onPressed: () async {
                    await removeItem(lines[index].product);
                    await getData();
                  },
                ),
                trailing: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 140,
                    height: 20,
                    child: QuantityInput(
                      value: '${lines[index].quantity}',
                      productID: lines[index].product.productID,
                      onQuantityChanged: updateQuantity,
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
        automaticallyImplyLeading: false,
      ),
      body: lines != null ? buildList() : Center(child: CircularProgressIndicator()),
      bottomNavigationBar: CustomBottomBar(index: 1),
    );
  }
}