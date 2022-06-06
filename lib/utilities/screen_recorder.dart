import 'dart:developer';
import 'dart:io';

import 'package:ed_screen_recorder/ed_screen_recorder.dart';
import 'package:flutter/material.dart';
import 'package:rc_clone/data/models/claim.dart';
import 'package:rc_clone/data/repositories/data_upload_repo.dart';

class ScreenRecorder {
  EdScreenRecorder? _edScreenRecorder;

  ScreenRecorder() {
    _edScreenRecorder = EdScreenRecorder();
  }

  Future<Map<String, dynamic>> startRecord({required String fileName}) async {
    var response = await _edScreenRecorder!.startRecordScreen(
      fileName: fileName,
      // dirPathToSave: "/storage/emulated/0/Android/data/com.lightsoftware.omeet/Recordings",
      audioEnable: true,
    );
    log(response.toString());
    return response;
  }

  Future<Map<String, dynamic>> stopRecord({required Claim claim, required BuildContext context}) async {
    var response = await _edScreenRecorder?.stopRecord();
    log(response.toString());
    File _videoFile = response!['file'];
    bool _result = await DataUploadRepository()
        .uploadData(claim.claimNumber, _videoFile);
    if (_result) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("File uploaded successfully!"),
          backgroundColor: Colors.green,
        ),
      );
      _videoFile.delete();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to upload the files."),
          backgroundColor: Colors.red,
        ),
      );
    }
    return response;
  }
}