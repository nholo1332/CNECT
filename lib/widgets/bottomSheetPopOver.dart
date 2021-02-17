import 'package:flutter/material.dart';

class BottomSheetPopOver extends StatelessWidget {
  const BottomSheetPopOver({
    Key key,
    @required this.child,
    @required this.title,
  }) : super(key: key);

  final Widget child;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 25,
        left: 12,
        right: 12,
      ),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildHandle(context),
          Padding(
            padding: EdgeInsets.only(
              top: 5,
              bottom: 5,
            ),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          child,
          SizedBox(height: 25),
        ],
      ),
    );
  }

  Widget buildHandle(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.25,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 12),
        child: Container(
          height: 5,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
        ),
      ),
    );
  }
}