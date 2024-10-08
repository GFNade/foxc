import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:untitled/localization/languages.dart';

extension DateTimeExtension on DateTime {
  String timeAgo({bool numericDates = false}) {
    final date2 = DateTime.now();
    final difference = date2.difference(this);

    if ((difference.inDays / 7).floor() >= 1) {
      var formattedDate = DateFormat('d MMM').format(this);
      return (numericDates) ? '1 week ago' : formattedDate;
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1 day ago' : LKeys.yesterday.tr;
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} hr';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1 hour ago' : LKeys.anHourAgo.tr;
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} min';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1 minute ago' : LKeys.aMinuteAgo.tr;
    } else if (difference.inSeconds >= 3) {
      return LKeys.justNow.tr;
    } else {
      return LKeys.justNow.tr;
    }
  }

  String timeAgoShort() {
    final date2 = DateTime.now();
    final difference = date2.difference(this);

    if ((difference.inDays / 7).floor() >= 1) {
      return '1 w';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays}d';
    } else if (difference.inDays >= 1) {
      return '1 d';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours}hr';
    } else if (difference.inHours >= 1) {
      return '1 hr';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} min';
    } else if (difference.inMinutes >= 1) {
      return '1 min';
    } else if (difference.inSeconds >= 3) {
      return 'now';
    } else {
      return 'now';
    }
  }

  String formatFullDate() {
    return DateFormat("dd MMM yyyy").format(this);
  }
}
