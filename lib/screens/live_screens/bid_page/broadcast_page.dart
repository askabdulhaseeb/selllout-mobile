import 'package:agora_rtc_engine/rtc_engine.dart';
// ignore: library_prefixes
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
// ignore: library_prefixes
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../database/auction_api.dart';
import '../../../database/auth_methods.dart';
import '../../../functions/time_date_functions.dart';
import '../../../models/app_user.dart';
import '../../../models/auction/auction.dart';
import '../../../models/auction/bet.dart';
import '../../../providers/provider.dart';
import '../../../utilities/custom_validator.dart';
import '../../../utilities/utilities.dart';
import '../../../widgets/custom_widgets/custom_elevated_button.dart';
import '../../../widgets/custom_widgets/custom_profile_image.dart';
import '../../../widgets/custom_widgets/custom_score_button.dart';
import '../../../widgets/custom_widgets/custom_textformfield.dart';

class BroadcastPage extends StatefulWidget {
  const BroadcastPage({required this.auction, Key? key}) : super(key: key);
  final Auction auction;

  @override
  // ignore: library_private_types_in_public_api
  _BroadcastPageState createState() => _BroadcastPageState();
}

class _BroadcastPageState extends State<BroadcastPage> {
  final List<int> _users = <int>[];
  final List<String> _infoStrings = <String>[];
  RtcEngine? _engine;
  bool muted = false;
  String appId = Utilities.agoraID;
  final String me = AuthMethods.uid;
  late bool isBroadcaster = AuthMethods.uid == widget.auction.uid;

  @override
  void dispose() async {
    _users.clear();
    _engine!.destroy();
    if (me == widget.auction.uid) {
      widget.auction.isActive = false;
      await AuctionAPI().updateActivity(auction: widget.auction);
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    if (appId.isEmpty) {
      setState(() {
        _infoStrings.add(
          'APP_ID missing, please provide your APP_ID in settings.dart',
        );
        _infoStrings.add('Agora Engine is not starting');
      });
      return;
    }
    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    await _engine!.joinChannel(null, widget.auction.auctionID, null, 0);
  }

  Future<void> _initAgoraRtcEngine() async {
    _engine = await RtcEngine.create(appId);
    await _engine!.enableVideo();
    await _engine!.setChannelProfile(ChannelProfile.LiveBroadcasting);
    if (me == widget.auction.uid) {
      await _engine!.setClientRole(ClientRole.Broadcaster);
    } else {
      await _engine!.setClientRole(ClientRole.Audience);
    }
  }

  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    _engine!.setEventHandler(RtcEngineEventHandler(error: (ErrorCode code) {
      setState(() {
        final String info = 'onError: $code';
        _infoStrings.add(info);
      });
    }, joinChannelSuccess: (String channel, int uid, int elapsed) {
      setState(() {
        final String info = 'onJoinChannel: $channel, uid: $uid';
        _infoStrings.add(info);
      });
    }, leaveChannel: (RtcStats stats) {
      setState(() {
        _infoStrings.add('onLeaveChannel');
        _users.clear();
        Navigator.pop(context);
      });
    }, userJoined: (int uid, int elapsed) {
      setState(() {
        final String info = 'userJoined: $uid';
        _infoStrings.add(info);
        _users.add(uid);
      });
    }, userOffline: (int uid, UserOfflineReason elapsed) {
      setState(() {
        final String info = 'userOffline: $uid';
        _infoStrings.add(info);
        _users.remove(uid);
        Navigator.pop(context);
      });
    }, firstRemoteVideoFrame: (int uid, int width, int height, int elapsed) {
      setState(() {
        final String info = 'firstRemoteVideo: $uid ${width}x $height';
        _infoStrings.add(info);
      });
    }));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Stack(
            children: <Widget>[
              _viewRows(),
              _toolbar(),
              Positioned(
                top: 50,
                right: 16,
                left: 16,
                child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: AuctionAPI().streamAuction(auction: widget.auction),
                  builder: (
                    BuildContext context,
                    AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                        snapshot,
                  ) {
                    if (snapshot.hasData) {
                      Auction auctionStream = Auction.fromDoc(snapshot.data!);
                      return _AuctionInfo(auction: auctionStream);
                    } else {
                      return _AuctionInfo(auction: widget.auction);
                    }
                  },
                ),
              ),
              if (!isBroadcaster)
                Positioned(
                  top: 6,
                  left: 20,
                  child: IconButton(
                    splashRadius: 1,
                    onPressed: () => Navigator.of(context).pop(),
                    icon: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white54,
                      child: Icon(
                        Icons.adaptive.arrow_back,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              if (!isBroadcaster)
                Positioned(
                  bottom: 48,
                  left: 16,
                  right: 16,
                  child: NewBitValue(auction: widget.auction),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _toolbar() {
    return me == widget.auction.uid
        ? Container(
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.symmetric(vertical: 48),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RawMaterialButton(
                  onPressed: _onToggleMute,
                  shape: const CircleBorder(),
                  elevation: 2.0,
                  fillColor: muted ? Colors.blueAccent : Colors.white,
                  padding: const EdgeInsets.all(12.0),
                  child: Icon(
                    muted ? Icons.mic_off : Icons.mic,
                    color: muted ? Colors.white : Colors.blueAccent,
                    size: 20.0,
                  ),
                ),
                RawMaterialButton(
                  onPressed: () => _onCallEnd(context),
                  shape: const CircleBorder(),
                  elevation: 2.0,
                  fillColor: Colors.redAccent,
                  padding: const EdgeInsets.all(15.0),
                  child: const Icon(
                    Icons.call_end,
                    color: Colors.white,
                    size: 35.0,
                  ),
                ),
                RawMaterialButton(
                  onPressed: _onSwitchCamera,
                  shape: const CircleBorder(),
                  elevation: 2.0,
                  fillColor: Colors.white,
                  padding: const EdgeInsets.all(12.0),
                  child: const Icon(
                    Icons.switch_camera,
                    color: Colors.blueAccent,
                    size: 20.0,
                  ),
                ),
              ],
            ),
          )
        : const SizedBox();
  }

  /// Video layout wrapper
  Widget _viewRows() {
    final List<Widget> views = _getRenderViews();
    switch (views.length) {
      case 1:
        return Column(
          children: <Widget>[_videoView(views[0])],
        );
      case 2:
        return Column(
          children: <Widget>[
            _expandedVideoRow([views[0]]),
            _expandedVideoRow([views[1]])
          ],
        );
      case 3:
        return Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 3))
          ],
        );
      case 4:
        return Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 4))
          ],
        );
      default:
        return const Center(
          child: Text('Not Connected : Might take few mints'),
        );
    }
  }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final List<StatefulWidget> list = [];
    if (me == widget.auction.uid) {
      list.add(const RtcLocalView.SurfaceView());
    }
    for (int uid in _users) {
      list.add(RtcRemoteView.SurfaceView(
          channelId: widget.auction.auctionID, uid: uid));
    }
    return list;
  }

  /// Video view wrapper
  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final List<Widget> wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  void _onCallEnd(BuildContext context) {
    widget.auction.isActive = false;
    Navigator.pop(context);
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    _engine!.muteLocalAudioStream(muted);
  }

  void _onSwitchCamera() {
    _engine!.switchCamera();
  }
}

class _AuctionInfo extends StatelessWidget {
  const _AuctionInfo({required this.auction, Key? key}) : super(key: key);
  final Auction auction;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            CustomScoreButton(
              score: auction.bets!.length.toString(),
              title: 'No. of Bets',
              height: 60,
              width: 90,
              onTap: () {},
            ),
            CustomScoreButton(
              score: auction.startingPrice.toString(),
              title: 'Starting price',
              height: 60,
              width: 90,
              onTap: () {},
            ),
            CustomScoreButton(
              score: auction.bets!.isEmpty
                  ? auction.startingPrice.toString()
                  : auction.bets![auction.bets!.length - 1].amount.toString(),
              title: 'New Price',
              height: 60,
              width: 90,
              onTap: () {},
            ),
          ],
        ),
        const SizedBox(height: 10),
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
                          Provider.of<UserProvider>(context).user(uid: bet.uid);
                      return ListTile(
                        leading:
                            CustomProfileImage(imageURL: user.imageURL ?? ''),
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
    );
  }
}

class NewBitValue extends StatefulWidget {
  const NewBitValue({required this.auction, Key? key}) : super(key: key);
  final Auction auction;

  @override
  State<NewBitValue> createState() => _NewBitValueState();
}

class _NewBitValueState extends State<NewBitValue> {
  final TextEditingController _offer = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final bool _isLoading = false;

  @override
  void initState() {
    _offer.text = widget.auction.bets!.isEmpty
        ? widget.auction.startingPrice.toString()
        : widget.auction.bets![widget.auction.bets!.length - 1].amount
            .toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _key,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                onPressed: () {
                  if (_offer.text == widget.auction.startingPrice.toString())
                    return;
                  double value = double.parse(_offer.text);
                  value -= 1;
                  _offer.text = value.toString();
                  setState(() {});
                },
                splashRadius: 20,
                icon: const Icon(
                  Icons.remove_circle,
                  color: Colors.red,
                ),
              ),
              Flexible(
                child: CustomTextFormField(
                  controller: _offer,
                  readOnly: _isLoading,
                  textAlign: TextAlign.center,
                  showSuffixIcon: false,
                  validator: (String? value) => CustomValidator.greaterThen(
                    value,
                    widget.auction.startingPrice,
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  double value = double.parse(_offer.text);
                  value += 1;
                  _offer.text = value.toString();
                  setState(() {});
                },
                splashRadius: 20,
                icon: const Icon(
                  Icons.add_circle_outlined,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          CustomElevatedButton(
              title: 'Send Bit',
              onTap: () async {
                if (_key.currentState!.validate()) {
                  final Bet newBet = Bet(
                    uid: AuthMethods.uid,
                    amount: double.parse(_offer.text),
                    timestamp: TimeDateFunctions.timestamp,
                  );
                  widget.auction.bets!.add(newBet);
                  await AuctionAPI().updateBet(auction: widget.auction);
                }
              }),
        ],
      ),
    );
  }
}
