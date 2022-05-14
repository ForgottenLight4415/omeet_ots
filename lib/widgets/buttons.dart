import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  const PrimaryButton({
    Key? key,
    required this.onPressed,
    required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label),
      style: ButtonStyle(
        shape: MaterialStateProperty.resolveWith((states) =>
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
        ),
        textStyle: MaterialStateProperty.resolveWith((states) =>
          const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w300,
          )
        ),
        padding: MaterialStateProperty.resolveWith((states) =>
          const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 15.0
          )
        )
      )
    );
  }
}
