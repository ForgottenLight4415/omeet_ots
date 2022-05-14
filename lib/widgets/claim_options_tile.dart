import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ClaimPageTiles extends StatelessWidget {
  final IconData faIcon;
  final String label;
  final VoidCallback onPressed;

  const ClaimPageTiles(
      {Key? key,
      required this.faIcon,
      required this.label,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: ListTile(
        leading: FaIcon(faIcon, color: Colors.deepOrange, size: 30.w),
        title: Text(
          label,
          style: TextStyle(fontSize: 20.sp),
        ),
      ),
    );
  }
}
