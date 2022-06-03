import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:rc_clone/data/models/claim.dart';
import 'package:rc_clone/data/providers/authentication_provider.dart';
import 'package:rc_clone/widgets/scaling_tile.dart';
import 'package:ed_screen_recorder/ed_screen_recorder.dart';

enum VideoMeetStatus { none, joining, inProgress, terminated, error }

class VideoMeetPage extends StatefulWidget {
  final Claim claim;

  const VideoMeetPage({Key? key, required this.claim}) : super(key: key);

  @override
  State<VideoMeetPage> createState() => _VideoMeetPageState();
}

class _VideoMeetPageState extends State<VideoMeetPage> with AutomaticKeepAliveClientMixin<VideoMeetPage> {
  // Video meet settings
  bool _isAudioOnly = false;
  bool _isAudioMuted = true;
  bool _isVideoMuted = true;
  VideoMeetStatus _status = VideoMeetStatus.none;

  // Screen recorder settings
  EdScreenRecorder? edScreenRecorder;
  Map<String, dynamic>? _response;

  @override
  void initState() {
    super.initState();
    edScreenRecorder = EdScreenRecorder();
    JitsiMeet.addListener(
      JitsiMeetingListener(
        onConferenceWillJoin: _onConferenceWillJoin,
        onConferenceJoined: _onConferenceJoined,
        onConferenceTerminated: _onConferenceTerminated,
        onError: _onError,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    JitsiMeet.removeAllListeners();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_status == VideoMeetStatus.joining) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (_status == VideoMeetStatus.inProgress) {
      return Center(
        child: Text("Meeting in progress.\nGo to the meeting screen to end call.",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline6
        ),
      );
    }
    return  Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Tap \"Start meeting\" to join the meet",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline5!.copyWith(
                  fontFamily: 'Open Sans'
                ),
              ),
              SizedBox(height: 10.h),
              Text("Your video and microphone are turned off by default.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ScalingTile(
                    onPressed: () {
                      _onAudioMutedChanged(!_isAudioMuted);
                    },
                    child: SizedBox(
                      height: 70.h,
                      width: 70.h,
                      child: Card(
                        elevation: 5.0,
                        color: _isAudioMuted ? Colors.red : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.0),
                        ),
                        child: Center(
                          child: FaIcon(
                            _isAudioMuted
                              ? FontAwesomeIcons.microphoneSlash
                              : FontAwesomeIcons.microphone,
                            color: _isAudioMuted
                              ? Colors.white
                              : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  ScalingTile(
                    onPressed: () {
                      _onVideoMutedChanged(!_isVideoMuted);
                    },
                    child: SizedBox(
                      height: 70.h,
                      width: 70.h,
                      child: Card(
                        elevation: 5.0,
                        color: _isVideoMuted ? Colors.red : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.0),
                        ),
                        child: Center(
                          child: FaIcon(
                            _isVideoMuted
                                ? FontAwesomeIcons.videoSlash
                                : FontAwesomeIcons.video,
                            color: _isVideoMuted
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  ScalingTile(
                    onPressed: () async {
                      await startRecord(
                        fileName: widget.claim.claimNumber + '_' + DateTime.now().toIso8601String(),
                      );
                      await _joinMeeting();
                    },
                    child: SizedBox(
                      height: 70.h,
                      width: 180.h,
                      child: Card(
                        elevation: 5.0,
                        color: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.0),
                        ),
                        child: Center(
                          child: Text("Start meeting",
                            style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.white
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              SizedBox(
                width: 250.w,
                child: CheckboxListTile(
                  value: _isAudioOnly,
                  title: const Text(
                    "Audio only mode",
                  ),
                  onChanged: (value) {
                    _onAudioOnlyChanged(value!);
                  },
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  _onAudioOnlyChanged(bool value) {
    setState(() {
      _isAudioOnly = value;
    });
  }

  _onAudioMutedChanged(bool value) {
    setState(() {
      _isAudioMuted = value;
    });
  }

  _onVideoMutedChanged(bool value) {
    setState(() {
      _isVideoMuted = value;
    });
  }

  void _onConferenceWillJoin(message) {
    setState(() {
      _status = VideoMeetStatus.joining;
    });
  }

  void _onConferenceJoined(message) async {
    setState(() {
      _status = VideoMeetStatus.inProgress;
    });
  }

  void _onConferenceTerminated(message) async {
    setState(() {
      _status = VideoMeetStatus.terminated;
    });
    stopRecord();
  }

  void _onError(error) {
    setState(() {
      _status = VideoMeetStatus.error;
    });
    stopRecord();
  }

  Future<void> _joinMeeting() async {
    try {
      Map<FeatureFlagEnum, bool> featureFlags = {
        FeatureFlagEnum.WELCOME_PAGE_ENABLED: false,
        FeatureFlagEnum.CALL_INTEGRATION_ENABLED: false,
        FeatureFlagEnum.PIP_ENABLED: true,
        FeatureFlagEnum.CALENDAR_ENABLED: false,
        FeatureFlagEnum.LIVE_STREAMING_ENABLED: false,
        FeatureFlagEnum.RECORDING_ENABLED: true,
      };
      var options = JitsiMeetingOptions(room: "${widget.claim.claimID}_${widget.claim.claimNumber}")
        ..subject = "Meeting with ${widget.claim.insuredName}"
        ..userDisplayName = "RC"
        ..userEmail = await AuthenticationProvider.getEmail()
        ..audioOnly = _isAudioOnly
        ..audioMuted = _isAudioMuted
        ..videoMuted = _isVideoMuted
        ..featureFlags = featureFlags;

      await JitsiMeet.joinMeeting(options);
    } catch (error) {
      log(error.toString());
    }
  }

  @override
  bool get wantKeepAlive {
    return true;
  }

  Future<void> startRecord({required String fileName}) async {
    var response = await edScreenRecorder?.startRecordScreen(
      fileName: fileName,
      audioEnable: true,
    );

    setState(() {
      _response = response;
    });

    log(_response.toString());
  }

  Future<void> stopRecord() async {
    var response = await edScreenRecorder?.stopRecord();
    setState(() {
      _response = response;
    });

    log(_response.toString());
  }
}

