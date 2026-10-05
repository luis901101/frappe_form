import 'package:frappe_form/frappe_form.dart';
import 'package:material_ui/material_ui.dart';

/// Created by luis901101 on 04/21/25.
class DocFieldCheckView extends DocFieldView {
  DocFieldCheckView({
    super.key,
    CustomValueController<int>? controller,
    required super.field,
    super.dependsOnController,
  }) : super(
         controller:
             controller ?? CustomValueController<int>(focusNode: FocusNode()),
       );

  @override
  CustomValueController<int> get controller =>
      super.controller as CustomValueController<int>;

  @override
  void initController() {
    super.initController();
    controller.value ??= field.initial?.toString().asInt;
  }

  @override
  State createState() => DocFieldCheckViewState();
}

class DocFieldCheckViewState<SF extends DocFieldCheckView>
    extends DocFieldViewState<SF> {
  @override
  CustomValueController<int> get controller =>
      super.controller as CustomValueController<int>;

  int? get selectedValue => controller.value;
  set selectedValue(int? value) => controller.value = value;
  void onSelectedValueChanged(bool? value) {
    setState(() {
      selectedValue = value.asInt;
      controller.clearError();
    });
  }

  bool get isSelected => controller.value.asBool;

  @override
  bool get handleControllerErrorManually => false;

  @override
  EdgeInsetsGeometry get defaultPadding => EdgeInsets.zero;

  @override
  Widget? buildTitleView(BuildContext context) => null;

  @override
  Widget buildBody(BuildContext context) {
    return CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
      dense: false,
      title: Text.rich(
        TextSpan(
          children: [
            if (field.title.isNotEmpty) TextSpan(text: field.title),
            if (isRequired)
              TextSpan(
                text: '${field.title.isNotEmpty ? ' ' : ''}*',
                style: TextStyle(color: theme.colorScheme.error),
              ),
          ],
        ),
      ),
      value: isSelected,
      onChanged: onSelectedValueChanged,
      enabled: !isReadOnly,
    );
  }
}
