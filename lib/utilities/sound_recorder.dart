import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rc_clone/data/models/claim.dart';
import 'package:rc_clone/data/repositories/data_upload_repo.dart';

class SoundRecorder {
  final Claim claim;

  FlutterSoundRecorder? _audioRecorder;
  bool _isRecorderInitialized = false;

  bool get isRecording => _audioRecorder!.isRecording;

  SoundRecorder(this.claim);

  Future<void> init() async {
    _audioRecorder = FlutterSoundRecorder();
    await _audioRecorder!.openAudioSession();
    _isRecorderInitialized = true;
    log("Recorder initialized");
  }

  void dispose() {
    _audioRecorder!.closeAudioSession();
    _audioRecorder = null;
    _isRecorderInitialized = false;
  }

  Future<void> _record() async {
    log("$_isRecorderInitialized");
    if (!_isRecorderInitialized) return;
    Directory? directory = await getExternalStorageDirectory();
    Directory? _saveDirectory = await Directory(directory!.path + "/Audio").create();
    await _audioRecorder!.startRecorder(
        toFile: _saveDirectory.path + "/${claim.claimNumber}_${DateTime.now().microsecondsSinceEpoch}.aac",
        codec: Codec.aacADTS
    );
  }

  Future<void> _stop(BuildContext context) async {
    if (!_isRecorderInitialized) return;
    String? _path = await _audioRecorder!.stopRecorder();
    File _audioFile = File(_path!);
    bool _result = await DataUploadRepository()
        .uploadData(claim.claimNumber, _audioFile);
    if (_result) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("File uploaded successfully!"),
          backgroundColor: Colors.green,
        ),
      );
      _audioFile.delete();
      log("File deleted");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to upload the files."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> toggleRecording(BuildContext context) async {
    if (_audioRecorder!.isStopped) {
      await _record();
    } else {
      await _stop(context);
    }
  }
}