import 'package:flutter/material.dart';

class MeetDetails extends StatefulWidget {
  const MeetDetails({Key? key}) : super(key: key);

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
    return Container(color: Colors.green);
  }
}
