import 'package:frappe_form/frappe_form.dart';
import 'package:material_ui/material_ui.dart';

/// Created by luis901101 on 04/21/25.
class DocFieldUrlView extends DocFieldTextFieldView {
  DocFieldUrlView({
    super.key,
    super.controller,
    required super.field,
    super.dependsOnController,
  });

  @override
  State createState() => DocFieldUrlViewState();
}

class DocFieldUrlViewState<SF extends DocFieldUrlView>
    extends DocFieldTextFieldViewState<SF> {
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
