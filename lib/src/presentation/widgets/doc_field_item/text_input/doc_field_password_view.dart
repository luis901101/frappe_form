import 'package:frappe_form/src/presentation/widgets/doc_field_item/base/doc_field_text_field_view.dart';
import 'package:flutter/material.dart';

/// Created by luis901101 on 05/06/25.
class DocFieldPasswordView extends DocFieldTextFieldView {
  DocFieldPasswordView(
      {super.key,
      super.controller,
      required super.field,
      super.enableWhenController});

  @override
  State createState() => DocFieldPasswordViewState();
}

class DocFieldPasswordViewState
    extends DocFieldTextFieldViewState<DocFieldPasswordView> {
  @override
  bool get obscureText => true;
}
