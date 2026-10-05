import 'package:material_ui/material_ui.dart';
import 'package:frappe_form/frappe_form.dart';

/// Created by luis901101 on 07/25/25.
class DocFieldRadioGroupView extends DocFieldSelectView {
  DocFieldRadioGroupView({
    super.key,
    super.controller,
    required super.field,
    super.dependsOnController,
    super.isOpen,
  });

  @override
  State createState() => DocFieldRadioGroupViewState();
}

class DocFieldRadioGroupViewState<SF extends DocFieldRadioGroupView>
    extends DocFieldSelectViewState<SF> {
  @override
  bool get handleControllerErrorManually => true;

  @override
  Widget get selectView => RadioGroup(
    groupValue: selectedValue,
    onChanged: (String? newValue) {
      if (newValue != null) {
        onSelectedValueChanged(newValue);
      }
    },
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: values
          .map(
            (value) => RadioListTile<String>(
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              title: Text(valueNameResolver(value)),
              value: value,
            ),
          )
          .toList(),
    ),
  );
}
