import 'package:frappe_form/frappe_form.dart';
import 'package:material_ui/material_ui.dart';

/// Created by luis901101 on 04/21/25.
class DocFieldBooleanView extends DocFieldView {
  DocFieldBooleanView({
    super.key,
    CustomValueController<bool>? controller,
    required super.field,
    super.dependsOnController,
  }) : super(
         controller:
             controller ?? CustomValueController<bool>(focusNode: FocusNode()),
       );

  @override
  CustomValueController<bool> get controller =>
      super.controller as CustomValueController<bool>;

  @override
  void initController() {
    super.initController();
    controller.value ??= field.initial?.toString().asBool;
  }

  @override
  State createState() => DocFieldBooleanViewState();
}

class DocFieldBooleanViewState<SF extends DocFieldBooleanView>
    extends DocFieldViewState<SF> {
  @override
  CustomValueController<bool> get controller =>
      super.controller as CustomValueController<bool>;
  bool? get value => controller.value;
  set value(bool? value) => controller.value = value;

  @override
  Widget buildBody(BuildContext context) {
    return SwitchListTile(
      value: value ?? false,
      onChanged: isReadOnly
          ? null
          : (value) => setState(() => this.value = value),
      title: field.title.isEmpty ? null : Text(field.title),
      contentPadding: const EdgeInsets.only(left: 8),
    );
  }
}
