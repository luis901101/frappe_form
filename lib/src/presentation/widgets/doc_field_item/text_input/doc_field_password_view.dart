import 'package:frappe_form/src/presentation/widgets/doc_field_item/base/doc_field_text_field_view.dart';
import 'package:material_ui/material_ui.dart';

/// Created by luis901101 on 05/06/25.
class DocFieldPasswordView extends DocFieldTextFieldView {
  DocFieldPasswordView({
    super.key,
    super.controller,
    required super.field,
    super.dependsOnController,
  });

  @override
  State createState() => DocFieldPasswordViewState();
}

class DocFieldPasswordViewState<SF extends DocFieldPasswordView>
    extends DocFieldTextFieldViewState<SF> {
  @override
  bool get obscureText => true;
}
