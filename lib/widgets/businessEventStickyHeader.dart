import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:intl/intl.dart';

import 'package:cnect/models/event.dart';
import 'package:cnect/providers/globals.dart';
import 'package:cnect/utils.dart';
import 'package:cnect/widgets/eventListItem.dart';

class BusinessEventStickyHeader {

  List<Widget> build(BuildContext context, List<Event> events, String businessName) {
    // Generate the loop of the list
    return List.generate(1, (sliverIndex) {
      return SliverStickyHeader(
        header: Container(
          height: 60,
          color: Theme.of(context).accentColor,
          padding: EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.centerLeft,
          child: Text(
            businessName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate((context, i) =>
            GestureDetector(
              child: Row(
                children: [
                  buildSideHeader(
                    context,
                    events[i].startTime,
                  ),
                  Expanded(
                    child: EventListItem(
                      events[i],
                      showDate: true,
                      showCheckMark: Globals.currentUser.events.where((e) => e.id == events[i].id).isNotEmpty,
                    ),
                  ),
                ],
              ),
            ),
            childCount: events.length,
          ),
        ),
      );
    });
  }

  // Build the side sticky header that shows the date
  Widget buildSideHeader(BuildContext context, DateTime date) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 12,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: SizedBox(
          width: 50,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 0),
                child: Text(
                  DateFormat('EEE').format(date).toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Utils.isSameDate(new DateTime.now(), date)
                        ? Theme.of(context).accentColor
                        : Colors.grey,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              buildDateText(context, date),
            ],
          ),
        ),
      ),
    );
  }

  // Format and build the date text to determine if the date side header needs
  // to have a background color to indicate the today's date/events
  Widget buildDateText(BuildContext context, DateTime date) {
    if ( Utils.isSameDate(new DateTime.now(), date) ) {
      return Container(
        width: 75,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).accentColor,
        ),
        child: Text(
          date.day.toString(),
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      );
    } else {
      return Text(
        date.day.toString(),
        style: TextStyle(fontSize: 22),
        textAlign: TextAlign.center,
      );
    }
  }
}
