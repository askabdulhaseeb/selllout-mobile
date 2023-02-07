import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../database/auth_methods.dart';
import '../../../functions/user_bottom_sheets.dart';
import '../../../models/app_user.dart';
import '../../../models/product/product.dart';
import '../../../providers/provider.dart';
import '../../../widgets/custom_widgets/show_loading.dart';
import '../../../widgets/product/product_tile.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text('Sellout')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Consumer<ProductProvider>(
          builder: (BuildContext context, ProductProvider prodPro, _) {
            final List<Product> prods = prodPro.productsByUsers(
                Provider.of<UserProvider>(context, listen: false)
                    .user(uid: AuthMethods.uid));
            prods.shuffle();
            return prodPro.isLoading
                ? const ShowLoading()
                : ListView.separated(
                    shrinkWrap: true,
                    itemCount: prods.length + 1,
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(height: 8),
                    itemBuilder: (BuildContext context, int index) => prods
                                .length ==
                            index
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 48),
                            child: Column(
                              children: <Widget>[
                                const Icon(
                                  Icons.production_quantity_limits,
                                  size: 48,
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  'No More Products available to watch',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                Consumer<UserProvider>(builder:
                                    (BuildContext context, UserProvider userPro,
                                        _) {
                                  final AppUser me =
                                      userPro.user(uid: AuthMethods.uid);
                                  final List<AppUser> allUsers = userPro.users;
                                  final List<String> addableUser = <String>[];
                                  for (AppUser element in allUsers) {
                                    if ((!(me.blockedBy
                                                ?.contains(element.uid) ??
                                            false)) &&
                                        (!(me.supporters
                                                ?.contains(element.uid) ??
                                            false))) {
                                      addableUser.add(element.uid);
                                    }
                                  }
                                  return TextButton(
                                    onPressed: () {
                                      UserBottomSheets().showUsersBottomSheet(
                                          context: context,
                                          users: addableUser,
                                          title: 'Explore Users');
                                    },
                                    child: const Text(
                                      'Explore more',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  );
                                }),
                              ],
                            ),
                          )
                        : ProductTile(product: prods[index]),
                  );
          },
        ),
      ),
    );
  }
}
