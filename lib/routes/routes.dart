import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../data/models/claim.dart';
import '../utilities/camera_utility.dart';
import '../views/login.dart';
import '../views/home.dart';
import '../views/invalid_route.dart';
import '../views/meet_pages/meet_main.dart';
import '../views/recorder_pages/audio_record.dart';
import '../views/recorder_pages/image_capture.dart';
import '../views/recorder_pages/video_record.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return _platformDependentRouting(const HomePage());
      case '/login':
        return _platformDependentRouting(const SignInPage());

      // MEETING ROUTES
      case '/claim/meeting':
        final Claim _claim = args as Claim;
        return _platformDependentRouting(MeetingMainPage(claim: _claim));

      // RECORDER ROUTES
      case '/record/audio':
        final AudioRecordArguments _audioRecArguments = args as AudioRecordArguments;
        return _platformDependentRouting(AudioRecordPage(arguments: _audioRecArguments));
      case '/record/video':
        final CameraCaptureArguments _videoRecArgs = args as CameraCaptureArguments;
        return _platformDependentRouting(
          VideoRecordPage(arguments: _videoRecArgs),
        );
      case '/capture/image':
        final CameraCaptureArguments _captureImageArgs = args as CameraCaptureArguments;
        return _platformDependentRouting(
          CaptureImagePage(arguments: _captureImageArgs),
        );

      default:
        return _platformDependentRouting(const InvalidRoute());
    }
  }

  static Route<dynamic> _platformDependentRouting<T>(Widget widget) {
    if (Platform.isAndroid) {
      return MaterialPageRoute<T>(
        builder: (context) => widget,
      );
    } else {
      return CupertinoPageRoute<T>(
        builder: (context) => widget,
      );
    }
  }
}
