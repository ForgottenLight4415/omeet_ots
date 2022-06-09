import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class CustomErrorWidget extends StatelessWidget {
  final String errorText;
  final String actionLabel;
  final VoidCallback action;

  const CustomErrorWidget({
    Key? key,
    required this.errorText,
    required this.action,
    this.actionLabel = "RETRY",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            "images/error.png",
            height: 400.h,
            width: 500.w,
          ),
          Text(
            errorText,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline5,
          ),
          SizedBox(
            height: 20.h,
          ),
          ElevatedButton(
            onPressed: action,
            child: Text(actionLabel),
          ),
        ],
      ),
    );
  }
}

class InformationWidget extends StatelessWidget {
  final String svgImage;
  final String label;

  const InformationWidget({
    Key? key,
    required this.svgImage,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset(svgImage, height: 300.h, width: 150.w),
          SizedBox(height: 30.h),
          Text(
            label,
            style: Theme.of(context).textTheme.headline5!.copyWith(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w600,
                color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
