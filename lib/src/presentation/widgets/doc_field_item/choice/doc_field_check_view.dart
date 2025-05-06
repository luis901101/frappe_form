import 'package:frappe_form/frappe_form.dart';
import 'package:flutter/material.dart';

/// Created by luis901101 on 04/21/25.
class DocFieldCheckView extends DocFieldView {
  DocFieldCheckView({
    super.key,
    CustomValueController<int>? controller,
    required super.field,
    super.enableWhenController,
  }) : super(
            controller: controller ??
                CustomValueController<int>(
                  focusNode: FocusNode(),
                ));

  @override
  State createState() => DocFieldCheckViewState();
}

class DocFieldCheckViewState<SF extends DocFieldCheckView>
    extends DocFieldViewState<SF> {
  @override
  CustomValueController<int> get controller =>
      super.controller as CustomValueController<int>;

  @override
  void initState() {
    super.initState();
    if (controller.value == null) {
      final initial = field.initial?.toString().asInt;

      if (initial != null) {
        controller.value = initial;
      }
    }
  }

  int? get selectedValue => controller.value;
  set selectedValue(int? value) => controller.value = value;
  void onSelectedValueChanged(bool? value) {
    setState(() {
      selectedValue = value.asInt;
      controller.clearError();
    });
  }

  bool get isSelected => controller.value.asBool;

  @override
  bool get handleControllerErrorManually => false;

  @override
  EdgeInsetsGeometry get defaultPadding => EdgeInsets.zero;

  @override
  Widget buildBody(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
          dense: false,
          title: Text(field.title),
          value: isSelected,
          onChanged: onSelectedValueChanged,
        ),
        if (handleControllerErrorManually && controller.hasError)
          Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
              right: 8.0,
              top: 4.0,
            ),
            child: Text(
              '${controller.error}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
      ],
    );
  }
}
