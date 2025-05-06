import 'package:frappe_form/src/presentation/widgets/doc_field_item/base/doc_field_text_field_view.dart';
import 'package:flutter/material.dart';

/// Created by luis901101 on 04/23/25.
class DocFieldLongTextView extends DocFieldTextFieldView {
  DocFieldLongTextView(
      {super.key,
      super.controller,
      required super.field,
      super.enableWhenController});

  @override
  State createState() => DocFieldLongTextViewState();
}

class DocFieldLongTextViewState
    extends DocFieldTextFieldViewState<DocFieldLongTextView> {
  @override
  TextInputType? get keyboardType => TextInputType.multiline;
  @override
  TextCapitalization? get textCapitalization => TextCapitalization.sentences;
  @override
  int? get maxLines => 8;
}
