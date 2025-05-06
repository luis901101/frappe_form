import 'package:frappe_form/src/presentation/widgets/doc_field_item/base/doc_field_text_field_view.dart';
import 'package:frappe_form/src/presentation/utils/validation_utils.dart';
import 'package:flutter/material.dart';

/// Created by luis901101 on 05/06/25.
class DocFieldCurrencyView extends DocFieldTextFieldView {
  DocFieldCurrencyView(
      {super.key,
      super.controller,
      required super.field,
      super.enableWhenController});

  @override
  State createState() => DocFieldCurrencyViewState();
}

class DocFieldCurrencyViewState
    extends DocFieldTextFieldViewState<DocFieldCurrencyView> {
  @override
  void initState() {
    super.initState();
    controller.validations
        .addAll([ValidationUtils.numberValidation(required: isRequired)]);
  }

  @override
  TextInputType? get keyboardType =>
      const TextInputType.numberWithOptions(signed: true, decimal: true);
  @override
  TextCapitalization? get textCapitalization => TextCapitalization.none;
}
