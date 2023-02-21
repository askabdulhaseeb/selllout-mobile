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
import '../../widgets/custom_widgets/custom_search_field.dart';
import '../../widgets/custom_widgets/sub_app_bar.dart';


class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double cardHeight  = 60;

    return Scaffold(
      appBar: const CustomAppBar(showBackButton: false,),
      body: Consumer2<UserProvider, ProductProvider>(
        builder: (
            BuildContext context,
            UserProvider userPro,
            ProductProvider prodPro,
            _,
            ) {
          final AppUser me = userPro.user(uid: AuthMethods.uid);
          final List<Product> prods = prodPro.userProducts(AuthMethods.uid);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[


              const Center(child: SizedBox(width: 200, child: SubAppBar(title: 'Explore', showBack: false,showIcon: true,))),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeDefault),
                child: CustomSearchField(
                  controller: searchController,
                  hint: 'Search Here',
                  prefix: Icons.search,
                  isFilter: true,
                  iconPressed: () {  },
                ),
              ),

              Expanded(child: GridViewOfProducts(posts: prods)),
            ],
          );
        },
      ),
    );
  }
}
