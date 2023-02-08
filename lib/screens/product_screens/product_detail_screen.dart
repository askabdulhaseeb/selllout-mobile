import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../database/auth_methods.dart';
import '../../enums/product/prod_condition_enum.dart';
import '../../enums/product/prod_delivery_type.dart';
import '../../functions/report_bottom_sheets.dart';
import '../../functions/time_date_functions.dart';
import '../../functions/unique_id_functions.dart';
import '../../models/app_user.dart';
import '../../models/chat/chat.dart';
import '../../models/product/product.dart';
import '../../providers/user/user_provider.dart';
import '../../utilities/utilities.dart';
import '../../widgets/custom_widgets/custom_elevated_button.dart';
import '../../widgets/custom_widgets/custom_profile_image.dart';
import '../../widgets/custom_widgets/title_and_detail_widget.dart';
import '../../widgets/product/prod_urls_slider.dart';
import '../auth/phone_number_screen.dart';
import '../chat_screens/personal_chat_page/product_chat_screen.dart';
import '../user_screens/others_profile.dart';
import 'buy_now_screen.dart';
import 'make_offer_screen.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({required this.product, Key? key})
      : super(key: key);
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<UserProvider>(
          builder: (
            BuildContext context,
            UserProvider userPro,
            _,
          ) {
            final AppUser user = userPro.user(uid: product.uid);
            return ListTile(
              onTap: () {
                if (user.uid != AuthMethods.uid) {
                  Navigator.of(context).push(MaterialPageRoute<OthersProfile>(
                    builder: (BuildContext context) =>
                        OthersProfile(user: user),
                  ));
                }
              },
              leading: CustomProfileImage(
                imageURL: user.imageURL ?? '',
                radius: 46,
              ),
              title: Text(user.displayName ?? 'null'),
              subtitle: Text(
                TimeDateFunctions.timeInWords(product.timestamp ?? 0),
                style: const TextStyle(color: Colors.grey),
              ),
            );
          },
        ),
        actions: <Widget>[
          if (product.uid != AuthMethods.uid)
            IconButton(
              onPressed: () async {
                ReportBottomSheets().productReport(context, product);
              },
              icon: Icon(
                Icons.report,
                color: Theme.of(context).primaryColor,
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: Utilities.imageAspectRatio,
              child: ProductURLsSlider(urls: product.prodURL),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          product.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        product.price.toStringAsFixed(2),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      const Icon(
                        Icons.location_on,
                        color: Colors.grey,
                        size: 14,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        product.location!,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _ProductAdditionalInfo(product: product),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SelectableText(product.description),
            ),
            const SizedBox(height: 40),
            if (AuthMethods.uid != product.uid)
              _ButtonSection(product: product),
          ],
        ),
      ),
    );
  }
}

class _ProductAdditionalInfo extends StatelessWidget {
  const _ProductAdditionalInfo({
    required this.product,
    Key? key,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              TitleAndDetailWidget(
                title: 'Price',
                subtitle: product.price.toString(),
              ),
              TitleAndDetailWidget(
                title: 'Condition',
                subtitle: ProdConditionEnumConvertor.enumToString(
                    condition: product.condition),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              TitleAndDetailWidget(
                title: 'Delivery Fee',
                subtitle: product.deliveryFree.toString(),
              ),
              TitleAndDetailWidget(
                title: 'Type',
                subtitle: ProdDeliveryTypeEnumConvertor.enumToString(
                    delivery: product.delivery),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '${product.categories[0]}, ${product.subCategories[0]}',
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class _ButtonSection extends StatelessWidget {
  const _ButtonSection({required this.product, Key? key}) : super(key: key);
  final Product product;
  static const EdgeInsetsGeometry _padding = EdgeInsets.symmetric(vertical: 8);
  static const EdgeInsetsGeometry _margin = EdgeInsets.symmetric(vertical: 3);
  static const TextStyle _textStyle =
      TextStyle(color: Colors.white, fontSize: 16);
  @override
  Widget build(BuildContext context) {
    return product.uid == AuthMethods.uid
        ? const SizedBox()
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: CustomElevatedButton(
                        padding: _padding,
                        margin: _margin,
                        textStyle: _textStyle,
                        title: 'Buy Now',
                        onTap: () {
                          if (AuthMethods.getCurrentUser == null) {
                            Navigator.of(context)
                                .pushNamed(PhoneNumberScreen.routeName);
                            return;
                          }
                          Navigator.of(context)
                              .push(MaterialPageRoute<ProductChatScreen>(
                            builder: (BuildContext context) => BuyNowScreen(
                              product: product,
                            ),
                          ));
                        },
                      ),
                    ),
                    if (product.acceptOffers) const SizedBox(width: 16),
                    if (product.acceptOffers)
                      Expanded(
                        child: CustomElevatedButton(
                          padding: _padding,
                          margin: _margin,
                          textStyle: _textStyle,
                          title: 'Make Offer',
                          onTap: () {
                            if (AuthMethods.getCurrentUser == null) {
                              Navigator.of(context)
                                  .pushNamed(PhoneNumberScreen.routeName);
                            } else {
                              Navigator.of(context)
                                  .push(MaterialPageRoute<ProductChatScreen>(
                                builder: (BuildContext context) =>
                                    MakeOfferScreen(
                                  product: product,
                                ),
                              ));
                            }
                          },
                        ),
                      )
                  ],
                ),
                const SizedBox(height: 8),
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
                    if (AuthMethods.getCurrentUser == null) {
                      Navigator.of(context)
                          .pushNamed(PhoneNumberScreen.routeName);
                      return;
                    }
                    if (AuthMethods.uid == product.uid) return;
                    final AppUser user =
                        Provider.of<UserProvider>(context, listen: false)
                            .user(uid: product.uid);
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
