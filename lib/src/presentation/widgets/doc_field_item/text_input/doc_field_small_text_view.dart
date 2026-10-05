import 'package:frappe_form/src/presentation/widgets/doc_field_item/base/doc_field_text_field_view.dart';
import 'package:material_ui/material_ui.dart';

/// Created by luis901101 on 04/21/25.
class DocFieldSmallTextView extends DocFieldTextFieldView {
  DocFieldSmallTextView({
    super.key,
    super.controller,
    required super.field,
    super.dependsOnController,
  });

  @override
  State createState() => DocFieldSmallTextViewState();
}

class DocFieldSmallTextViewState<SF extends DocFieldSmallTextView>
    extends DocFieldTextFieldViewState<SF> {
  @override
  TextInputType? get keyboardType => TextInputType.multiline;
  @override
  TextCapitalization? get textCapitalization => TextCapitalization.sentences;
  @override
  int? get maxLines => 4;
}
