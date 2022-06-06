import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rc_clone/widgets/scaling_tile.dart';

class PrimaryButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  const PrimaryButton({Key? key, required this.onPressed, required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        child: Text(label),
        style: ButtonStyle(
            shape: MaterialStateProperty.resolveWith(
              (states) => RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.0)),
            ),
            textStyle:
                MaterialStateProperty.resolveWith((states) => const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w300,
                    )),
            padding: MaterialStateProperty.resolveWith((states) =>
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0))));
  }
}

class VideoMeetToggleButton extends StatelessWidget {
  final bool toggleParameter;
  final IconData primaryFaIcon;
  final IconData secondaryFaIcon;
  final VoidCallback onPressed;

  const VideoMeetToggleButton(
      {Key? key,
      required this.toggleParameter,
      required this.primaryFaIcon,
      required this.secondaryFaIcon,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScalingTile(
      onPressed: onPressed,
      child: SizedBox(
        height: 70.h,
        width: 70.h,
        child: Card(
          color: toggleParameter ? Colors.red : Colors.white,
          child: Center(
            child: AnimatedCrossFade(
              duration: const Duration(milliseconds: 200),
              crossFadeState: toggleParameter
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              firstChild: FaIcon(
                primaryFaIcon,
                color: Colors.white,
              ),
              secondChild: FaIcon(
                secondaryFaIcon,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
