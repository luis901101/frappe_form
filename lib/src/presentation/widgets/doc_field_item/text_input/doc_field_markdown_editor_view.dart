import 'package:frappe_form/src/presentation/widgets/doc_field_item/base/doc_field_text_field_view.dart';
import 'package:material_ui/material_ui.dart';

//TODO: must support markdown formatting options
/// Created by luis901101 on 04/23/25.
class DocFieldMarkdownEditorView extends DocFieldTextFieldView {
  DocFieldMarkdownEditorView({
    super.key,
    super.controller,
    required super.field,
    super.dependsOnController,
  });

  @override
  State createState() => DocFieldMarkdownEditorViewState();
}

class DocFieldMarkdownEditorViewState<SF extends DocFieldMarkdownEditorView>
    extends DocFieldTextFieldViewState<SF> {
  @override
  TextInputType? get keyboardType => TextInputType.multiline;
  @override
  TextCapitalization? get textCapitalization => TextCapitalization.sentences;
  @override
  int? get maxLines => 8;
}
