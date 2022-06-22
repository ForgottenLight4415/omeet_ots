import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../widgets/scaling_tile.dart';
import '../data/models/document.dart';

class DocumentCard extends StatelessWidget {
  final Document document;

  const DocumentCard({Key? key, required this.document}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: ScalingTile(
        onPressed: () {
          Navigator.pushNamed(
            context,
            '/view/document',
            arguments: document.fileName,
          );
        },
        child: Card(
          child: Container(
            margin: EdgeInsets.all(10.w),
            constraints: BoxConstraints(
              minHeight: 170.h,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 10.w),
                  constraints: BoxConstraints(
                    maxHeight: 150.h,
                    minHeight: 150.h,
                    maxWidth: 110.w,
                    minWidth: 110.w,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(14.r)
                  ),
                  child: Center(
                    child: FaIcon(
                      FontAwesomeIcons.fileAlt,
                      size: 50.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
                Text(
                  "Document\nID: ${document.id}",
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.fade,
                  maxLines: 2,
                  style: Theme.of(context).textTheme.headline5,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
