import 'package:frappe_form/frappe_form.dart';
import 'package:material_ui/material_ui.dart';

/// Created by luis901101 on 05/02/25.
class DocFieldHtmlView extends DocFieldView {
  DocFieldHtmlView({super.key, required super.field, super.dependsOnController})
    : super(controller: DummyController());

  @override
  State createState() => DocFieldHtmlViewState();
}

class DocFieldHtmlViewState<SF extends DocFieldHtmlView>
    extends DocFieldViewState<SF> {
  @override
  Widget? buildTitleView(BuildContext context) {
    if (field.title.isEmpty) return null;
    final fieldRadius =
        (theme.inputDecorationTheme.border is OutlineInputBorder)
        ? (theme.inputDecorationTheme.border as OutlineInputBorder).borderRadius
        : const BorderRadius.all(Radius.circular(8));
    return Padding(
      padding: EdgeInsets.only(
        left: fieldRadius.topLeft.x / 2,
        right: fieldRadius.topRight.x / 2,
        bottom: 4.0,
      ),
      child: CustomHtml(
        data: field.title,
        style: theme.textTheme.titleSmall?.asHtmlStyle,
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return field.options.isEmpty
        ? const SizedBox()
        : CustomHtml(
            data: field.options!,
            style: theme.textTheme.bodyMedium?.asHtmlStyle,
          );
  }
}
