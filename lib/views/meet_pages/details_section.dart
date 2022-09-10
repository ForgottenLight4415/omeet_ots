import 'package:flutter/material.dart';
import 'package:rc_clone/views/meet_pages/details.dart';

import '../../data/models/claim.dart';

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
    return ClaimDetails(claim: widget.claim);
  }
}
