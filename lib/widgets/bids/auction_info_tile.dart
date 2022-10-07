import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../database/auth_methods.dart';
import '../../models/app_user.dart';
import '../../models/auction/auction.dart';
import '../../models/auction/bet.dart';
import '../../providers/user/user_provider.dart';
import '../custom_widgets/custom_profile_image.dart';
import '../custom_widgets/custom_score_button.dart';

class AuctionInfoTile extends StatelessWidget {
  const AuctionInfoTile({required this.auction, Key? key}) : super(key: key);
  final Auction auction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                CustomScoreButton(
                  score: auction.bets!.length.toString(),
                  title: 'No. of Bets',
                  onTap: () {},
                ),
                CustomScoreButton(
                  score: auction.startingPrice.toString(),
                  title: 'Starting price',
                  onTap: () {},
                ),
                CustomScoreButton(
                  score: auction.bets!.isEmpty
                      ? auction.startingPrice.toString()
                      : auction.bets![auction.bets!.length - 1].amount
                          .toString(),
                  title: 'New Price',
                  onTap: () {},
                ),
              ],
            ),
          ),
          if (auction.uid == AuthMethods.uid)
            auction.bets!.isEmpty
                ? const SizedBox()
                : SizedBox(
                    height: 100,
                    child: ListView.builder(
                        itemCount: auction.bets!.length == 1 ? 1 : 2,
                        itemBuilder: (BuildContext context, int index) {
                          final Bet bet = auction.bets![auction.bets!.length < 2
                              ? index
                              : auction.bets!.length - index - 1];
                          final AppUser user =
                              Provider.of<UserProvider>(context)
                                  .user(uid: bet.uid);
                          return ListTile(
                            leading: CustomProfileImage(
                                imageURL: user.imageURL ?? ''),
                            title: Text(
                              user.displayName ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: Text(
                              bet.amount.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          );
                        }),
                  )
        ],
      ),
    );
  }
}
