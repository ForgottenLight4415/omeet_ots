import 'dart:developer';
import 'dart:io';

import 'package:ed_screen_recorder/ed_screen_recorder.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rc_clone/data/models/claim.dart';
import 'package:rc_clone/data/repositories/data_upload_repo.dart';
import 'package:rc_clone/utilities/app_constants.dart';

class ScreenRecorder {
  EdScreenRecorder? _edScreenRecorder;

  ScreenRecorder() {
    _edScreenRecorder = EdScreenRecorder();
  }

  Future<Map<String, dynamic>> startRecord({required String fileName}) async {
    log("Starting screen record");
    Directory? directory = await getExternalStorageDirectory();
    Directory? _saveDirectory = await Directory("${directory!.path}/ScreenRecordings").create();
    var response = await _edScreenRecorder!.startRecordScreen(
      fileName: fileName,
      dirPathToSave: _saveDirectory.path,
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
        .uploadData(claim.claimNumber, 0, 0, _videoFile);
    if (_result) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AppStrings.fileUploaded),
          backgroundColor: Colors.green,
        ),
      );
      _videoFile.delete();
      log("File deleted");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AppStrings.fileUploadFailed),
          backgroundColor: Colors.red,
        ),
      );
    }
    return response;
  }
}