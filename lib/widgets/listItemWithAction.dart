import 'package:flutter/material.dart';

class ListItemWithAction extends StatelessWidget {

  ListItemWithAction({
    @required this.title,
    @required this.leading,
    @required this.onTapAction,
  });

  final Widget title;
  final Widget leading;
  final GestureTapCallback onTapAction;

  @override
  Widget build(BuildContext context) {
    // Build button and return Widget
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 16.0,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 0.5,
          ),
        ),
      ),
      child:  Material(
        color: Colors.transparent,
        child: InkWell(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              leading,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: DefaultTextStyle(
                  child: title,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
            ],
          ),
        ),
      )
    );
  }

}