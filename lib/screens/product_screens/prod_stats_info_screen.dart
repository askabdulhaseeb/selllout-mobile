import 'package:flutter/material.dart';

import '../../models/product/prod_offer.dart';
import '../../models/product/prod_order.dart';
import '../../models/product/product.dart';
import '../../widgets/product/receive_offer_tile.dart';
import '../../widgets/product/receive_order_tile.dart';

class ProductStatsInfoScreen extends StatefulWidget {
  const ProductStatsInfoScreen({required this.product, Key? key})
      : super(key: key);
  final Product product;

  @override
  State<ProductStatsInfoScreen> createState() => _ProductStatsInfoScreenState();
}

class _ProductStatsInfoScreenState extends State<ProductStatsInfoScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> tabs = <Widget>[
      Tab(
        child: Text(
          'Offers',
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyText1!.color,
            fontSize: 18,
          ),
        ),
      ),
      Tab(
        child: Text(
          'Orders',
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyText1!.color,
            fontSize: 18,
          ),
        ),
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Statistics'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Theme.of(context).primaryColor,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorPadding: EdgeInsets.zero,
          padding: EdgeInsets.zero,
          tabs: tabs,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          widget.product.offers!.isEmpty
              ? const Center(child: Text('No offer available to show'))
              : ListView.builder(
                  itemCount: widget.product.offers!.length,
                  itemBuilder: (BuildContext context, int index) {
                    final ProdOffer offer = widget.product.offers![index];
                    return ReceivedOfferTile(
                      pid: widget.product.pid,
                      offer: offer,
                    );
                  }),
          widget.product.orders!.isEmpty
              ? const Center(child: Text('No Order available to show'))
              : ListView.builder(
                  itemCount: widget.product.orders!.length,
                  itemBuilder: (BuildContext context, int index) {
                    final ProdOrder order = widget.product.orders![index];
                    return ReceivedOrderTile(order: order);
                  }),
        ],
      ),
    );
  }
}
