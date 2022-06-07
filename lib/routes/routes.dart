import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rc_clone/data/models/claim.dart';
import 'package:rc_clone/views/audio_record_page.dart';
import 'dart:io';

import 'package:rc_clone/views/home.dart';
import 'package:rc_clone/views/invalid_route.dart';
import 'package:rc_clone/views/login.dart';
import 'package:rc_clone/views/meeting_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return _platformDependentRouting(const HomePage());
      case '/login':
        return _platformDependentRouting(const SignInPage());

      case '/claim/meeting':
        final Claim _claim = args as Claim;
        return _platformDependentRouting(MeetingMainPage(claim: _claim));

      case '/record/audio':
        final Claim _claim = args as Claim;
        return _platformDependentRouting(AudioRecordPage(claim: _claim));
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