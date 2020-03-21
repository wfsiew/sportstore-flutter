import 'package:flutter/material.dart';
import 'dart:async';
import 'package:sportsstore_flutter/service/product-service.dart';
import 'package:sportsstore_flutter/helpers.dart';

class Category extends StatefulWidget {
  Category({Key key, this.title}) : super(key: key);

  static const String routeName = '/Category';

  final String title;

  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {

  List<String> ls = <String>[];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    try {
      setState(() {
       isLoading = true;
      });
      var lx = await getCategories();
      setState(() {
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

  Future<void> refreshData() async {
    try {
      var lx = await getCategories();
      ls.clear();
      setState(() {
       ls = lx; 
      });
    }
    
    catch(error) {
      handleError(context, error, () async {
        await refreshData();
      });
    }
  }

  Widget buildRow(String s) {
    return Card(
      child: ListTile(
        title: Text(
          '$s',
          style: TextStyle(
            fontSize: 18.0
          ),
        ),
        onTap: () {
          Navigator.pop(context, s);
        },
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
        itemCount: ls.length,
        itemBuilder: (context, i) {
          return buildRow(ls[i]);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: RefreshIndicator(
        onRefresh: refreshData,
        child: buildList(),
      ),
    );
  }
}