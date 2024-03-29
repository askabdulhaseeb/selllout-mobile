import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../models/product/product.dart';
import '../../providers/user/user_provider.dart';
import '../../widgets/product/product_tile.dart';

class UserProductsScreen extends StatefulWidget {
  const UserProductsScreen({
    required this.products,
    required this.selectedIndex,
    Key? key,
  }) : super(key: key);
  final int selectedIndex;
  final List<Product> products;

  @override
  State<UserProductsScreen> createState() => _UserProductsScreenState();
}

class _UserProductsScreenState extends State<UserProductsScreen> {
  final ItemScrollController controller = ItemScrollController();
  // final ItemPositionsListener itemPositionsListener =
  //     ItemPositionsListener.create();

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback(
        (_) => controller.jumpTo(index: widget.selectedIndex));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Consumer<UserProvider>(builder: (
          BuildContext context,
          UserProvider userPro,
          _,
        ) {
          return Column(
            children: <Widget>[
              Text(
                  userPro
                          .user(uid: widget.products[widget.selectedIndex].uid)
                          .username ??
                      'null',
                  style: const TextStyle(color: Colors.grey, fontSize: 10)),
              const Text(
                'Products',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          );
        }),
      ),
      body: ScrollablePositionedList.separated(
        shrinkWrap: true,
        itemCount: widget.products.length,
        itemScrollController: controller,
        // itemPositionsListener: itemPositionsListener,
        separatorBuilder: (BuildContext context, int index) => Divider(
          thickness: 4,
          color:
              Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.08),
        ),
        itemBuilder: (BuildContext context, int index) => ProductTile(
          product: widget.products[index],
        ),
      ),
    );
  }
}
