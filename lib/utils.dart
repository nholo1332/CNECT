import 'package:intl/intl.dart';

class Utils {

  static bool isSameDate(DateTime date1, DateTime date2) {
    return date1.day == date2.day &&
        date1.month == date2.month &&
        date1.year == date2.year;
  }

  static String getEventDateText(DateTime start, DateTime end) {
    if ( start.hour > 12 && end.hour > 12 ) {
      return DateFormat('h:mm').format(start) + ' - ' + DateFormat('h:mm').format(end) + ' PM';
    } else if ( start.hour < 12 && end.hour < 12 ) {
      return DateFormat('h:mm').format(start) + ' - ' + DateFormat('h:mm').format(end) + ' AM';
    } else {
      return DateFormat('h:mm a').format(start) + ' - ' + DateFormat('h:mm a').format(end);
    }
  }

  static String getEventLongDateText(DateTime start, DateTime end) {
    String text = '';
    if ( isSameDate(start, end) ) {
      text = DateFormat('EEEE, MMM d').format(start) + ' · ';
      if ( start.hour > 12 && end.hour > 12 ) {
        text += DateFormat('h:mm').format(start) + ' - ' + DateFormat('h:mm').format(end) + ' PM';
      } else if ( start.hour < 12 && end.hour < 12 ) {
        text += DateFormat('h:mm').format(start) + ' - ' + DateFormat('h:mm').format(end) + ' AM';
      } else {
        text += DateFormat('h:mm a').format(start) + ' - ' + DateFormat('h:mm a').format(end);
      }
    } else {
      text = DateFormat('EEEE, MMM d - h:mm a').format(start) + ' · ' + DateFormat('EEEE, MMM d - h:mm a').format(end);
    }

    return text;
  }

}