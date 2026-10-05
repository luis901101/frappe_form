import 'package:frappe_form/src/presentation/widgets/doc_field_item/base/doc_field_text_field_view.dart';
import 'package:material_ui/material_ui.dart';

/// Created by luis901101 on 04/21/25.
class DocFieldDataView extends DocFieldTextFieldView {
  DocFieldDataView({
    super.key,
    super.controller,
    required super.field,
    super.dependsOnController,
  });

  /// According to the Frappe documentation, the default length of a Data field is 140 characters.
  /// Official documentation: https://docs.frappe.io/erpnext/v14/user/manual/en/customize-erpnext/articles/field-types#data
  /// So, if no maxLength is specified, we use 140 as the default.
  @override
  int? get maxLength => field.maxLength ?? 140;

  @override
  State createState() => DocFieldDataViewState();
}

class DocFieldDataViewState<SF extends DocFieldDataView>
    extends DocFieldTextFieldViewState<SF> {}
