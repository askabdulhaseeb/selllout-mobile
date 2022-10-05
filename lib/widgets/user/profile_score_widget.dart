import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../database/auth_methods.dart';
import '../../functions/user_bottom_sheets.dart';
import '../../models/app_user.dart';
import '../../models/product/product.dart';
import '../../providers/user/user_provider.dart';
import '../../screens/product_screens/user_products_screen.dart';
import '../custom_widgets/custom_icon_button.dart';
import '../custom_widgets/custom_toast.dart';

class ProfileScoreWidget extends StatelessWidget {
  const ProfileScoreWidget({
    required this.uid,
    required this.posts,
    Key? key,
  }) : super(key: key);
  final String uid;
  final List<Product> posts;

  @override
  Widget build(BuildContext context) {
    final double totalWidth = MediaQuery.of(context).size.width;
    final double boxWidth = (totalWidth / 4) - 14;

    return Builder(
      builder: (BuildContext context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Consumer<UserProvider>(
            builder: (BuildContext context, UserProvider userPro, _) {
          final AppUser user = userPro.user(uid: uid);
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              CustomIconButton(
                height: boxWidth - 10,
                width: boxWidth,
                icon: Icons.account_balance,
                onTap: () {
                  // TODO: on wallet click
                },
              ),
              _CustomScoreButton(
                score: posts.length.toString(),
                title: 'Posts',
                height: boxWidth - 10,
                width: boxWidth,
                onTap: () {
                  if (user.isPublicProfile == false &&
                      !(user.supporters?.contains(AuthMethods.uid) ?? true)) {
                    CustomToast.errorToast(
                        message: 'Only Supports can view posts');
                    return;
                  }
                  Navigator.of(context).push(
                    MaterialPageRoute<UserProductsScreen>(
                      builder: (_) =>
                          UserProductsScreen(products: posts, selectedIndex: 0),
                    ),
                  );
                },
              ),
              _CustomScoreButton(
                score: user.supporting?.length.toString() ?? '0',
                title: 'Supporting',
                height: boxWidth - 10,
                width: boxWidth,
                onTap: () => _isClickable(user)
                    ? UserBottomSheets().showUsersBottomSheet(
                        context: context,
                        title: 'Supportings',
                        users: user.supporting ?? <String>[],
                      )
                    : () {},
              ),
              _CustomScoreButton(
                score: user.supporters?.length.toString() ?? '0',
                title: 'Supporters',
                height: boxWidth - 10,
                width: boxWidth,
                onTap: () => _isClickable(user)
                    ? UserBottomSheets().showUsersBottomSheet(
                        title: 'Supporters',
                        context: context,
                        users: user.supporters ?? <String>[],
                      )
                    : () {},
              ),
            ],
          );
        }),
      ),
    );
  }

  bool _isClickable(AppUser user) {
    if (user.uid == AuthMethods.uid) return true;
    if (user.isPublicProfile == true) return true;
    if (user.supporters?.contains(AuthMethods.uid) ?? false) return true;
    return false;
  }
}

class _CustomScoreButton extends StatelessWidget {
  const _CustomScoreButton({
    required this.onTap,
    required this.height,
    required this.width,
    required this.score,
    required this.title,
    // ignore: unused_element
    this.borderRadius,
    Key? key,
  }) : super(key: key);
  final VoidCallback onTap;
  final double height;
  final double width;
  final String score;
  final String title;
  final BorderRadius? borderRadius;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: borderRadius ?? BorderRadius.circular(10),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius ?? BorderRadius.circular(10),
        child: Container(
          height: height,
          width: width,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                score,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                  fontSize: 18,
                ),
              ),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 9),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
