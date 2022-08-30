import 'package:flutter/material.dart';

import '../../database/auth_methods.dart';
import '../../database/product_api.dart';
import '../../enums/product/prod_condition_enum.dart';
import '../../models/product/product.dart';
import '../../models/product/product_url.dart';

class ProductProvider extends ChangeNotifier {
  Future<void> report(Product product) async {
    final int index =
        _products.indexWhere((Product element) => element.pid == product.pid);
    if (index < 0) return;
    _products[index] = product;
    notifyListeners();
    await ProductAPI().report(product);
  }

  List<Product> userProducts(String uid) {
    final List<Product> temp = <Product>[];
    for (Product element in _products) {
      if (element.uid == uid) temp.add(element);
    }
    return temp;
  }

  Product product(String pid) {
    final int index =
        _products.indexWhere((Product element) => element.pid == pid);
    return (index < 0) ? _null : _products[index];
  }

  List<Product> _products = <Product>[];

  List<Product> get products => _products;

  Future<void> init() async {
    if (_products.isNotEmpty) return;
    await _load();
  }

  Future<void> refresh() async {
    await _load();
  }

  Future<void> _load() async {
    List<Product> temp = await ProductAPI().getProducts();
    _products = temp;
    notifyListeners();
  }

  Product get _null => Product(
        pid: '0',
        uid: AuthMethods.uid,
        title: AuthMethods.uid,
        prodURL: <ProductURL>[ProductURL(url: '', isVideo: false, index: 0)],
        thumbnail: '',
        condition: ProdConditionEnum.NEW,
        description: 'description',
        categories: <String>[''],
        subCategories: <String>[''],
        price: 0,
      );
}
