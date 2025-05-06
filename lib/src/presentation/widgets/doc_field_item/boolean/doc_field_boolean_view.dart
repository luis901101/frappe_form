import 'package:frappe_form/frappe_form.dart';
import 'package:flutter/material.dart';

/// Created by luis901101 on 04/21/25.
class DocFieldBooleanView extends DocFieldView {
  DocFieldBooleanView({
    super.key,
    CustomValueController<bool>? controller,
    required super.field,
    super.enableWhenController,
  }) : super(
            controller: controller ??
                CustomValueController<bool>(
                  focusNode: FocusNode(),
                ));

  @override
  State createState() => DocFieldBooleanViewState();
}

class DocFieldBooleanViewState extends DocFieldViewState<DocFieldBooleanView> {
  @override
  CustomValueController<bool> get controller =>
      super.controller as CustomValueController<bool>;
  bool get value => controller.value ??= false;
  set value(bool value) => controller.value = value;

  @override
  void initState() {
    super.initState();
    if (controller.value == null) {
      final initial = field.initial?.toString().asBool ?? false;
      value = initial;
    }
  }

  @override
  Widget buildBody(BuildContext context) {
    return SwitchListTile(
      value: value,
      onChanged:
          isReadOnly ? null : (value) => setState(() => this.value = value),
      title: field.title.isEmpty ? null : Text(field.title),
      contentPadding: const EdgeInsets.only(left: 8),
    );
  }
}
