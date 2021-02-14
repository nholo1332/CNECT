import 'package:cnect/models/event.dart';
import 'package:cnect/widgets/eventListItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:intl/intl.dart';

class DateStickyHeader {

  List<Widget> buildSideHeaderGrids(BuildContext context, int firstIndex, int count, List<Event> events) {
    return List.generate(1, (sliverIndex) {
      sliverIndex += firstIndex;
      return SliverStickyHeader(
        overlapsContent: true,
        header: buildSideHeader(
          context,
          sliverIndex,
          events,
        ),
        sliver: SliverPadding(
          padding: EdgeInsets.only(left: 60),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, i) =>
              GestureDetector(
                child: EventListItem(
                  events[firstIndex + i],
                  showDate: true,
                ),
              ),
              childCount: count,
            ),
          ),
        ),
      );
    });
  }

  Widget buildSideHeader(BuildContext context, int index, List<Event> events) {
    var date = events[index].startTime;
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
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Text(
                date.day.toString(),
                style: TextStyle(fontSize: 22),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
