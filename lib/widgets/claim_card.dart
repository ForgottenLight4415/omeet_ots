import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:maps_launcher/maps_launcher.dart';
import 'package:rc_clone/blocs/call_bloc/call_cubit.dart';
import 'package:rc_clone/data/models/claim.dart';
import 'package:rc_clone/widgets/card_detail_text.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utilities/app_constants.dart';
import '../utilities/app_permission_manager.dart';

class ClaimCard extends StatelessWidget {
  final Claim claim;

  const ClaimCard({Key? key, required this.claim}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        constraints: BoxConstraints(minHeight: 250.h),
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
             claim.claimNumber,
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
                  content: claim.insuredName,
                ),
                CardDetailText(
                  title: AppStrings.customerAddress,
                  content:
                      _createAddress(claim.insuredCity, claim.insuredState),
                ),
                CardDetailText(
                  title: AppStrings.phoneNumber,
                  content: claim.insuredContactNumber,
                ),
                CardDetailText(
                  title: AppStrings.phoneNumberAlt,
                  content: claim.insuredAltContactNumber != AppStrings.blank
                      ? claim.insuredAltContactNumber
                      : AppStrings.unavailable,
                ),
                SizedBox(height: 15.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    BlocProvider<CallCubit>(
                      create: (callContext) => CallCubit(),
                      child: BlocConsumer<CallCubit, CallState>(
                        listener: (context, state) {
                          if (state is CallLoading) {
                          } else if (state is CallReady) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(AppStrings.recieveCall),
                              ),
                            );
                          }
                        },
                        builder: (context, state) => ElevatedButton(
                          onPressed: () async {
                            String? _selectedPhone;
                            if (claim.insuredAltContactNumber !=
                                AppStrings.unavailable) {
                              await showModalBottomSheet(
                                context: context,
                                constraints: BoxConstraints(
                                  maxHeight: 300.h,
                                ),
                                builder: (context) => Column(
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 16.h),
                                      child: Text(
                                        AppStrings.voiceCall,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6,
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
                                        _selectedPhone =
                                            claim.insuredContactNumber;
                                        Navigator.pop(context);
                                      },
                                      child: PhoneListTile(
                                          phoneNumber:
                                              claim.insuredContactNumber),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        _selectedPhone =
                                            claim.insuredAltContactNumber;
                                        Navigator.pop(context);
                                      },
                                      child: PhoneListTile(
                                          phoneNumber:
                                              claim.insuredAltContactNumber,
                                          primary: false),
                                    )
                                  ],
                                ),
                              );
                            } else {
                              _selectedPhone = claim.insuredContactNumber;
                            }
                            if (_selectedPhone != null) {
                              BlocProvider.of<CallCubit>(context).callClient(
                                  claimNumber: claim.claimNumber,
                                  phoneNumber: _selectedPhone!,
                                  customerName: claim.insuredName,
                              );
                            }
                          },
                          child: const Icon(Icons.phone),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        bool cameraStatus = await cameraPermission();
                        bool microphoneStatus = await microphonePermission();
                        bool storageStatus = await storagePermission();
                        Navigator.pop(context);
                        if (cameraStatus && microphoneStatus && storageStatus) {
                          log("Starting meet");
                          Navigator.pushNamed(context, '/claim/meeting',
                              arguments: claim);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Camera, microphone and storage permission is required to access this feature.",
                              ),
                            ),
                          );
                        }
                      },
                      child: const FaIcon(FontAwesomeIcons.video),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final Uri _launchUri =
                            Uri(scheme: 'mailto', path: claim.email);
                        await launchUrl(_launchUri);
                      },
                      child: const Icon(Icons.mail),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _createAddress(String city, String state) {
    if (city == AppStrings.unavailable || state == AppStrings.unavailable) {
      return AppStrings.unavailable;
    }
    return "$city, $state";
  }
}

class PhoneListTile extends StatelessWidget {
  final String phoneNumber;
  final bool primary;
  const PhoneListTile(
      {Key? key, required this.phoneNumber, this.primary = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Padding(
        padding: EdgeInsets.only(left: 12.w, top: 8.h),
        child: Icon(Icons.phone, size: 30.w, color: Colors.deepOrange),
      ),
      title: Text(primary ? AppStrings.primary : AppStrings.secondary),
      subtitle: Text(phoneNumber),
    );
  }
}
