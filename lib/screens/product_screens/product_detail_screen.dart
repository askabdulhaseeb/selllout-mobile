import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../database/auth_methods.dart';
import '../../enums/product/prod_condition_enum.dart';
import '../../enums/product/prod_delivery_type.dart';
import '../../models/app_user.dart';
import '../../models/product/product.dart';
import '../../providers/user/user_provider.dart';
import '../../utilities/utilities.dart';
import '../../widgets/custom_widgets/custom_profile_image.dart';
import '../../widgets/custom_widgets/custom_rating_bar.dart';
import '../../widgets/custom_widgets/title_and_detail_widget.dart';
import '../../widgets/product/prod_urls_slider.dart';
import '../user_screens/others_profile.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({required this.product, Key? key})
      : super(key: key);
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Details')),
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
                  Text(
                    product.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  // Row(
                  //     children: <Widget>[
                  //       const Icon(
                  //         Icons.location_on,
                  //         color: Colors.grey,
                  //         size: 14,
                  //       ),
                  //       const SizedBox(width: 6),
                  //       Text(
                  //         product.location!,
                  //         style: const TextStyle(color: Colors.grey),
                  //       ),
                  //     ],
                  //   ),
                ],
              ),
            ),
            Consumer<UserProvider>(builder: (
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
                subtitle: CustomRatingBar(
                  initialRating: user.rating ?? 0,
                  onRatingUpdate: (double value) {},
                ),
              );
            }),
            _ProductAdditionalInfo(product: product),
            const Divider(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'About Product',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SelectableText(product.description),
            ),
            const SizedBox(height: 40),
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
