import 'package:frappe_form/src/presentation/widgets/doc_field_item/base/doc_field_text_field_view.dart';
import 'package:flutter/material.dart';

/// Created by luis901101 on 04/21/25.
class DocFieldDataView extends DocFieldTextFieldView {
  DocFieldDataView({
    super.key,
    super.controller,
    required super.field,
    super.enableWhenController,
  });

  @override
  State createState() => DocFieldDataViewState();
}

class DocFieldDataViewState
    extends DocFieldTextFieldViewState<DocFieldDataView> {}
