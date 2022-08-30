import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../database/auth_methods.dart';
import '../../functions/report_bottom_sheets.dart';
import '../../functions/time_date_functions.dart';
import '../../functions/unique_id_functions.dart';
import '../../models/app_user.dart';
import '../../models/chat/chat.dart';
import '../../models/product/product.dart';
import '../../providers/app_provider.dart';
import '../../providers/user_provider.dart';
import '../../screens/chat_screens/personal_chat_page/product_chat_screen.dart';
import '../../screens/others_profile/others_profile.dart';
import '../../utilities/utilities.dart';
import '../custom_widgets/custom_elevated_button.dart';
import '../custom_widgets/custom_profile_image.dart';
import 'custom_slideable_urls_tile.dart';

class ProductTile extends StatelessWidget {
  const ProductTile({required this.product, Key? key}) : super(key: key);
  final Product product;

  @override
  Widget build(BuildContext context) {
    final AppUser user =
        Provider.of<UserProvider>(context).user(uid: product.uid);
    return Column(
      children: <Widget>[
        _Header(product: product, user: user),
        AspectRatio(
          aspectRatio: Utilities.imageAspectRatio,
          child: ProductURLsSlider(urls: product.prodURL),
        ),
        _InfoCard(product: product),
        _ButtonSection(user: user, product: product),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.product, Key? key}) : super(key: key);
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      product.title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    product.price.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: const <Widget>[
                  Icon(
                    Icons.location_on,
                    color: Colors.grey,
                    size: 12,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Location here',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  )
                ],
              ),
              const SizedBox(height: 8),
              Text(
                product.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _ButtonSection extends StatelessWidget {
  const _ButtonSection({required this.user, required this.product, Key? key})
      : super(key: key);
  final AppUser user;
  final Product product;
  static const EdgeInsetsGeometry _padding = EdgeInsets.symmetric(vertical: 8);
  static const EdgeInsetsGeometry _margin = EdgeInsets.symmetric(vertical: 3);
  static const TextStyle _textStyle =
      TextStyle(color: Colors.white, fontSize: 16);
  @override
  Widget build(BuildContext context) {
    return user.uid == AuthMethods.uid
        ? const SizedBox()
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: <Widget>[
                CustomElevatedButton(
                  padding: _padding,
                  margin: _margin,
                  textStyle: _textStyle,
                  title: 'Buy Now',
                  onTap: () {
                    if (user.displayName == null || user.displayName == '') {
                      return;
                    }
                    // Navigator.of(context)
                    //     .push(MaterialPageRoute<ProductChatScreen>(
                    //   builder: (BuildContext context) => BuyNowScreen(
                    //     product: product,
                    //   ),
                    // ));
                  },
                ),
                product.acceptOffers
                    ? CustomElevatedButton(
                        padding: _padding,
                        margin: _margin,
                        textStyle: _textStyle,
                        title: 'Make Offer',
                        onTap: () {
                          // Navigator.of(context)
                          //     .push(MaterialPageRoute<ProductChatScreen>(
                          //   builder: (BuildContext context) => MakeOfferScreen(
                          //     product: product,
                          //     user: user,
                          //   ),
                          // ));
                        },
                      )
                    : const SizedBox(),
                CustomElevatedButton(
                  padding: _padding,
                  margin: _margin,
                  bgColor: Colors.transparent,
                  border: Border.all(color: Theme.of(context).primaryColor),
                  textStyle: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: 'Message Seller',
                  onTap: () {
                    if (user.displayName == null || user.displayName == '') {
                      return;
                    }
                    Navigator.of(context)
                        .push(MaterialPageRoute<ProductChatScreen>(
                      builder: (BuildContext context) => ProductChatScreen(
                        chatWith: user,
                        chat: Chat(
                          chatID: UniqueIdFunctions.productID(product.pid),
                          persons: <String>[
                            AuthMethods.uid,
                            product.uid,
                          ],
                          pid: product.pid,
                          prodIsVideo: product.prodURL[0].isVideo,
                        ),
                        product: product,
                      ),
                    ));
                  },
                ),
              ],
            ),
          );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.product, required this.user, Key? key})
      : super(key: key);
  final Product product;
  final AppUser user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: GestureDetector(
        onTap: () {
          user.uid == AuthMethods.uid
              ? Provider.of<AppProvider>(context, listen: false).onTabTapped(4)
              : Navigator.of(context).push(
                  MaterialPageRoute<OthersProfile>(
                    builder: (BuildContext context) =>
                        OthersProfile(user: user),
                  ),
                );
        },
        child: Row(
          children: <Widget>[
            CustomProfileImage(imageURL: user.imageURL ?? ''),
            const SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  user.displayName ?? 'Not Found',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  TimeDateFunctions.timeInWords(product.timestamp ?? 0),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const Spacer(),
            IconButton(
              onPressed: () {
                ReportBottomSheets().productReport(context, product);
                // TODO: Notification Seller Button click
                // showInfoDialog(
                //   context,
                //   title: 'Next Milestone',
                //   message: 'This is a part of next milestone',
                // );
              },
              icon: const Icon(Icons.more_vert_outlined),
            )
          ],
        ),
      ),
    );
  }
}
