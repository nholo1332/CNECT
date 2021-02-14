import 'package:cnect/models/event.dart';
import 'package:cnect/utils.dart';
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