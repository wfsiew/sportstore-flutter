import 'package:flutter/material.dart';
import 'dart:async';
import 'package:sportsstore_flutter/service/product-service.dart';
import 'package:sportsstore_flutter/service/cart-service.dart';
import 'category.dart';
import 'package:sportsstore_flutter/model/product.dart';
import 'package:sportsstore_flutter/helpers.dart';
import 'package:sportsstore_flutter/shared/widget/bottom-bar.dart';

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);

  static const String routeName = '/Home';

  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int currIndex = 0;
  ScrollController scr = ScrollController();
  List<Product> ls = <Product>[];
  int page = 1;
  String category;
  bool isLoading = false;
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    load();
    scr.addListener(() {
      if (scr.position.pixels == scr.position.maxScrollExtent) {
        loadMore();
      }
    });
  }

  @override
  void dispose() {
    scr.dispose();
    super.dispose();
  }

  void load() async {
    try {
      setState(() {
       isLoading = true; 
      });
      var lx = await getProducts(category = category);
      setState(() {
       page = 1;
       ls = lx;
       isLoading = false;
      });
    }
    
    catch(error) {
      setState(() {
       isLoading = false;
       handleError(context, error, load);
      });
    }
  }

  void loadMore() async {
    int p = page + 1;
    try {
      var lx = await getProducts(category = category, page = p);
      if (lx.length < 1) {
        return;
      }

      setState(() {
       page = p;
       ls.addAll(lx);
      });
    }
    
    catch(error) {
      handleError(context, error, loadMore);
    }
  }

  Future<void> addToCart(Product product) async {
    await addItem(product, 1);
    final snackBar = SnackBar(content: Text('Added to cart successfully!'), duration: Duration(seconds: 2));
    scaffoldKey.currentState.showSnackBar(snackBar);

    // Navigator.pushNamed(context, ProductDetail.routeName, arguments: ProductArgs(
    //   o.productID, o.name
    // ));
    //Toast.show(x, context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
  }

  Future<void> refreshData() async {
    try {
      var lx = await getProducts(category = category);
      ls.clear();
      setState(() {
       page = 1;
       ls = lx;
      });
    }
    
    catch(error) {
      handleError(context, error, () async {
        await refreshData();
      });
    }
  }

  gotoCategory(int i) async {
    if (i == 0) {
      setState(() {
       category = null;
       load();
      });
    }

    else {
      final _category = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Category(title: 'Categories')),
      );
      setState(() {
       category = _category;
       load();
      });
    }
  }

  Widget buildRow(Product o) {
    return Card(
      child: ListTile(
        title: Text(
          '${o.name}',
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.black
          ),
        ),
        subtitle: Text('${o.description}'),
        leading: IconButton(
          icon: Icon(Icons.add, size: 24.0, color: Colors.red),
          onPressed: () async {
            await addToCart(o);
          },
        ),
        trailing: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            child: Text('${formatAmt(o.price)}')
          ),
        ),
      ),
    );
  }

  Widget buildList() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Container(
      child: ListView.builder(
        padding: const EdgeInsets.all(2.0),
        controller: scr,
        itemCount: ls.length,
        itemBuilder: (context, i) {
          Product o = ls[i];
          return buildRow(o);
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
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (int i) {
              gotoCategory(i);
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: 0,
                  child: Text('All Categories'),
                ),
                PopupMenuItem(
                  value: 1,
                  child: Text('Select Category'),
                )
              ];
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        key: refreshIndicatorKey,
        onRefresh: refreshData,
        child: buildList(),
      ),
      bottomNavigationBar: CustomBottomBar(index: 0),
    );
  }
}