import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../functions/time_date_functions.dart';
import '../../models/app_user.dart';
import '../../models/product/prod_order.dart';
import '../../providers/user/user_provider.dart';
import '../custom_widgets/custom_profile_image.dart';

class ReceivedOrderTile extends StatelessWidget {
  const ReceivedOrderTile({required this.order, Key? key}) : super(key: key);

  final ProdOrder order;

  @override
  Widget build(BuildContext context) {
    final AppUser user =
        Provider.of<UserProvider>(context, listen: false).user(uid: order.uid);
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 12,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CustomProfileImage(imageURL: user.imageURL ?? ''),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              user.displayName ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '${order.price} EUR',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                TimeDateFunctions.timeInWords(order.orderTime),
                style: TextStyle(
                  color: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .color!
                      .withOpacity(0.4),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
