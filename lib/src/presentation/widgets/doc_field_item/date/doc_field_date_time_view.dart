import 'package:frappe_form/frappe_form.dart';
import 'package:flutter/material.dart';

enum DateTimeType {
  date,
  time,
  dateTime;

  static DateTimeType fromFieldType(FieldType? fieldType) =>
      switch (fieldType) {
        FieldType.date => date,
        FieldType.time => time,
        FieldType.dateTime || _ => dateTime,
      };
  bool get requiresDate => this == date || this == dateTime;
  bool get requiresTime => this == time || this == dateTime;
  bool get isDateTime => this == dateTime;
}

/// Created by luis901101 on 04/21/25.
class DocFieldDateTimeView extends DocFieldView {
  final DateTimeType type;
  DocFieldDateTimeView({
    super.key,
    CustomValueController<DateTime>? controller,
    required super.field,
    required this.type,
    super.enableWhenController,
  }) : super(
            controller: controller ??
                CustomValueController<DateTime>(
                  focusNode: FocusNode(),
                ));

  @override
  State createState() => DocFieldDateTimeViewState();
}

class DocFieldDateTimeViewState
    extends DocFieldViewState<DocFieldDateTimeView> {
  @override
  CustomValueController<DateTime> get controller =>
      super.controller as CustomValueController<DateTime>;
  DateTimeType get type => widget.type;
  DateTime? get dateTime => controller.value;
  set dateTime(DateTime? value) => controller.value = value;

  @override
  void initState() {
    super.initState();
    if (dateTime == null) {
      final DateTime? initial = field.defaultAsDateTime;
      if (initial != null) {
        dateTime = initial;
      }
    }
  }

  @override
  Widget buildBody(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (field.title.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 4.0),
            child: Text(
              field.title,
              style: theme.textTheme.titleSmall,
            ),
          ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (type.requiresDate)
              Expanded(
                flex: 60,
                child: StatefulBuilder(builder: (context, setState) {
                  return ElevatedButton.icon(
                      icon: const Icon(Icons.calendar_month),
                      label: Text(dateTime?.formattedDate() ??
                          DocFormLocalization.instance.localization.textDate),
                      style: ElevatedButton.styleFrom(padding: EdgeInsets.zero),
                      onPressed: openDatePicker);
                }),
              ),
            if (type.isDateTime)
              const Spacer(
                flex: 2,
              ),
            if (type.requiresTime)
              Expanded(
                flex: 40,
                child: StatefulBuilder(builder: (context, setState) {
                  return ElevatedButton.icon(
                      icon: const Icon(Icons.access_time_rounded),
                      label: Text(dateTime?.formattedTime() ??
                          DocFormLocalization.instance.localization.textTime),
                      style: ElevatedButton.styleFrom(padding: EdgeInsets.zero),
                      onPressed: openTimePicker);
                }),
              ),
          ],
        ),
      ],
    );
  }

  Future<void> openDatePicker() async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: dateTime ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (newDate != null) {
      dateTime = dateTime?.copyWith(
            year: newDate.year,
            month: newDate.month,
            day: newDate.day,
          ) ??
          newDate;
      setState(() {});
      if (type.requiresTime) {
        openTimePicker();
      }
    }
  }

  Future<void> openTimePicker() async {
    final newTime = await showTimePicker(
      context: context,
      initialTime: dateTime?.timeOfDay ?? DateTime.now().timeOfDay,
    );
    if (newTime != null) {
      dateTime = (dateTime ?? DateTime.now()).copyWith(
        hour: newTime.hour,
        minute: newTime.minute,
      );
      setState(() {});
    }
  }
}
