import 'package:flutter/material.dart';

class ListItemWithAction extends StatelessWidget {

  // Setup the widget's required parameters
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
    // Build the custom button and return the Widget
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 0.5,
          ),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTapAction,
          child: Padding(
            padding: EdgeInsets.only(
              top: 12,
              bottom: 12,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                leading,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: DefaultTextStyle(
                    child: title,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
              ],
            ),
          )
        ),
      ),
    );
  }

}