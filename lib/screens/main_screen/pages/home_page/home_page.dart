import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../database/auth_methods.dart';
import '../../../../models/product/product.dart';
import '../../../../providers/product/product_provider.dart';
import '../../../../widgets/product/product_tile.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Selllout')),
      body: Consumer<ProductProvider>(
        builder: (BuildContext context, ProductProvider prodPro, _) {
          log('Home');
          final List<Product> prods = prodPro.products;
          prods.shuffle();
          return ListView.separated(
            shrinkWrap: true,
            itemCount: prods.length,
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(thickness: 2),
            itemBuilder: (BuildContext context, int index) =>
                ProductTile(product: prods[index]),
          );
        },
      ),
    );
  }
}
