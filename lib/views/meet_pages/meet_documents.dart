import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rc_clone/blocs/meet_page_bloc/get_document_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MeetDocumentsScreen extends StatefulWidget {
  final String claimNumber;

  const MeetDocumentsScreen({Key? key, required this.claimNumber}) : super(key: key);

  @override
  State<MeetDocumentsScreen> createState() => _MeetDocumentsScreenState();
}

class _MeetDocumentsScreenState extends State<MeetDocumentsScreen> with AutomaticKeepAliveClientMixin<MeetDocumentsScreen> {

  @override
  bool get wantKeepAlive {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider<GetDocumentCubit>(
      create: (context) => GetDocumentCubit()..getDocuments(widget.claimNumber),
      child: BlocBuilder<GetDocumentCubit, GetDocumentState>(
        builder: (context, state) {
          if (state is GetDocumentReady) {
            if (state.documents.isEmpty) {
              return Center(
                child: Text("No documents",
                  style: TextStyle(
                    fontSize: 22.sp
                  ),
                ),
              );
            }
            return ListView.builder(
                itemCount: state.documents.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Card(
                      child: Container(
                        margin: EdgeInsets.all(10.w),
                        constraints: BoxConstraints(
                          minHeight: 130.h,
                        ),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 3,
                              child: Container(
                                constraints: BoxConstraints(
                                  minHeight: 80.h,
                                ),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(state.documents[index].documentUrl)
                                  )
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 7,
                              child: Padding(
                                padding: EdgeInsets.all(10.w),
                                child: Text(
                                  "Document ${index + 1}",
                                  textAlign: TextAlign.left,
                                  overflow: TextOverflow.fade,
                                  maxLines: 2,
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                });
          } else if (state is GetDocumentFailed) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Exception: ${state.cause} (${state.code})"),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<GetDocumentCubit>(context).getDocuments(widget.claimNumber);
                    },
                    child: const Text("RETRY"),
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  CircularProgressIndicator(),
                  SizedBox(height: 20.0),
                  Text("Fetching details")
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
