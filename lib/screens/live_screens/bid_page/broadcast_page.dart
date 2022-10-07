import 'package:agora_rtc_engine/rtc_engine.dart';
// ignore: library_prefixes
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
// ignore: library_prefixes
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:flutter/material.dart';

import '../../../database/auction_api.dart';
import '../../../database/auth_methods.dart';
import '../../../models/auction/auction.dart';
import '../../../utilities/utilities.dart';
import '../../../widgets/bids/bid_app_bar.dart';
import '../../../widgets/bids/new_bid_widget.dart';

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
      await _engine!.muteLocalAudioStream(muted);
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
              Positioned(
                  top: 10,
                  right: 16,
                  left: 16,
                  child: BidAppBar(
                    auction: widget.auction,
                    users: _users,
                    muted: muted,
                    onMute: () => _onToggleMute(),
                    onCameraSwitch: () => _onSwitchCamera(),
                  )),
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
    final List<StatefulWidget> list = <StatefulWidget>[];
    if (me == widget.auction.uid) {
      list.add(const RtcLocalView.SurfaceView());
    }
    for (int uid in _users) {
      list.add(RtcRemoteView.SurfaceView(
          channelId: widget.auction.auctionID, uid: uid));
      print('User: $uid');
    }
    print('Users Lister: ${list.length}');
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
