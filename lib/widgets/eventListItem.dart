import 'package:flutter/material.dart';

import 'package:cnect/models/event.dart';
import 'package:cnect/utils.dart';
import 'package:cnect/views/event/event.dart';

class EventListItem extends StatelessWidget {

  // Setup required paramters
  EventListItem(this.event, {this.showDate = true, this.showCheckMark = false});
  final Event event;
  final bool showDate;
  final bool showCheckMark;

  @override
  Widget build(BuildContext context) {
    // Build list item content
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (c) {
                return EventView(event);
              },
            ),
          );
        },
        child: ListTile(
          trailing: showCheckMark
              ? Icon(
                Icons.check_circle,
                color: Theme.of(context).primaryColor,
              )
              : null,
          title: Text(
            event.name,
            overflow: TextOverflow.fade,
            softWrap: false,
            maxLines: 1,
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          subtitle: Text(
            showDate
                ? Utils.getEventDateText(event.startTime, event.endTime)
                : event.location,
            overflow: TextOverflow.fade,
            softWrap: false,
            maxLines: 1,
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }

}
