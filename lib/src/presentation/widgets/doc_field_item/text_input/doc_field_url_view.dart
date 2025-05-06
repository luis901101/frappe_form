import 'package:frappe_form/frappe_form.dart';
import 'package:flutter/material.dart';

/// Created by luis901101 on 04/21/25.
class DocFieldUrlView extends DocFieldTextFieldView {
  DocFieldUrlView({
    super.key,
    super.controller,
    required super.field,
    super.enableWhenController,
  });

  @override
  State createState() => DocFieldUrlViewState();
}

class DocFieldUrlViewState extends DocFieldTextFieldViewState<DocFieldUrlView> {
  @override
  void initState() {
    super.initState();
    controller.validations.add(ValidationUtils.urlValidation());
  }

  @override
  TextInputType? get keyboardType => TextInputType.url;
  @override
  TextCapitalization? get textCapitalization => TextCapitalization.none;
  @override
  int? get maxLines => 1;
}
