import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rc_clone/data/models/claim.dart';
import 'package:rc_clone/views/meet_pages/meeting_details.dart';
import 'package:rc_clone/views/meet_pages/meet_documents.dart';
import 'package:rc_clone/views/meet_pages/questions_page.dart';
import 'package:rc_clone/views/meet_pages/video_meet_page.dart';

class MeetingMainPage extends StatefulWidget {
  final Claim claim;

  const MeetingMainPage({Key? key, required this.claim}) : super(key: key);

  @override
  State<MeetingMainPage> createState() => _MeetingMainPageState();
}

class _MeetingMainPageState extends State<MeetingMainPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Meeting with ${widget.claim.insuredName}"),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(icon: FaIcon(FontAwesomeIcons.video), text: "Meet"),
              Tab(icon: FaIcon(FontAwesomeIcons.question), text: "Q & A"),
              Tab(icon: FaIcon(FontAwesomeIcons.file), text: "Documents"),
              Tab(icon: FaIcon(FontAwesomeIcons.info), text: "Details"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            VideoMeetPage(claim: widget.claim),
            QuestionsPage(claimNumber: widget.claim.claimNumber),
            MeetDocumentsScreen(claimNumber: widget.claim.claimNumber),
            const MeetDetails()
          ],
        ),
      ),
    );
  }
}
