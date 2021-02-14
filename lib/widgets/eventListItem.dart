import 'package:cnect/models/event.dart';
import 'package:cnect/utils.dart';
import 'package:cnect/views/event/event.dart';
import 'package:flutter/material.dart';

class EventListItem extends StatelessWidget {

  EventListItem(this.event, {this.showDate = true});
  final Event event;
  final bool showDate;

  @override
  Widget build(BuildContext context) {
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
