import 'package:frappe_form/frappe_form.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

extension CustomDateUtils on DateTime {
  static const formattedDateFormat = 'EEE, d MMM yyyy';
  static const formattedTimeFormat = 'h:mm a';

  String toJsonTime() => timeOfDay.toJson();

  String toJsonDate() {
    final String monthLabel = month.asTwoDigits;
    final String dayLabel = day.asTwoDigits;
    return '$year-$monthLabel-$dayLabel';
  }

  String toJsonDateTime() {
    final temp = toUtc();
    return '${temp.toJsonDate()} ${temp.toJsonTime()}';
  }

  DateTime get flatMonth => DateTime(year, month);
  DateTime get flatDay => DateTime(year, month, day);

  TimeOfDay get timeOfDay => TimeOfDay(hour: hour, minute: minute);

  String formattedDate() => format();
  String formattedTime() => format(format: formattedTimeFormat);

  String format({String format = formattedDateFormat}) {
    try {
      return intl.DateFormat(format).format(this);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      try {
        return intl.DateFormat(format).format(this);
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
        return intl.DateFormat().format(this);
      }
    }
  }
}
