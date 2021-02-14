import 'package:cnect/models/event.dart';
import 'package:cnect/views/event/event.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
                ? getDateText(event.startTime, event.endTime)
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

  String getDateText(DateTime d1, DateTime d2) {
    if ( d1.hour > 12 && d2.hour > 12 ) {
      return DateFormat('h:mm').format(event.startTime) + ' - ' + DateFormat('h:mm').format(event.endTime) + ' PM';
    } else if ( d1.hour < 12 && d2.hour < 12 ) {
      return DateFormat('h:mm').format(event.startTime) + ' - ' + DateFormat('h:mm').format(event.endTime) + ' AM';
    } else {
      return DateFormat('h:mm a').format(event.startTime) + ' - ' + DateFormat('h:mm a').format(event.endTime);
    }
  }
}
