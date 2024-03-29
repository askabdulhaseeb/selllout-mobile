import 'package:flutter/foundation.dart';

import '../../database/auction_api.dart';
import '../../models/auction/auction.dart';

class AuctionProvider extends ChangeNotifier {
  AuctionProvider() {
    _load();
  }
  List<Auction> _auctions = <Auction>[];

  List<Auction> get auctions => <Auction>[..._auctions];

  init() async {
    if (_auctions.isNotEmpty) return;
    await _load();
    if (kDebugMode) {
      debugPrint(
          'Print: Auction Provider, No. of Auction: ${_auctions.length}');
    }
  }

  Future<void> refresh() async {
    await _load();
  }

  _load() async {
    _auctions = await AuctionAPI().getAllAuctions();
    notifyListeners();
  }
}
