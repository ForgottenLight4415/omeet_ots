import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:location/location.dart';

import 'package:rc_clone/blocs/home_bloc/get_claims_cubit.dart';
import 'package:rc_clone/data/repositories/auth_repo.dart';
import 'package:rc_clone/utilities/app_permission_manager.dart';
import 'package:rc_clone/utilities/camera_utility.dart';
import 'package:rc_clone/utilities/location_service.dart';
import 'package:rc_clone/utilities/screen_recorder.dart';
import 'package:rc_clone/utilities/show_snackbars.dart';
import 'package:rc_clone/views/recorder_pages/audio_record.dart';
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
  final GetClaimsCubit _claimsCubit = GetClaimsCubit();
  final LocationService _locationService = LocationService();
  TextEditingController? _searchController;
  String? _searchQuery;
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
              snap: true,
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
                background: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: SearchField(
                      textEditingController: _searchController,
                      hintText: "Search claims",
                    ),
                  ),
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
                      BuildContext snackBarContext = context;
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) => optionsModal(
                          context,
                          snackBarContext,
                          state.claims[index],
                        ),
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

  Widget optionsModal(
      BuildContext context, BuildContext snackBarContext, Claim claim) {
    return SingleChildScrollView(
      child: Column(
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
            onPressed: () {
              _recordAudio(context, snackBarContext, claim);
            },
          ),
          ClaimPageTiles(
            faIcon: FontAwesomeIcons.camera,
            label: "Capture image",
            onPressed: () {
              _captureImage(context, snackBarContext, claim);
            },
          ),
          ClaimPageTiles(
            faIcon: FontAwesomeIcons.film,
            label: "Record video",
            onPressed: () {
              _recordVideo(context, snackBarContext, claim);
            },
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
                    fileName: claim.claimNumber +
                        '_' +
                        DateTime.now().toIso8601String(),
                  );
                  setState(() {
                    _isRecording = true;
                  });
                  Navigator.pop(context);
                } else {
                  await _screenRecorder!
                      .stopRecord(claim: claim, context: context);
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
      ),
    );
  }

  Future<void> _recordAudio(
      BuildContext context, BuildContext snackBarContext, Claim claim) async {
    Navigator.pop(context);
    showInfoSnackBar(snackBarContext, "Checking permissions...");
    LocationData? locationData = await _getLocationData();
    bool microphoneStatus = await microphonePermission();
    bool storageStatus = await storagePermission();
    if (microphoneStatus && storageStatus && locationData != null) {
      Navigator.pushNamed(snackBarContext, '/record/audio',
          arguments: AudioRecordArguments(claim, locationData));
      ScaffoldMessenger.of(snackBarContext).removeCurrentSnackBar();
    } else {
      showInfoSnackBar(snackBarContext,
          "Microphone, storage and location permission is required to access this feature.",
          color: Colors.red);
    }
  }

  Future<void> _recordVideo(
      BuildContext context, BuildContext snackBarContext, Claim claim) async {
    Navigator.pop(context);
    showInfoSnackBar(snackBarContext, "Checking permissions...");
    LocationData? locationData = await _getLocationData();
    bool cameraStatus = await cameraPermission();
    bool microphoneStatus = await microphonePermission();
    bool storageStatus = await storagePermission();
    if (cameraStatus &&
        microphoneStatus &&
        storageStatus &&
        locationData != null) {
      WidgetsFlutterBinding.ensureInitialized();
      List<CameraDescription>? _cameras;
      try {
        _cameras = await availableCameras();
        Navigator.pushNamed(
          snackBarContext,
          '/record/video',
          arguments: CameraCaptureArguments(_cameras, locationData, claim),
        );
        ScaffoldMessenger.of(snackBarContext).removeCurrentSnackBar();
      } on CameraException catch (e) {
        showInfoSnackBar(snackBarContext,
            "Failed to determine available cameras. (${e.description})",
            color: Colors.red);
      }
    } else {
      showInfoSnackBar(
        snackBarContext,
        "Camera, microphone, storage and location permission is required to access this feature.",
        color: Colors.red,
      );
    }
  }

  Future<void> _captureImage(
      BuildContext context, BuildContext snackBarContext, Claim claim) async {
    Navigator.pop(context);
    showInfoSnackBar(snackBarContext, "Checking permissions...");
    LocationData? locationData = await _getLocationData();
    bool cameraStatus = await cameraPermission();
    bool microphoneStatus = await microphonePermission();
    bool storageStatus = await storagePermission();
    if (cameraStatus &&
        microphoneStatus &&
        storageStatus &&
        locationData != null) {
      WidgetsFlutterBinding.ensureInitialized();
      List<CameraDescription>? _cameras;
      try {
        _cameras = await availableCameras();
        Navigator.pushNamed(
          snackBarContext,
          '/capture/image',
          arguments: CameraCaptureArguments(_cameras, locationData, claim),
        );
        ScaffoldMessenger.of(snackBarContext).removeCurrentSnackBar();
      } on CameraException catch (e) {
        showInfoSnackBar(snackBarContext,
            "Failed to determine available cameras. (${e.description})",
            color: Colors.red);
      }
    } else {
      showInfoSnackBar(
        snackBarContext,
        "Camera, microphone, storage and location permission is required to access this feature.",
        color: Colors.red,
      );
    }
  }

  Future<LocationData?> _getLocationData() async {
    LocationData? _locationData;
    try {
      _locationData = await _locationService.getLocation(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
    return _locationData;
  }
}
