import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../database/auction_api.dart';
import '../../database/auth_methods.dart';
import '../../models/app_user.dart';
import '../../models/auction/auction.dart';
import '../../providers/user/user_provider.dart';
import '../../screens/user_screens/others_profile.dart';
import '../custom_widgets/custom_profile_image.dart';
import 'auction_info_tile.dart';

class BidAppBar extends StatelessWidget {
  const BidAppBar({
    required this.auction,
    required this.users,
    required this.muted,
    required this.onMute,
    required this.onCameraSwitch,
    super.key,
  });
  final Auction auction;
  final List<int> users;
  final bool muted;
  final VoidCallback onMute;
  final VoidCallback onCameraSwitch;

  @override
  Widget build(BuildContext context) {
    final bool isBroadcaster = auction.uid == AuthMethods.uid;
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: AuctionAPI().streamAuction(auction: auction),
      builder: (
        BuildContext context,
        AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot,
      ) {
        final AppUser author = Provider.of<UserProvider>(context, listen: false)
            .user(uid: auction.uid);
        if (snapshot.hasData) {
          Auction auctionStream = Auction.fromDoc(snapshot.data!);
          return Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.3),
            ),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    isBroadcaster
                        ? _authorControllerButtons(context)
                        : GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute<OthersProfile>(
                                builder: (BuildContext context) =>
                                    OthersProfile(user: author),
                              ));
                            },
                            child: CustomProfileImage(
                              imageURL: author.imageURL ?? '',
                            ),
                          ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: isBroadcaster
                          ? Text(
                              auction.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute<OthersProfile>(
                                  builder: (BuildContext context) =>
                                      OthersProfile(user: author),
                                ));
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    author.displayName ?? 'null',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    auction.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: 150,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            width: 46,
                            height: 30,
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: Theme.of(context).primaryColor),
                            alignment: Alignment.center,
                            child: const FittedBox(
                              child: Text(
                                '30:00',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          Container(
                            width: 46,
                            height: 30,
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: Theme.of(context).primaryColor),
                            alignment: Alignment.center,
                            child: FittedBox(
                              child: Text(
                                users.length.toString(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: CircleAvatar(
                              radius: 16,
                              backgroundColor: Theme.of(context).primaryColor,
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                AuctionInfoTile(auction: auctionStream),
              ],
            ),
          );
        } else {
          return AuctionInfoTile(auction: auction);
        }
      },
    );
  }

  Row _authorControllerButtons(BuildContext context) {
    return Row(
      children: <Widget>[
        GestureDetector(
          onTap: onMute,
          child: CircleAvatar(
            radius: 18,
            backgroundColor: muted
                ? Theme.of(context).primaryColor
                : Theme.of(context).scaffoldBackgroundColor.withOpacity(0.3),
            child: Icon(
              muted ? Icons.mic_off : Icons.mic,
              color: muted
                  ? Colors.white
                  : Theme.of(context).textTheme.bodyText1!.color,
              size: 18.0,
            ),
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: onCameraSwitch,
          child: CircleAvatar(
            radius: 18,
            backgroundColor:
                Theme.of(context).scaffoldBackgroundColor.withOpacity(0.3),
            child: Icon(
              Icons.switch_camera,
              color: muted
                  ? Colors.white
                  : Theme.of(context).textTheme.bodyText1!.color,
              size: 18.0,
            ),
          ),
        ),
      ],
    );
  }
}
