import 'package:frappe_form/frappe_form.dart';
import 'package:material_ui/material_ui.dart';

/// Created by luis901101 on 04/29/25.
class DocFieldCheckListView extends DocFieldView {
  DocFieldCheckListView({
    super.key,
    required super.field,
    super.children,
    super.dependsOnController,
  }) : super(controller: DummyController());

  @override
  State createState() => DocFieldCheckListViewState();
}

class DocFieldCheckListViewState<SF extends DocFieldCheckListView>
    extends DocFieldViewState<SF> {
  @override
  Widget buildBody(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children.map((itemView) => itemView).toList(),
    );
  }
}
