import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utilities/app_constants.dart';

class PhoneListTile extends StatelessWidget {
  final String phoneNumber;
  final bool primary;
  const PhoneListTile({Key? key, required this.phoneNumber, this.primary = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Padding(
        padding: EdgeInsets.only(left: 12.w, top: 8.h),
        child: Icon(Icons.phone, size: 30.w, color: Theme.of(context).primaryColor),
      ),
      title: Text(primary ? AppStrings.primary : AppStrings.secondary),
      subtitle: Text(phoneNumber),
    );
  }
}
