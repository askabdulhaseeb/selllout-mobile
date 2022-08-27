import 'package:flutter/material.dart';

import '../../database/product_api.dart';
import '../../models/product/product.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> _products = <Product>[];

  List<Product> get products => _products;

  Future<void> init() async {
    await _load();
  }

  Future<void> _load() async {
    List<Product> _temp = await ProductAPI().getProducts();
    _products = _temp;
    notifyListeners();
  }
}
