import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../functions/time_date_functions.dart';
import '../../../models/auction/auction.dart';
import '../../../providers/auction/auction_provider.dart';
import '../../../widgets/custom_widgets/custom_profile_image.dart';
import 'auction_detail_screen.dart';
import 'broadcast_page.dart';
import 'go_live_page.dart';

class BidPage extends StatelessWidget {
  const BidPage({Key? key}) : super(key: key);

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
              Text(
                'Live Bid',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              TextButton.icon(
                icon: const Icon(Icons.add, size: 18),
                onPressed: () {
                  Navigator.of(context).pushNamed(GoLivePage.routeName);
                },
                label: const Text('Go Live'),
              ),
            ],
          ),
          Expanded(
            child: Consumer<AuctionProvider>(
                builder: (BuildContext context, AuctionProvider auctionPro, _) {
              List<Auction> auctions = auctionPro.auctions;
              return RefreshIndicator(
                child: auctionPro.auctions.isEmpty
                    ? const Center(child: Text('No Bid Available'))
                    : ListView.builder(
                        itemCount: auctions.length,
                        itemBuilder: (BuildContext context, int index) =>
                            ListTile(
                          onTap: () async {
                            await <Permission>[
                              Permission.camera,
                              Permission.microphone
                            ].request();
                            // ignore: use_build_context_synchronously
                            Navigator.of(context).push(
                              MaterialPageRoute<BroadcastPage>(
                                builder: (_) => BroadcastPage(
                                  auction: auctions[index],
                                ),
                              ),
                            );
                            // ignore: use_build_context_synchronously
                            // Navigator.of(context).push(
                            //   MaterialPageRoute<AuctionDetailScreen>(
                            //     builder: (_) => AuctionDetailScreen(
                            //       auction: auctions[index],
                            //     ),
                            //   ),
                            // );
                          },
                          leading: CustomProfileImage(
                            imageURL: auctions[index].thumbnail,
                          ),
                          title: Text(auctions[index].name),
                          subtitle: Text(
                            TimeDateFunctions.timeInWords(
                              auctions[index].timestamp,
                            ),
                          ),
                        ),
                      ),
                onRefresh: () => auctionPro.refresh(),
              );
            }),
          ),
        ],
      ),
    );
  }
}
