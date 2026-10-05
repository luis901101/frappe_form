import 'package:frappe_form/src/presentation/widgets/doc_field_item/base/doc_field_text_field_view.dart';
import 'package:frappe_form/src/presentation/utils/validation_utils.dart';
import 'package:material_ui/material_ui.dart';

/// Created by luis901101 on 04/21/25.
class DocFieldFloatView extends DocFieldTextFieldView {
  DocFieldFloatView({
    super.key,
    super.controller,
    required super.field,
    super.dependsOnController,
  });

  @override
  void initController() {
    super.initController();
    controller.validations.addAll([
      ValidationUtils.numberValidation(required: isRequired),
    ]);
  }

  @override
  State createState() => DocFieldFloatViewState();
}

class DocFieldFloatViewState<SF extends DocFieldFloatView>
    extends DocFieldTextFieldViewState<SF> {
  @override
  TextInputType? get keyboardType =>
      const TextInputType.numberWithOptions(signed: true, decimal: true);
  @override
  TextCapitalization? get textCapitalization => TextCapitalization.none;
}
