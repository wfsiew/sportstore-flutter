import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sportsstore_flutter/model/product-args.dart';

class ProductDetail extends StatefulWidget {
  ProductDetail({Key key, this.title}) : super(key: key);

  static const String routeName = '/ProductDetail';

  final String title;

  @override
  _ProductDetailState createState() =>_ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  
  @override
  Widget build(BuildContext context) {
    final ProductArgs x = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: Center(
          child: Text('product detail - ${x.productID}, ${x.name}'),
        ),
      )
    );
  }
}