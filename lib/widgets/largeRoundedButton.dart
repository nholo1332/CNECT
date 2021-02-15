import 'package:flutter/material.dart';

class LargeRoundedButton extends StatelessWidget {

  LargeRoundedButton({
    @required this.backgroundColor,
    @required this.childWidget,
    @required this.onTapAction,
  });

  final Color backgroundColor;
  final Widget childWidget;
  final GestureTapCallback onTapAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 50),
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