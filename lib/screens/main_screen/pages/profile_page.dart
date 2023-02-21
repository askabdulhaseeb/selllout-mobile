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


class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double cardHeight  = 50;

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
              Padding(
                padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault,0),
                child: Container(
                    padding: const EdgeInsets.symmetric(vertical : 7),
                    decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(.25), spreadRadius: 1, blurRadius: 5, offset: Offset(1,2))]
                    ),
                    child: ProfileHeaderWidget(user: me)),
              ),

              ProfileScoreWidget(uid: me.uid, posts: prods),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
                child: Container(child: Row(children: [

                  Container(width: cardHeight,height: cardHeight,
                  padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(Dimensions.fontSizeExtraSmall)
                  ),
                  child: Image.asset(AppImages.shopIcon),),
                  Expanded(child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                    child: Container(height: cardHeight,

                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(Dimensions.fontSizeExtraSmall)
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: Container(width: 40,height: 50,
                                decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(Dimensions.fontSizeExtraSmall),
                                        bottomLeft: Radius.circular(Dimensions.fontSizeExtraSmall))
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(Dimensions.paddingSize),
                                  child: Image.asset(AppImages.carIcon,scale: 4),
                                )),
                          ),
                          const SizedBox(width: Dimensions.paddingSizeSmall,),
                          Expanded(child: Text('Category', style: textBold.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeLarge),)),


                          const Padding(
                            padding: EdgeInsets.all(Dimensions.paddingSize),
                            child: Icon(Icons.keyboard_arrow_down_outlined, color: Colors.white),
                          )
                        ],
                      ),),
                  ),),
                  Container(width: cardHeight,height: cardHeight,
                    padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(Dimensions.fontSizeExtraSmall)
                    ),
                    child: Image.asset(AppImages.cartIcon),),


                ],),),
              ),

              Expanded(child: GridViewOfProducts(posts: prods)),
            ],
          );
        },
      ),
    );
  }
}
