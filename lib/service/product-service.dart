import 'package:dio/dio.dart';
import 'dart:async';
import 'package:sportsstore_flutter/model/product.dart';
import 'package:sportsstore_flutter/constants.dart';

final String url = '${Constants.PRODUCT_URL}';
final Dio dio = Dio(BaseOptions(connectTimeout: 5000, receiveTimeout: 15000));

Future<List<String>> getCategories() async {
  List<String> lx;

  try {
    var res = await dio.get('$url/categories');
    var data = res.data;
    var ls = data as List;
    lx = List<String>.from(ls);
  }

  catch (error) {
    throw(error);
  }

  return lx;
}

Future<List<Product>> getProducts([String category, int page = 1]) async {
  List<Product> lx;
  var _url = '$url/$page';

  if (category != null) {
    _url = '$url/$category/$page';
  }

  try {
    var res = await dio.get(_url);
    var data = res.data;
    var ls = data['products'] as List;
    lx = ls.map<Product>((x) => Product.fromJson(x)).toList();
  }

  catch (error) {
    throw(error);
  }

  return lx;
}