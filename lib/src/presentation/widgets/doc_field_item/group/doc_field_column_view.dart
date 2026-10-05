import 'package:frappe_form/frappe_form.dart';
import 'package:material_ui/material_ui.dart';

/// Created by luis901101 on 04/23/25.
class DocFieldColumnView extends DocFieldView {
  DocFieldColumnView({
    super.key,
    required super.field,
    super.children,
    super.dependsOnController,
  }) : super(controller: DummyController());

  @override
  State createState() => DocFieldColumnViewState();
}

class DocFieldColumnViewState<SF extends DocFieldColumnView>
    extends DocFieldViewState<SF> {
  @override
  Widget? buildTitleView(BuildContext context) => null;

  @override
  Widget? buildDescriptionView(BuildContext context) => null;

  @override
  Widget buildBody(BuildContext context) {
    List<Widget> columnChildren = [
      if (field.description.isNotEmpty)
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: CustomHtml(
            data: field.description!,
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: theme.colorScheme.outline)
                .asHtmlStyle,
          ),
        ),
      ...children,
    ];
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: columnChildren.map((itemView) => itemView).toList(),
    );
  }
}
