import 'package:flutter/material.dart';

class BottomSheetPopOver extends StatelessWidget {
  const BottomSheetPopOver({
    Key key,
    this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildHandle(context),
          child != null
              ? child
              : Container(),
        ],
      ),
    );
  }

  Widget buildHandle(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.25,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 12.0),
        child: Container(
          height: 5.0,
          decoration: BoxDecoration(
            color: Theme.of(context).dividerColor,
            borderRadius: BorderRadius.all(Radius.circular(2.5)),
          ),
        ),
      ),
    );
  }
}