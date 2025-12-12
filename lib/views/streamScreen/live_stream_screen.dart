import 'dart:async';
import 'dart:io';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:eventyzze/config/agora_config.dart';
import 'package:eventyzze/constants/enums.dart';
import 'package:eventyzze/model/event_model.dart';
import 'package:eventyzze/model/stream_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../config/app_images.dart';

class LiveStreamScreen extends StatefulWidget {
  const LiveStreamScreen({
    super.key,
    required this.event,
    required this.streamData,
    required this.isHost,
  });

  final EventModel event;
  final EventStreamJoinData streamData;
  final bool isHost;

  @override
  State<LiveStreamScreen> createState() => _LiveStreamScreenState();
}

class _LiveStreamScreenState extends State<LiveStreamScreen> {
  RtcEngine? _engine;
  final Set<int> _remoteUids = <int>{};
  bool _engineReady = false;
  bool _joined = false;
  String? _error;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _commentScrollController = ScrollController();
  final List<_LiveComment> _comments = <_LiveComment>[];

  @override
  void initState() {
    super.initState();
    _seedInitialComments();
    unawaited(_initAgora());
  }

  @override
  void dispose() {
    _messageController.dispose();
    _commentScrollController.dispose();
    _leaveChannel();
    super.dispose();
  }

  void _seedInitialComments() {
    _comments
      ..clear()
      ..addAll(const [
        _LiveComment(
          username: 'olamide',
          message: 'Lorem ipsum dolor sit amet consectetur. Magna pulvinar felis.',
        ),
        _LiveComment(
          username: 'streamer',
          message: 'Welcome everyone! Tap the heart if you enjoy the show.',
        ),
        _LiveComment(
          username: 'olamide',
          message: 'Voice sounds amazing tonight 🔥',
        ),
      ]);
  }

  Future<void> _initAgora() async {
    setState(() {
      _error = null;
      _engineReady = false;
    });

    try {
      await _requestPermissions();

      final engine = createAgoraRtcEngine();
      _engine = engine;

      await engine.initialize(
        RtcEngineContext(
          appId: AgoraConfig.appId,
          channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
        ),
      );

      engine.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
            setState(() => _joined = true);
          },
          onUserJoined: (RtcConnection connection, int uid, int elapsed) {
            setState(() => _remoteUids.add(uid));
          },
          onUserOffline: (
            RtcConnection connection,
            int uid,
            UserOfflineReasonType reason,
          ) {
            setState(() => _remoteUids.remove(uid));
          },
          onLeaveChannel: (RtcConnection connection, RtcStats stats) {
            setState(() {
              _joined = false;
              _remoteUids.clear();
            });
          },
          onError: (ErrorCodeType err, String msg) {
            setState(() => _error = 'Agora error $err: $msg');
          },
        ),
      );

      await engine.enableVideo();
      await engine.setClientRole(
        role: widget.isHost
            ? ClientRoleType.clientRoleBroadcaster
            : ClientRoleType.clientRoleAudience,
      );

      if (widget.isHost) {
        await engine.startPreview();
      }

      await engine.joinChannel(
        token: widget.streamData.agoraToken,
        channelId: widget.streamData.channelName,
        uid: widget.streamData.uid,
        options: ChannelMediaOptions(
          channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
          clientRoleType: widget.isHost
              ? ClientRoleType.clientRoleBroadcaster
              : ClientRoleType.clientRoleAudience,
        ),
      );
    } on Exception catch (e) {
      setState(() => _error = 'Unable to start stream: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => _engineReady = true);
      }
    }
  }

  Future<void> _requestPermissions() async {
    if (!Platform.isAndroid && !Platform.isIOS) return;
    final statuses = await [Permission.camera, Permission.microphone].request();
    if (statuses.values.any((status) => !status.isGranted)) {
      throw Exception('Camera and microphone permissions are required');
    }
  }

  Future<void> _leaveChannel() async {
    try {
      await _engine?.leaveChannel();
    } finally {
      await _engine?.stopPreview();
      await _engine?.release();
      _engine = null;
    }
  }

  Future<void> _handleExit() async {
    await _leaveChannel();
    if (mounted) Navigator.of(context).pop();
  }

  void _handleSendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _comments.insert(
        0,
        _LiveComment(
          username: widget.isHost ? 'You' : 'Guest',
          message: text,
        ),
      );
    });
    _messageController.clear();
    _commentScrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) {
          return;
        }
        await _handleExit();
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Positioned.fill(child: _buildVideoStage()),
            Positioned.fill(
              child: Container(

                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Color(0xCC000000),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 5.0.h,
              left: 0.w,
              child: _buildTopBanner(),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 48,
              child: _buildComposer(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoStage() {
    if (_error != null) {
      return _buildMessage(_error!);
    }

    if (!_engineReady) {
      return const Center(child: CircularProgressIndicator(color: Colors.white));
    }

    if (!_joined) {
      return _buildMessage('Connecting to stream...');
    }

    if (widget.isHost) {
      return Stack(
        children: [
          Positioned.fill(
            child: AgoraVideoView(
              controller: VideoViewController(
                rtcEngine: _engine!,
                canvas: const VideoCanvas(uid: 0),
              ),
            ),
          ),
          if (_remoteUids.isNotEmpty)
            Positioned(
              top: 16,
              right: 16,
              width: 120,
              height: 160,
              child: AgoraVideoView(
                controller: VideoViewController.remote(
                  rtcEngine: _engine!,
                  connection: RtcConnection(channelId: widget.streamData.channelName),
                  canvas: VideoCanvas(uid: _remoteUids.first),
                ),
              ),
            ),
        ],
      );
    }

    if (_remoteUids.isEmpty) {
      return _buildMessage('Waiting for host to join...');
    }

    return AgoraVideoView(
      controller: VideoViewController.remote(
        rtcEngine: _engine!,
        connection: RtcConnection(channelId: widget.streamData.channelName),
        canvas: VideoCanvas(uid: _remoteUids.first),
      ),
    );
  }

  Widget _buildTopBanner() {
    return Container(

      margin: const EdgeInsets.only(left: 8,right: 120),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Color(0xFF4E4E4E).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: _handleExit,
            child: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
          ),
           SizedBox(width: 1.5.w),
          Stack(
            alignment: Alignment.bottomCenter,
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.all(1.5),
                decoration: const BoxDecoration(
                  color: Colors.purpleAccent,
                  shape: BoxShape.circle,
                ),
                child: const CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage("https://i.pravatar.cc/300"),
                  backgroundColor: Colors.grey,
                ),
              ),
              Positioned(
                bottom: -4,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF0055), Color(0xFFFF0080)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'live',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      height: 1.0,
                    ),
                  ),
                ),
              ),
            ],
          ),

           SizedBox(width: 5.w),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.event.title.isNotEmpty ? widget.event.title : "Streamer",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: const [
                  Icon(Icons.remove_red_eye, color: Colors.white70, size: 12),
                  SizedBox(width: 4),
                  Text(
                    '10.8k',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildComposer() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Container(
            height: 6.h,
            padding: const EdgeInsets.only(left: 20, right: 4),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.5),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Message',
                      hintStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(bottom: 4),
                    ),
                    onSubmitted: (_) => _handleSendMessage(),
                  ),
                ),
                GestureDetector(
                  onTap: _handleSendMessage,
                  child: Container(
                    height: 40,
                    width: 40,
                    alignment: Alignment.center,
                    color: Colors.transparent,
                    child: SvgPicture.asset(
                      AppImages.sendIcon,
                      width: 24,
                      height: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
         SizedBox(width: 3.w),
        Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: GestureDetector(
            onTap: () {
            },
            child:  SvgPicture.asset(
                AppImages.giftIcon,
                width: 5.w,
                height: 5.h,
              ),

          ),
        ),

        SizedBox(width: 3.w),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: GestureDetector(
            onTap: () {
            },
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFE94335),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  Icons.favorite_outline,
                  size: 4.5.h,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMessage(String message) {
    return Center(
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white70),
      ),
    );
  }
}



class _LiveComment {
  const _LiveComment({
    required this.username,
    required this.message,
  });

  final String username;
  final String message;
}
