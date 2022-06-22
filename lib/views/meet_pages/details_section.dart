import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/models/claim.dart';
import '../../utilities/app_constants.dart';
import '../../widgets/card_detail_text.dart';

class MeetDetails extends StatefulWidget {
  final Claim claim;
  const MeetDetails({Key? key, required this.claim}) : super(key: key);

  @override
  State<MeetDetails> createState() => _MeetDetailsState();
}

class _MeetDetailsState extends State<MeetDetails> with AutomaticKeepAliveClientMixin<MeetDetails> {

  @override
  bool get wantKeepAlive {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Text(
              widget.claim.claimNumber,
              softWrap: true,
              maxLines: 2,
              overflow: TextOverflow.fade,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline3!.copyWith(
                fontWeight: FontWeight.w700,
                color: Theme.of(context).primaryColor,
                overflow: TextOverflow.fade,
              ),
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
              CardDetailText(
                title: AppStrings.emailAddress,
                content: widget.claim.email
              ),
            ],
          ),
        ],
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
