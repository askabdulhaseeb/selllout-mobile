import 'dart:async';
import 'dart:developer';

import 'package:agora_rtc_engine/rtc_engine.dart';
// ignore: library_prefixes
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
// ignore: library_prefixes
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:flutter/material.dart';

import '../../../database/auction_api.dart';
import '../../../database/auth_methods.dart';
import '../../../functions/time_date_functions.dart';
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

class _BroadcastPageState extends State<BroadcastPage>
    with WidgetsBindingObserver {
  final List<int> _users = <int>[];
  final List<String> _infoStrings = <String>[];
  RtcEngine? _engine;
  bool muted = false;
  String appId = Utilities.agoraID;
  final String me = AuthMethods.uid;
  late bool isBroadcaster;
  Duration callTime = const Duration(seconds: 0);
  int callEndsIn = 60;
  final int maxTime = 30;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.inactive:
        if (widget.auction.author == me) await _dispose();
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.resumed:
        if (widget.auction.author == me) Navigator.of(context).pop();
        break;
    }
  }

  @override
  void dispose() async {
    await _dispose();
    super.dispose();
  }

  _dispose() async {
    _users.clear();
    _engine!.destroy();
    if (widget.auction.author == me) {
      widget.auction.isActive = false;
      await AuctionAPI().updateActivity(auction: widget.auction);
    }
  }

  @override
  void initState() {
    super.initState();
    isBroadcaster = widget.auction.coAuthors.contains(me) ||
        widget.auction.author == AuthMethods.uid;
    initialize();
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        callTime = TimeDateFunctions.timeDuration(widget.auction.timestamp);
        if (callTime.inMinutes.remainder(60).abs() >= maxTime - 1) {
          callEndsIn--;
        }
      });
      if (callTime.inMinutes.remainder(60).abs() >= maxTime) {
        Navigator.of(context).pop();
      }
    });
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
    if (widget.auction.coAuthors.contains(me) ||
        widget.auction.author == AuthMethods.uid) {
      await _engine!.enableDualStreamMode(true);
      await _engine!.setClientRole(ClientRole.Broadcaster);
    } else {
      await _engine!.muteLocalAudioStream(true);
      await _engine!.setClientRole(ClientRole.Audience);
    }
  }

  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    print('INFO Handler');
    _engine!.setEventHandler(RtcEngineEventHandler(
      activeSpeaker: (int uid) {
        final String info = 'INFO Active speaker: $uid';
        print(info);
      },
      error: (ErrorCode code) {
        setState(() {
          final String info = 'INFO onError: $code';
          _infoStrings.add(info);
          print(info);
        });
      },
      joinChannelSuccess: (String channel, int uid, int elapsed) {
        setState(() {
          final String info = 'INFO onJoinChannel: $channel, uid: $uid';
          _infoStrings.add(info);
          print(info);
        });
      },
      leaveChannel: (RtcStats stats) {
        setState(() {
          const String info = 'INFO leaveChannel:';
          _infoStrings.add('onLeaveChannel');
          _users.clear();
          print(info);
        });
      },
      userJoined: (int uid, int elapsed) {
        final String info = 'INFO userJoined: $uid';
        _infoStrings.add(info);
        setState(() {
          _users.add(uid);
        });
        print(info);
        // if (_users.length >= 5) {
        //   print('Fallback to Low quality video stream');
        //   _engine?.setRemoteDefaultVideoStreamType(VideoStreamType.Low);
        // }
      },
      userOffline: (int uid, UserOfflineReason reason) {
        final String info = 'INFO userOffline: $uid , reason: $reason';
        _infoStrings.add(info);
        setState(() {
          _users.remove(uid);
        });
        print(info);
        // if (_users.length <= 3) {
        //   print('Go back to High quality video stream');
        //   _engine?.setRemoteDefaultVideoStreamType(VideoStreamType.High);
        // }
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Stack(
            children: <Widget>[
              _viewRows(),
              if (callEndsIn < 60)
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Live stream will ends',
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context)
                            .scaffoldBackgroundColor
                            .withOpacity(0.3),
                      ),
                    ),
                    SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: FittedBox(
                        child: Text(
                          '$callEndsIn',
                          style: TextStyle(
                            color: Theme.of(context)
                                .scaffoldBackgroundColor
                                .withOpacity(0.3),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              Positioned(
                  top: 10,
                  right: 16,
                  left: 16,
                  child: BidAppBar(
                    auction: widget.auction,
                    users: _users.length,
                    callTime: callTime,
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
    if (widget.auction.coAuthors.contains(me) || widget.auction.author == me) {
      list.add(const RtcLocalView.SurfaceView());
    }
    for (int uid in _users) {
      list.add(RtcRemoteView.SurfaceView(
          channelId: widget.auction.auctionID, uid: uid));
      print('User: $uid');
    }
    setState(() {
      _users;
    });
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
