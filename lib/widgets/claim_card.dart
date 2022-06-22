import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rc_clone/widgets/snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'scaling_tile.dart';
import 'phone_list_tile.dart';
import 'card_detail_text.dart';
import 'claim_options_tile.dart';
import '../data/models/claim.dart';
import '../utilities/app_constants.dart';
import '../utilities/screen_recorder.dart';
import '../blocs/call_bloc/call_cubit.dart';
import '../utilities/claim_option_functions.dart';
import '../utilities/app_permission_manager.dart';

class ClaimCard extends StatefulWidget {
  final Claim claim;
  final ScreenRecorder screenRecorder;

  const ClaimCard({Key? key, required this.claim, required this.screenRecorder})
      : super(key: key);

  @override
  State<ClaimCard> createState() => _ClaimCardState();
}

class _ClaimCardState extends State<ClaimCard> {
  @override
  Widget build(BuildContext context) {
    return ScalingTile(
      onPressed: () {
        _openClaimMenu();
      },
      child: Card(
        child: Container(
          constraints: BoxConstraints(minHeight: 250.h),
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.claim.claimNumber,
                softWrap: false,
                style: Theme.of(context).textTheme.headline3!.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).primaryColor,
                      overflow: TextOverflow.fade,
                    ),
              ),
              SizedBox(height: 10.h),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CardDetailText(
                    title: AppStrings.customerName,
                    content: widget.claim.insuredName,
                  ),
                  CardDetailText(
                    title: AppStrings.customerAddress,
                    content: _createAddress(
                      widget.claim.insuredCity,
                      widget.claim.insuredState,
                    ),
                  ),
                  CardDetailText(
                    title: AppStrings.phoneNumber,
                    content: widget.claim.insuredContactNumber,
                  ),
                  CardDetailText(
                    title: AppStrings.phoneNumberAlt,
                    content:
                        widget.claim.insuredAltContactNumber != AppStrings.blank
                            ? widget.claim.insuredAltContactNumber
                            : AppStrings.unavailable,
                  ),
                  SizedBox(height: 15.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      BlocProvider<CallCubit>(
                        create: (callContext) => CallCubit(),
                        child: BlocConsumer<CallCubit, CallState>(
                          listener: _callListener,
                          builder: (context, state) => ElevatedButton(
                            onPressed: _call,
                            child: const Icon(Icons.phone),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => _videoCall(context),
                        child: const FaIcon(FontAwesomeIcons.video),
                      ),
                      ElevatedButton(
                        onPressed: _sendMail,
                        child: const Icon(Icons.mail),
                      ),
                      ElevatedButton(
                        onPressed: _openClaimMenu,
                        child: const Text("More"),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _sendMail() async {
    final Uri _launchUri = Uri(scheme: 'mailto', path: widget.claim.email);
    await launchUrl(_launchUri);
  }

  void _callListener(BuildContext context, CallState state) {
    if (state is CallLoading) {
      showSnackBar(context, AppStrings.connecting);
    } else if (state is CallReady) {
      showSnackBar(context, AppStrings.receiveCall);
    } else if (state is CallFailed) {
      showSnackBar(context, state.cause, isError: true);
    }
  }

  Future<void> _videoCall(BuildContext context) async {
    bool cameraStatus = await cameraPermission();
    bool microphoneStatus = await microphonePermission();
    bool storageStatus = await storagePermission();
    if (cameraStatus && microphoneStatus && storageStatus) {
      log("Starting meet");
      Navigator.pushNamed(context, '/claim/meeting', arguments: widget.claim);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.camMicStoragePerm)),
      );
    }
  }

  Future<void> _call() async {
    String? _selectedPhone;
    if (widget.claim.insuredAltContactNumber != AppStrings.unavailable) {
      _selectedPhone = await showModalBottomSheet(
        context: context,
        constraints: BoxConstraints(
          maxHeight: 300.h,
        ),
        builder: (context) => Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Text(
                AppStrings.voiceCall,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            Divider(
              height: 0.5,
              thickness: 0.5,
              indent: 50.w,
              endIndent: 50.w,
              color: Colors.black54,
            ),
            TextButton(
              onPressed: () {
                Navigator.pop<String>(
                  context,
                  widget.claim.insuredContactNumber,
                );
              },
              child: PhoneListTile(
                phoneNumber: widget.claim.insuredContactNumber,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop<String>(
                  context,
                  widget.claim.insuredAltContactNumber,
                );
              },
              child: PhoneListTile(
                phoneNumber: widget.claim.insuredAltContactNumber,
                primary: false,
              ),
            )
          ],
        ),
      );
    } else {
      _selectedPhone = widget.claim.insuredContactNumber;
    }
    if (_selectedPhone != null) {
      BlocProvider.of<CallCubit>(context).callClient(
        claimNumber: widget.claim.claimNumber,
        phoneNumber: _selectedPhone,
        customerName: widget.claim.insuredName,
      );
    }
  }

  void _openClaimMenu() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (modalContext) => SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ClaimPageTiles(
              faIcon: FontAwesomeIcons.fileAlt,
              label: "Documents",
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/documents',
                  arguments: widget.claim.claimNumber,
                );
              },
            ),
            // ClaimPageTiles(
            //   faIcon: FontAwesomeIcons.history,
            //   label: "Previous records",
            //   onPressed: () {},
            // ),
            ClaimPageTiles(
              faIcon: FontAwesomeIcons.microphone,
              label: "Record audio",
              onPressed: () {
                Navigator.pop(modalContext);
                recordAudio(context, widget.claim);
              },
            ),
            ClaimPageTiles(
              faIcon: FontAwesomeIcons.camera,
              label: "Capture image",
              onPressed: () {
                Navigator.pop(modalContext);
                captureImage(context, widget.claim);
              },
            ),
            ClaimPageTiles(
              faIcon: FontAwesomeIcons.film,
              label: "Record video",
              onPressed: () {
                Navigator.pop(modalContext);
                recordVideo(context, widget.claim);
              },
            ),
            ClaimPageTiles(
              faIcon: FontAwesomeIcons.video,
              label: "Video call",
              onPressed: () async {
                Navigator.pop(modalContext);
                videoCall(context, widget.claim);
              },
            ),
            ClaimPageTiles(
              faIcon: FontAwesomeIcons.recordVinyl,
              label: _getScreenRecordText(),
              onPressed: () async {
                Navigator.pop(modalContext);
                if (!widget.screenRecorder.isRecording) {
                  await startScreenRecord(
                    context,
                    widget.screenRecorder,
                    widget.claim.claimNumber,
                  );
                } else {
                  if (widget.screenRecorder.claimNumber !=
                      widget.claim.claimNumber) {
                    showDialog(
                      context: context,
                      builder: (dialogContext) => AlertDialog(
                        title: const Text(AppStrings.stopRecording),
                        content: Text(
                            "Recording in progress for ${widget.screenRecorder.claimNumber}. Do you want to stop recording for current claim and start new one?"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(dialogContext);
                            },
                            child: const Text(AppStrings.cancel),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.pop(dialogContext);
                              await stopScreenRecord(
                                context,
                                widget.screenRecorder,
                                widget.claim,
                              );
                            },
                            child: const Text(AppStrings.ok),
                          ),
                        ],
                      ),
                    );
                  } else {
                    await stopScreenRecord(
                      context,
                      widget.screenRecorder,
                      widget.claim,
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  String _getScreenRecordText() {
    if (widget.screenRecorder.isRecording) {
      if (widget.screenRecorder.claimNumber != widget.claim.claimNumber) {
        return "Stop for ${widget.screenRecorder.claimNumber}";
      } else {
        return "Stop recording screen";
      }
    }
    return "Record screen";
  }

  String _createAddress(String city, String state) {
    if (city == AppStrings.unavailable || state == AppStrings.unavailable) {
      return AppStrings.unavailable;
    }
    return "$city, $state";
  }
}
