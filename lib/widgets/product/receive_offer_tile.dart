import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../enums/product/prod_offer_status.dart';
import '../../functions/time_date_functions.dart';
import '../../models/app_user.dart';
import '../../models/product/prod_offer.dart';
import '../../providers/provider.dart';
import '../../providers/user/user_provider.dart';
import '../custom_widgets/custom_elevated_button.dart';
import '../custom_widgets/custom_profile_image.dart';

class ReceivedOfferTile extends StatelessWidget {
  const ReceivedOfferTile({required this.pid, required this.offer, Key? key})
      : super(key: key);
  final String pid;
  final ProdOffer offer;

  @override
  Widget build(BuildContext context) {
    final AppUser user =
        Provider.of<UserProvider>(context, listen: false).user(uid: offer.uid);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CustomProfileImage(imageURL: user.imageURL ?? ''),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  user.displayName ?? '',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Consumer<ProductProvider>(builder:
                    (BuildContext context, ProductProvider prodPro, _) {
                  final ProdOffer liveOffer = prodPro
                      .product(pid)
                      .offers!
                      .firstWhere((ProdOffer element) =>
                          element.approvalTime == offer.approvalTime);
                  return liveOffer.status == ProdOfferStatusEnum.pending
                      ? Row(
                          children: <Widget>[
                            Expanded(
                              child: CustomElevatedButton(
                                title: 'Reject',
                                padding: const EdgeInsets.all(6),
                                bgColor: Colors.transparent,
                                textStyle: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 18,
                                ),
                                border: Border.all(
                                    color: Theme.of(context).primaryColor),
                                onTap: () async {
                                  final ProdOffer newOffer = liveOffer
                                    ..status = ProdOfferStatusEnum.rejected
                                    ..approvalTime =
                                        TimeDateFunctions.timestamp;
                                  await prodPro.updateOffer(
                                      pid: pid, newOffer: newOffer);
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: CustomElevatedButton(
                                title: 'Accept',
                                padding: const EdgeInsets.all(6),
                                onTap: () async{
                                  final ProdOffer newOffer = liveOffer
                                    ..status = ProdOfferStatusEnum.approved
                                    ..approvalTime =
                                        TimeDateFunctions.timestamp;
                                  await prodPro.updateOffer(
                                      pid: pid, newOffer: newOffer);
                                },
                              ),
                            ),
                          ],
                        )
                      : RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .color!
                                  .withOpacity(0.5),
                            ),
                            children: <TextSpan>[
                              const TextSpan(text: 'You '),
                              TextSpan(
                                text:
                                    '${ProdOfferStatusEnumConvertor.toMap(liveOffer.status)} ',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                  text: TimeDateFunctions.timeInWords(
                                      offer.approvalTime)),
                            ],
                          ),
                        );
                }),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '${offer.price} EUR',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                TimeDateFunctions.timeInWords(offer.orderTime),
                style: TextStyle(
                  color: Theme.of(context)
                      .textTheme
                      .bodyText1!
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
