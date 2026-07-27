import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:frappe_form/frappe_form.dart';

/// Created by luis901101 on 06/21/25.
class DocFieldSelectView extends DocFieldView {
  final bool isOpen;
  DocFieldSelectView({
    super.key,
    CustomValueController<String>? controller,
    required super.field,
    super.dependsOnController,
    this.isOpen = false,
  }) : super(
         controller:
             controller ??
             CustomValueController<String>(focusNode: FocusNode()),
       );

  @override
  CustomValueController<String> get controller =>
      super.controller as CustomValueController<String>;

  @override
  void initController() {
    super.initController();
    if (controller.value == null) {
      final initial = field.initial?.toString();
      if (initial.isNotEmpty) {
        controller.value = initial;
      }
    }
  }

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

  Widget get selectView => CustomDropDownButtonFormField.buildDropDown<String>(
    controller: controller,
    values: values,
    disabled: isReadOnly,
    onChanged: onSelectedValueChanged,
    nameResolver: valueNameResolver,
    inputDecoration: InputDecoration(hintText: placeholder),
  );

  @override
  Widget buildBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        selectView,
        if (isOpen) ...[
          const SizedBox(height: 8.0),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 4.0),
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
        ],
      ],
    );
  }
}
