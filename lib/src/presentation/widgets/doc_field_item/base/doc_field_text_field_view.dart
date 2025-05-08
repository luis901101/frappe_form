import 'package:frappe_form/frappe_form.dart';
import 'package:flutter/material.dart';

/// Created by luis901101 on 04/21/25.
abstract class DocFieldTextFieldView extends DocFieldView {
  DocFieldTextFieldView({
    super.key,
    CustomTextEditingController? controller,
    required super.field,
    super.enableWhenController,
  }) : super(
            controller: controller ??
                CustomTextEditingController(
                  focusNode: FocusNode(),
                ));
}

abstract class DocFieldTextFieldViewState<SF extends DocFieldTextFieldView>
    extends DocFieldViewState<SF> {
  @override
  CustomTextEditingController get controller =>
      super.controller as CustomTextEditingController;
  @override
  void initState() {
    super.initState();
    if (controller.text.isEmpty) {
      final initial = field.initial?.toString();

      if (initial.isNotEmpty) {
        controller.text = initial!;
      }
    }

    controller.validations.addAll([
      if ((maxLength ?? 0) > 0)
        ValidationUtils.maxLengthValidation(maxLength: maxLength!),
    ]);
  }

  TextInputType? get keyboardType => TextInputType.text;
  TextInputAction? get textInputAction => TextInputAction.next;
  TextCapitalization? get textCapitalization => TextCapitalization.sentences;
  int? get maxLines => null;
  bool get obscureText => false;
  String? get obscuringCharacter => null;
  int get formatDecimals => field.precisionDecimals ?? 0;

  @override
  bool get handleControllerErrorManually => false;

  @override
  Widget buildBody(BuildContext context) {
    return CustomTextField(
      controller: controller,
      focusNode: controller.focusNode,
      enabled: !isReadOnly,
      maxLength: maxLength,
      maxLines: maxLines,
      textInputAction:
          (maxLines != null && maxLines! > 1) ? null : textInputAction,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      inputFormatters: formatDecimals > 0
          ? [
              DecimalTextInputFormatter(
                  decimals: formatDecimals,
                  allowSigned: keyboardType?.signed ?? false),
            ]
          : null,
      obscuringCharacter: obscuringCharacter,
      customButtonDefaultAction:
          obscureText ? CustomButtonDefaultAction.passwordToggle : null,
    );
  }
}
