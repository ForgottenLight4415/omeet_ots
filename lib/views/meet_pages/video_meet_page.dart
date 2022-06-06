import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:rc_clone/data/models/claim.dart';
import 'package:rc_clone/data/providers/authentication_provider.dart';
import 'package:rc_clone/utilities/screen_recorder.dart';
import 'package:rc_clone/widgets/buttons.dart';
import 'package:rc_clone/widgets/scaling_tile.dart';

enum VideoMeetStatus { none, joining, inProgress, terminated, error }

class VideoMeetPage extends StatefulWidget {
  final Claim claim;

  const VideoMeetPage({Key? key, required this.claim}) : super(key: key);

  @override
  State<VideoMeetPage> createState() => _VideoMeetPageState();
}

class _VideoMeetPageState extends State<VideoMeetPage>
    with AutomaticKeepAliveClientMixin<VideoMeetPage> {
  // Video meet settings
  VideoMeetStatus _status = VideoMeetStatus.none;
  bool _isAudioOnly = false;
  bool _isAudioMuted = true;
  bool _isVideoMuted = true;

  // Screen recorder settings
  ScreenRecorder? _screenRecorder;

  @override
  void initState() {
    super.initState();
    _screenRecorder = ScreenRecorder();
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

  ThemeData customTheme(BuildContext context) {
    return Theme.of(context).copyWith(
        textTheme: Theme.of(context).textTheme.copyWith(
            bodyText1: Theme.of(context).textTheme.bodyText1!.copyWith(
              fontWeight: FontWeight.w500,
              color: Colors.white,
            )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_status == VideoMeetStatus.joining) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (_status == VideoMeetStatus.inProgress) {
      return Theme(
        data: customTheme(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "Meeting in progress.\nGo to the meeting screen to end call.",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline6,
            ),
            ScalingTile(
              onPressed: () async {
                await _closeMeeting();
              },
              child: SizedBox(
                height: 70.h,
                width: 180.h,
                child: Card(
                  color: Colors.red,
                  child: Center(
                    child: Text(
                      "End meeting",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return Theme(
      data: customTheme(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            "Tap \"Start meeting\" to join the meet",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline5!.copyWith(
                fontFamily: 'Open Sans',
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            "Your video and microphone are turned off by default.",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              VideoMeetToggleButton(
                toggleParameter: _isAudioMuted,
                primaryFaIcon: FontAwesomeIcons.microphoneSlash,
                secondaryFaIcon: FontAwesomeIcons.microphone,
                onPressed: () {
                  _onAudioMutedChanged(!_isAudioMuted);
                },
              ),
              VideoMeetToggleButton(
                toggleParameter: _isVideoMuted,
                primaryFaIcon: FontAwesomeIcons.videoSlash,
                secondaryFaIcon: FontAwesomeIcons.video,
                onPressed: () {
                  _onVideoMutedChanged(!_isVideoMuted);
                },
              ),
              ScalingTile(
                onPressed: () async {
                  await _screenRecorder!.startRecord(
                    fileName: widget.claim.claimNumber +
                        '_' +
                        DateTime.now().toIso8601String(),
                  );
                  await _joinMeeting();
                },
                child: SizedBox(
                  height: 70.h,
                  width: 180.h,
                  child: Card(
                    color: Colors.green,
                    child: Center(
                      child: Text(
                        "Start meeting",
                        style: Theme.of(context).textTheme.bodyText1,
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
    await _screenRecorder!.stopRecord(claim: widget.claim, context: context);
  }

  void _onError(error) async {
    setState(() {
      _status = VideoMeetStatus.error;
    });
    await _screenRecorder!.stopRecord(claim: widget.claim, context: context);
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
      var options = JitsiMeetingOptions(
          room: "${widget.claim.claimID}_${widget.claim.claimNumber}")
        ..serverURL =
            "https://hi.omeet.in/${widget.claim.claimNumber.replaceAll('-', '')}"
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

  Future<void> _closeMeeting() async {
    await JitsiMeet.closeMeeting();
  }

  @override
  bool get wantKeepAlive {
    return true;
  }
}
