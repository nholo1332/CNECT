import 'package:flutter/material.dart';

class LargeRoundedButton extends StatelessWidget {

  LargeRoundedButton({
    this.horizontalMargin = 50,
    @required this.backgroundColor,
    @required this.childWidget,
    @required this.onTapAction,
  });

  final double horizontalMargin;
  final Color backgroundColor;
  final Widget childWidget;
  final GestureTapCallback onTapAction;

  @override
  Widget build(BuildContext context) {
    // Build button and return Widget
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: backgroundColor,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(50),
          child: Center(
            child: childWidget,
          ),
          onTap: onTapAction,
        ),
      ),
    );
  }

}