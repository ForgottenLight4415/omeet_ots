import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:rc_clone/blocs/home_bloc/get_claims_cubit.dart';
import 'package:rc_clone/data/repositories/auth_repo.dart';
import 'package:rc_clone/utilities/app_permission_manager.dart';
import 'package:rc_clone/utilities/screen_recorder.dart';
import 'package:rc_clone/widgets/claim_options_tile.dart';
import 'package:rc_clone/widgets/input_fields.dart';
import 'package:rc_clone/widgets/loading_widget.dart';
import 'package:rc_clone/widgets/error_widget.dart';
import 'package:rc_clone/widgets/scaling_tile.dart';
import 'package:rc_clone/widgets/claim_card.dart';
import 'package:rc_clone/data/models/claim.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController? _searchController;
  String? _searchQuery;

  final GetClaimsCubit _claimsCubit = GetClaimsCubit();

  ScreenRecorder? _screenRecorder;
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController!.addListener(() {
      _searchQuery = _searchController!.text;
      _claimsCubit.searchClaims(_searchQuery);
    });
    _screenRecorder = ScreenRecorder();
  }

  @override
  void dispose() {
    _searchController!.dispose();
    _claimsCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) {
          return <Widget>[
            SliverAppBar(
              stretch: true,
              floating: true,
              pinned: true,
              snap: false,
              expandedHeight: 145.h,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black87,
              actions: [
                IconButton(
                  onPressed: () async {
                    await AuthRepository().signOut();
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/login', (route) => false);
                  },
                  icon: const Icon(Icons.logout),
                ),
              ],
              title: Text(
                'Claims',
                style: Theme.of(context).textTheme.headline3!.copyWith(
                      color: Colors.black87,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              centerTitle: false,
              flexibleSpace: FlexibleSpaceBar(
                background: Column(
                  children: <Widget>[
                    SizedBox(height: 100.h),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 6.0, 16.0, 16.0),
                      child: SizedBox(
                        height: 50.h,
                        width: double.infinity,
                        child: SearchField(
                          textEditingController: _searchController,
                          hintText: "Search claims",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: BlocProvider<GetClaimsCubit>(
          create: (context) => _claimsCubit..getClaims(),
          child: BlocBuilder<GetClaimsCubit, GetClaimsState>(
            builder: (context, state) {
              if (state is GetClaimsSuccess) {
                if (state.claims.isEmpty) {
                  return const InformationWidget(
                    svgImage: "images/no-data.svg",
                    label: "No claims",
                  );
                }
                return ListView.builder(
                  padding: EdgeInsets.only(left: 8.w, top: 8.h, right: 8.w),
                  itemCount: state.claims.length,
                  itemBuilder: (context, index) => ScalingTile(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) =>
                            optionsModal(context, state.claims[index]),
                      );
                    },
                    child: ClaimCard(claim: state.claims[index]),
                  ),
                );
              } else if (state is GetClaimsFailed) {
                return CustomErrorWidget(
                  errorText: "Something went wrong on our end.\n"
                      "${state.cause}\n(Error code: ${state.code})",
                  action: () {
                    BlocProvider.of<GetClaimsCubit>(context).getClaims();
                  },
                );
              } else {
                return const LoadingWidget(label: "Getting claims...");
              }
            },
          ),
        ),
      ),
    );
  }

  Widget optionsModal(BuildContext context, Claim claim) {
    return Column(
      children: <Widget>[
        ClaimPageTiles(
          faIcon: FontAwesomeIcons.fileAlt,
          label: "Documents",
          onPressed: () {},
        ),
        ClaimPageTiles(
          faIcon: FontAwesomeIcons.history,
          label: "Previous records",
          onPressed: () {},
        ),
        ClaimPageTiles(
          faIcon: FontAwesomeIcons.microphone,
          label: "Record audio",
          onPressed: () async {
            bool microphoneStatus = await microphonePermission();
            bool storageStatus = await storagePermission();
            Navigator.pop(context);
            if (microphoneStatus && storageStatus) {
              Navigator.pushNamed(context, '/record/audio', arguments: claim);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "Microphone and storage permission is required to access this feature.",
                  ),
                ),
              );
            }
          },
        ),
        ClaimPageTiles(
          faIcon: FontAwesomeIcons.film,
          label: "Record video",
          onPressed: () {},
        ),
        ClaimPageTiles(
          faIcon: FontAwesomeIcons.video,
          label: "Video call",
          onPressed: () async {
            bool cameraStatus = await cameraPermission();
            bool microphoneStatus = await microphonePermission();
            bool storageStatus = await storagePermission();
            Navigator.pop(context);
            if (cameraStatus && microphoneStatus && storageStatus) {
              log("Starting meet");
              Navigator.pushNamed(context, '/claim/meeting', arguments: claim);
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
        ),
        ClaimPageTiles(
          faIcon: FontAwesomeIcons.recordVinyl,
          label: _isRecording ? "Stop recording screen" : "Record Screen",
          onPressed: () async {
            bool microphoneStatus = await microphonePermission();
            bool storageStatus = await storagePermission();
            if (microphoneStatus && storageStatus) {
              if (!_isRecording) {
                await _screenRecorder!.startRecord(
                  fileName:
                  claim.claimNumber + '_' + DateTime.now().toIso8601String(),
                );
                setState(() {
                  _isRecording = true;
                });
                Navigator.pop(context);
              } else {
                await _screenRecorder!.stopRecord(claim: claim, context: context);
                setState(() {
                  _isRecording = false;
                });
                Navigator.pop(context);
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "Microphone and storage permission is required to access this feature.",
                  ),
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
