import 'package:frappe_form/frappe_form.dart';
import 'package:material_ui/material_ui.dart';

extension CustomTimeUtils on TimeOfDay {
  String toJson() {
    final String hourLabel = hour.asTwoDigits;
    final String minuteLabel = minute.asTwoDigits;
    return '$hourLabel:$minuteLabel:00';
  }
}
