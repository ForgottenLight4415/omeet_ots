import 'package:flutter/material.dart';
import 'package:simple_connection_checker/simple_connection_checker.dart';

Future<bool> checkConnection(BuildContext context) async {
  if (!await SimpleConnectionChecker
      .isConnectedToInternet()) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title:
            const Text("No internet"),
            content: const Text(
              "Look like you are offline!\nCheck if your WiFi or mobile data is turned on and if you have access to the internet.",
              textAlign: TextAlign.justify,
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("OK"),
              )
            ],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0)
            ),
          );
        });
    return false;
  }
  return true;
}