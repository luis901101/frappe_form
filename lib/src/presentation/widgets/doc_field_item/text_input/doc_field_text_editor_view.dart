import 'package:flutter/material.dart';
import 'package:frappe_form/src/presentation/widgets/doc_field_item/base/doc_field_text_field_view.dart';
import 'package:html_editor_enhanced/html_editor.dart';

/// Created by luis901101 on 05/06/25.
class DocFieldTextEditorView extends DocFieldTextFieldView {
  DocFieldTextEditorView({
    super.key,
    super.controller,
    required super.field,
    super.enableWhenController,
  });

  @override
  State createState() => DocFieldTextEditorViewState();
}

class DocFieldTextEditorViewState
    extends DocFieldTextFieldViewState<DocFieldTextEditorView> {
  final htmlController = HtmlEditorController();
  @override
  TextInputType? get keyboardType => TextInputType.multiline;
  @override
  TextCapitalization? get textCapitalization => TextCapitalization.sentences;
  @override
  int? get maxLines => 8;

  @override
  Widget buildBody(BuildContext context) {
    final borderColor = theme.inputDecorationTheme.outlineBorder?.color ??
        theme.colorScheme.outline;
    final themeBorder =
        (theme.inputDecorationTheme.border is OutlineInputBorder)
            ? (theme.inputDecorationTheme.border as OutlineInputBorder)
            : null;
    final borderRadius = themeBorder?.borderRadius;
    final border = themeBorder != null
        ? Border.all(color: borderColor)
        : Border(bottom: BorderSide(color: borderColor));
    final fillColor = theme.inputDecorationTheme.fillColor;
    return HtmlEditor(
      controller: htmlController, //required
      callbacks: Callbacks(onChangeContent: (html) {
        controller.text = html ?? '';
      }),
      htmlEditorOptions: HtmlEditorOptions(
        hint: '',
        initialText: controller.text,
        characterLimit: maxLength,
        disabled: isReadOnly,
      ),
      otherOptions: OtherOptions(
          height: 400,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            border: border,
            color: fillColor,
          )),
    );
  }
}
