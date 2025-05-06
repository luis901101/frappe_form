import 'package:frappe_form/src/presentation/widgets/doc_field_item/base/doc_field_text_field_view.dart';
import 'package:frappe_form/src/presentation/utils/validation_utils.dart';
import 'package:flutter/material.dart';

/// Created by luis901101 on 05/06/25.
class DocFieldPercentView extends DocFieldTextFieldView {
  DocFieldPercentView(
      {super.key,
      super.controller,
      required super.field,
      super.enableWhenController});

  @override
  State createState() => DocFieldPercentViewState();
}

class DocFieldPercentViewState
    extends DocFieldTextFieldViewState<DocFieldPercentView> {
  @override
  void initState() {
    super.initState();
    controller.validations.addAll(
        [ValidationUtils.positiveNumberValidation(required: isRequired)]);
  }

  @override
  TextInputType? get keyboardType =>
      const TextInputType.numberWithOptions(signed: false, decimal: true);
  @override
  TextCapitalization? get textCapitalization => TextCapitalization.none;
}
