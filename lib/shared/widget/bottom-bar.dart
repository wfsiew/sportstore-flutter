import 'package:flutter/material.dart';
import 'package:sportsstore_flutter/ui/cart.dart';

class CustomBottomBar extends StatefulWidget {
  CustomBottomBar({Key key, this.index}) : super(key: key);

  final int index;

  @override
  _CustomBottomBarState createState() => _CustomBottomBarState(currIndex: index);
}

class _CustomBottomBarState extends State<CustomBottomBar> {

  int currIndex = 0;

  _CustomBottomBarState({
    this.currIndex
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currIndex,
      onTap: (int i) {
        if (i == 0 && currIndex != i) {
          Navigator.pop(context);
        }

        else if (i == 1 && currIndex != i) {
          Navigator.pushNamed(context, Cart.routeName);
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text('Home')
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          title: Text('Cart')
        ),
      ],
    );
  }
}