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
      padding: const EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
      child: SingleChildScrollView(
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
              ] +
              _allDetails(),
        ),
      ),
    );
  }

  List<Widget> _detailsWidget(String key) {
    Map<String, Map<String, dynamic>> _mainMap = widget.claim.toMap();
    return _mainMap[key]!
        .entries
        .map(
          (entry) => CardDetailText(
            title: entry.key,
            content: entry.value != AppStrings.blank ? entry.value : AppStrings.unavailable,
          ),
        )
        .toList();
  }

  List<Widget> _allDetails() {
    Map<String, Map<String, dynamic>> _mainMap = widget.claim.toMap();
    return _mainMap.entries
        .map(
          (entry) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      entry.key,
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.fade,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).primaryColor,
                            overflow: TextOverflow.fade,
                          ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                ] +
                _detailsWidget(entry.key),
          ),
        )
        .toList();
  }
}
