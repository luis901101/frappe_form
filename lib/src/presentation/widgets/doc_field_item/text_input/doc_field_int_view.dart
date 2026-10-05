import 'package:frappe_form/src/presentation/widgets/doc_field_item/base/doc_field_text_field_view.dart';
import 'package:material_ui/material_ui.dart';
import 'package:frappe_form/src/presentation/utils/validation_utils.dart';

/// Created by luis901101 on 04/23/25.
class DocFieldIntView extends DocFieldTextFieldView {
  DocFieldIntView({
    super.key,
    super.controller,
    required super.field,
    super.dependsOnController,
  });

  @override
  void initController() {
    super.initController();
    controller.validations.addAll([
      ValidationUtils.positiveNumberValidation(required: isRequired),
    ]);
  }

  @override
  State createState() => DocFieldIntViewState();
}

class DocFieldIntViewState<SF extends DocFieldIntView>
    extends DocFieldTextFieldViewState<SF> {
  @override
  TextInputType? get keyboardType =>
      const TextInputType.numberWithOptions(signed: false, decimal: false);
  @override
  TextCapitalization? get textCapitalization => TextCapitalization.none;
}
