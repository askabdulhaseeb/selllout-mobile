import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/product/product_provider.dart';
import '../../../widgets/custom_widgets/custom_shadow_bg_widget.dart';
import '../../../widgets/product/grid_view_of_prod.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            CustomShadowBgWidget(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.explore_outlined,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Explore',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    )
                  ],
                ),
              ),
            ),
            CustomShadowBgWidget(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 16),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: CupertinoSearchTextField(
                            prefixIcon: const Icon(CupertinoIcons.search),
                            onChanged: (String? value) {},
                          ),
                        ),
                        const SizedBox(width: 10),
                        const CustomShadowBgWidget(
                          child: Padding(
                            padding: EdgeInsets.all(4),
                            child: Icon(Icons.filter_alt_outlined),
                          ),
                        ),
                      ],
                    ),
                    GridViewOfProducts(
                      posts: Provider.of<ProductProvider>(context).products,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
