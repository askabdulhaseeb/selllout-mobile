import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/product/product.dart';
import '../../../providers/product/product_provider.dart';
import '../../../widgets/product/product_tile.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text('Selllout')),
      body: Consumer<ProductProvider>(
        builder: (BuildContext context, ProductProvider prodPro, _) {
          final List<Product> prods = prodPro.products;
          prods.shuffle();
          return ListView.separated(
            shrinkWrap: true,
            itemCount: prods.length,
            separatorBuilder: (BuildContext context, int index) => Divider(
              thickness: 4,
              color: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .color!
                  .withOpacity(0.08),
            ),
            itemBuilder: (BuildContext context, int index) =>
                ProductTile(product: prods[index]),
          );
        },
      ),
    );
  }
}
