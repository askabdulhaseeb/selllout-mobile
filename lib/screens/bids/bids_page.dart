import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../database/auth_methods.dart';
import '../../../models/app_user.dart';
import '../../../models/product/product.dart';
import '../../../providers/product/product_provider.dart';
import '../../../providers/user/user_provider.dart';
import '../../../utilities/app_image.dart';
import '../../../utilities/dimensions.dart';
import '../../../utilities/styles.dart';
import '../../../widgets/custom_widgets/custom_app_bar.dart';
import '../../../widgets/product/grid_view_of_prod.dart';
import '../../../widgets/user/profile_header_widget.dart';
import '../../../widgets/user/profile_score_widget.dart';
import '../../widgets/custom_widgets/custom_image.dart';
import '../../widgets/custom_widgets/custom_search_field.dart';
import '../../widgets/custom_widgets/sub_app_bar.dart';


class BidsPage extends StatefulWidget {
  BidsPage({Key? key}) : super(key: key);

  @override
  State<BidsPage> createState() => _BidsPageState();
}

class _BidsPageState extends State<BidsPage>  with TickerProviderStateMixin{

  TextEditingController searchController = TextEditingController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2,
        initialIndex: 0,vsync: this);

    _tabController?.addListener((){
      print('my index is${_tabController.index}');
    });
  }



  @override
  Widget build(BuildContext context) {
    double cardHeight  = 60;

    return Scaffold(
      appBar: const CustomAppBar(showBackButton: false,),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[


          const Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
              child: SubAppBar(title: 'Bids & Offers',)),


          TabBar(
            isScrollable: true,
            padding: const EdgeInsets.symmetric(horizontal: 3),
            controller: _tabController,
            indicatorColor: Theme.of(context).primaryColor,
            indicator: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(10)),
            labelColor: Colors.white,
            unselectedLabelColor: Theme.of(context).textTheme.bodyLarge!.color,
            unselectedLabelStyle: textRegular.copyWith(color: Theme.of(context).disabledColor,
                fontSize: Dimensions.fontSizeDefault),
            labelStyle: textRegular.copyWith(fontSize: Dimensions.fontSizeLarge,
                color: Theme.of(context).primaryColor),
            tabs: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                child: Tab(text: 'Bids Won'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                child: Tab(text: 'Bids Didn\'t win'),
              ),

            ],
          ),

          CustomSearchField(
              controller: searchController,
              hint: 'Search Here',
              prefix: Icons.search,
              iconPressed: (){}),

          Expanded(child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: 13,
                itemBuilder: (BuildContext context, int index){
                  return Padding(
                    padding: const EdgeInsets.all( 8.0),
                    child: Container(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                      decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(.2), blurRadius: 3,spreadRadius: 3)]
                      ),
                      child: Row(children: [
                        CustomImage(image: '',width: 40,height: 40,),

                        const SizedBox(width: Dimensions.paddingSizeDefault,),
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                            Text('Sneakers', style: textMedium.copyWith(fontSize: Dimensions.fontSizeLarge),),
                            Text('26/10/2022', style: textRegular.copyWith(color: Theme.of(context).hintColor),),
                          ],),
                        ),
                        Text('\$323.44', style: textBold.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeLarge),),
                      ],),
                    ),
                  );

                }),
          ))

        ],
      ),
    );
  }
}
