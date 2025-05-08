import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:frappe_form/frappe_form.dart';

/// Created by luis901101 on 04/21/25.
class DocFieldSelectView extends DocFieldView {
  final bool isOpen;
  DocFieldSelectView({
    super.key,
    CustomValueController<String>? controller,
    required super.field,
    super.enableWhenController,
    this.isOpen = false,
  }) : super(
            controller: controller ??
                CustomValueController<String>(
                  focusNode: FocusNode(),
                ));

  @override
  State createState() => DocFieldSelectViewState();
}

class DocFieldSelectViewState<SF extends DocFieldSelectView>
    extends DocFieldViewState<SF> {
  @override
  CustomValueController<String> get controller =>
      super.controller as CustomValueController<String>;
  final List<String> values = [];
  @override
  void initState() {
    super.initState();
    values.addAll(field.optionsAsList);
    if (controller.value == null) {
      final initial = field.initial?.toString();

      if (initial.isNotEmpty) {
        controller.value = initial;
      }
    }
  }

  String? get selectedValue => controller.value;
  set selectedValue(String? value) => controller.value = value;
  void onSelectedValueChanged(String? value) {
    setState(() {
      controller.clearError();
      selectedValue = value;
    });
  }

  @override
  bool get wantKeepAlive => isOpen;

  bool get isOpen => widget.isOpen;
  String valueNameResolver(String value) => value;

  String onOpenAnswerAdded(String value, {bool? hideKeyboard}) {
    hideKeyboard ??= true;
    String newAnswer;
    final existingAnswer = values.firstWhereOrNull((answer) => answer == value);
    if (existingAnswer == null) {
      newAnswer = value;
      values.add(newAnswer);
    } else {
      newAnswer = existingAnswer;
    }

    if (hideKeyboard) {
      InputMethodUtils.hideInputMethod(force: true);
    }
    controller.clearError();
    return selectedValue = newAnswer;
  }

  @override
  bool get handleControllerErrorManually => false;

  @override
  Widget buildBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomDropDownButtonFormField.buildDropDown<String>(
          controller: controller,
          values: values,
          onChanged: onSelectedValueChanged,
          nameResolver: valueNameResolver,
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
        if (isOpen) ...[
          const SizedBox(height: 8.0),
          Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
              right: 8.0,
              bottom: 4.0,
            ),
            child: Text(
              DocFormLocalization.instance.localization.textOtherOption,
              style: theme.textTheme.titleSmall,
            ),
          ),
          CustomTextField(
            focusNode: controller.focusNode,
            enabled: !isReadOnly,
            maxLength: maxLength,
            customButtonIcon: Icons.add,
            customButtonColor: theme.colorScheme.primary,
            customButtonAction: (controller) {
              if (controller.isNotEmpty) {
                onOpenAnswerAdded(controller.text);
                controller.clear();
                setState(() {});
              }
            },
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.sentences,
          ),
        ]
      ],
    );
  }
}
