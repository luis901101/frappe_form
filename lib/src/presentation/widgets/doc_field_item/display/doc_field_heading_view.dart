import 'package:frappe_form/frappe_form.dart';
import 'package:material_ui/material_ui.dart';

/// Created by luis901101 on 05/02/25.
class DocFieldHeadingView extends DocFieldView {
  DocFieldHeadingView({
    super.key,
    required super.field,
    super.dependsOnController,
  }) : super(controller: DummyController());

  @override
  State createState() => DocFieldHeadingViewState();
}

class DocFieldHeadingViewState<SF extends DocFieldHeadingView>
    extends DocFieldViewState<SF> {
  @override
  Widget? buildTitleView(BuildContext context) => null;

  @override
  Widget buildBody(BuildContext context) {
    return CustomHtml(
      data: field.title,
      style: theme.textTheme.headlineSmall?.asHtmlStyle,
    );
  }
}
