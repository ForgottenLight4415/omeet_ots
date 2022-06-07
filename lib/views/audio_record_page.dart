import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:rc_clone/data/models/claim.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rc_clone/utilities/sound_recorder.dart';

class AudioRecordPage extends StatefulWidget {
  final Claim claim;
  const AudioRecordPage({Key? key, required this.claim}) : super(key: key);

  @override
  State<AudioRecordPage> createState() => _AudioRecordPageState();
}

class _AudioRecordPageState extends State<AudioRecordPage> {
  SoundRecorder? _recorder;
  Duration _duration = const Duration();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _recorder = SoundRecorder(widget.claim);
    _recorder!.init();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) => _addTime());
  }

  void _stopTimer() {
    _timer!.cancel();
  }

  void _resetTimer() {
    setState(() {
      _duration = const Duration();
    });
  }

  void _addTime() {
    const int _addSeconds = 1;
    setState(() {
      final seconds = _duration.inSeconds + _addSeconds;
      _duration = Duration(seconds: seconds);
    });
  }

  @override
  void dispose() {
    _recorder!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Record Audio"),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.w),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(widget.claim.claimNumber,
                style: TextStyle(
                  fontSize: 35.sp,
                  fontWeight: FontWeight.w600
                ),
              ),
              AudioTimer(duration: _duration),
              _recorderButton()
            ],
          ),
        ),
      ),
    );
  }

  Widget _recorderButton() {
    final bool _isRecording = _recorder!.isRecording;
    final IconData _icon = _isRecording ? Icons.stop : Icons.mic;
    final String _text = _isRecording ? 'Stop recording' : 'Start recording';
    final Color _primary = _isRecording ? Colors.red : Colors.green;

    return ElevatedButton.icon(
      onPressed: () async {
        await _recorder!.toggleRecording(context);
        if (!_isRecording) {
          _resetTimer();
          _startTimer();
        } else {
          _stopTimer();
        }
        setState(() {});
        log("Recorder state changed");
      },
      style: ElevatedButton.styleFrom(
        primary: _primary,
        onPrimary: Colors.white,
      ),
      icon: Icon(_icon),
      label: Text(_text),
    );
  }
}

class AudioTimer extends StatefulWidget {
  final Duration duration;

  const AudioTimer({Key? key, required this.duration}) : super(key: key);

  @override
  State<AudioTimer> createState() => _AudioTimerState();
}

class _AudioTimerState extends State<AudioTimer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Container(
        height: 300.h,
        width: 300.h,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.deepOrange
        ),
        child: Center(
          child: _buildTime(),
        ),
      ),
    );
  }

  Widget _buildTime() {
    final String minutes = _twoDigits(widget.duration.inMinutes.remainder(60));
    final String seconds = _twoDigits(widget.duration.inSeconds.remainder(60));
    return FittedBox(
      child: Text(
        "$minutes:$seconds",
        style: TextStyle(
            color: Colors.white,
            fontSize: 80.sp
        ),
      ),
    );
  }

  String _twoDigits(int n) {
    return n.toString().padLeft(2, '0');
  }
}


