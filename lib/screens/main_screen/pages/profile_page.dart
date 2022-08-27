import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../database/auth_methods.dart';
import '../../../models/app_user.dart';
import '../../../models/product/product.dart';
import '../../../providers/product/product_provider.dart';
import '../../../providers/user_provider.dart';
import '../../../widgets/product/grid_view_of_prod.dart';
import '../../../widgets/user/profile_header_widget.dart';
import '../../../widgets/user/profile_score_widget.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                padding: const EdgeInsets.only(top: 20, left: 20, bottom: 10),
                child: Text(
                  me.username!,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText1!.color,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              ProfileHeaderWidget(user: me),
              ProfileScoreWidget(user: me),
              Expanded(child: GridViewOfProducts(posts: prods)),
            ],
          );
        },
      ),
    );
  }
}
