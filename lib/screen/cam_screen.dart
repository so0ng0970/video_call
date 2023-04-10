import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_call/const/agora.dart';

class CamScreen extends StatefulWidget {
  const CamScreen({super.key});

  @override
  State<CamScreen> createState() => _CamScreenState();
}

class _CamScreenState extends State<CamScreen> {
  RtcEngine? engine;
  // 내 아이디
  int? uid = 0;
  int? otherUid;

  @override
  void dispose() async {
    if (engine != null) {
      await engine!.leaveChannel(
        options: const LeaveChannelOptions(),
      );

      engine!.release();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'LIVE',
        ),
      ),
      body: FutureBuilder<bool>(
        future: init(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          }
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    renderMainView(),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        color: Colors.grey,
                        height: 150,
                        width: 120,
                        child: renderSubView(),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    if (engine != null) {
                      await engine!.leaveChannel();
                      engine = null;
                    }
                    Navigator.of(context).pop();
                  },
                  child: const Text('채널나가기'),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  renderMainView() {
    if (uid == null) {
      return const Center(
        child: Text('채널에 참여해주세요'),
      );
    } else {
      // 채널에 참여하고 있을때
      return AgoraVideoView(
        controller: VideoViewController(
          rtcEngine: engine!,
          canvas: const VideoCanvas(uid: 0),
        ),
      );
    }
  }

  renderSubView() {
    if (otherUid == null) {
      return const Center(
        child: Text('채널에 유저가 없습니다'),
      );
    } else {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: engine!,
          canvas: VideoCanvas(uid: otherUid),
          connection: const RtcConnection(channelId: CHANNEL_ID),
        ),
      );
    }
  }

  Future<bool> init() async {
    final resp = await [Permission.camera, Permission.microphone].request();

    final cameraPermission = resp[Permission.camera];
    final microphonePermission = resp[Permission.microphone];

    if (cameraPermission != PermissionStatus.granted ||
        microphonePermission != PermissionStatus.granted) {
      throw '카메라 또는 마이크 권한이 없습니다';
    }

    if (engine == null) {
      engine = createAgoraRtcEngine();
      await engine!.initialize(
        const RtcEngineContext(
          appId: APP_ID,
        ),
      );
      engine!.registerEventHandler(
        RtcEngineEventHandler(
          // 내가 채널에 입장했을때
          // connection -> 연결정보
          // elapsed -> 연결된 시간 (연결된지 얼마나 됐는지)
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
            print('채널에 입장함 .uid ${connection.localUid}');
            setState(
              () {
                uid = connection.localUid;
              },
            );
          },
          // 내가 채널에서 나갔을때
          onLeaveChannel: (RtcConnection connection, RtcStats stats) {
            print('채널 퇴장 ');
            setState(() {
              uid == null;
            });
          },
          // 상대방 유저가 들어왔을때
          onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
            print('상대가 입장함 . otherUid $remoteUid ');

            setState(() {
              otherUid = remoteUid;
            });
          },
          // 상대가 나갔을때
          onUserOffline: (RtcConnection connection, int remoteUid,
              UserOfflineReasonType reason) {
            print('상대가 나갔습니다  otherUid $remoteUid  ');
            setState(() {
              otherUid == null;
            });
          },
        ),
      );
      await engine!.enableVideo();
      // 카메라로 찍히는 모습 송출
      await engine!.startPreview();

      ChannelMediaOptions options = const ChannelMediaOptions();
      await engine!.joinChannel(
        token: TEMP_TOKEN,
        channelId: CHANNEL_ID,
        uid: 0,
        options: options,
      );
    }

    return true;
  }
}
