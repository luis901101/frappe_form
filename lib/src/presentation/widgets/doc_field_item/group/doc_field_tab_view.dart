import 'package:frappe_form/frappe_form.dart';
import 'package:material_ui/material_ui.dart';

/// Created by luis901101 on 04/23/25.
class DocFieldTabView extends DocFieldView implements PreferredSizeWidget {
  DocFieldTabView({
    super.key,
    required super.field,
    super.children,
    super.dependsOnController,
  }) : super(controller: DummyController());

  @override
  State createState() => DocFieldSectionViewState();

  @override
  Size get preferredSize => Tab(text: field.title).preferredSize;
}

class DocFieldTabItemViewState<SF extends DocFieldTabView>
    extends DocFieldViewState<SF> {
  @override
  Widget? buildTitleView(BuildContext context) => null;

  @override
  Widget buildBody(BuildContext context) {
    return Tab(text: field.title);
  }
}
