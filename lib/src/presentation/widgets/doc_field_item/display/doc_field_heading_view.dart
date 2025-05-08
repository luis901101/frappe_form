import 'package:frappe_form/frappe_form.dart';
import 'package:flutter/material.dart';

/// Created by luis901101 on 05/02/25.
class DocFieldHeadingView extends DocFieldView {
  DocFieldHeadingView({
    super.key,
    required super.field,
    super.enableWhenController,
  }) : super(controller: DummyController());

  @override
  State createState() => DocFieldHeadingViewState();
}

class DocFieldHeadingViewState extends DocFieldViewState<DocFieldHeadingView> {
  @override
  Widget? buildTitleView(BuildContext context) => null;

  @override
  Widget buildBody(BuildContext context) {
    return Text(
      field.title,
      style: theme.textTheme.headlineSmall,
    );
  }
}
