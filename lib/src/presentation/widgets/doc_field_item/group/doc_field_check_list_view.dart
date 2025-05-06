import 'package:frappe_form/frappe_form.dart';
import 'package:flutter/material.dart';

/// Created by luis901101 on 04/29/25.
class DocFieldCheckListView extends DocFieldView {
  DocFieldCheckListView({
    super.key,
    required super.field,
    super.children,
    super.enableWhenController,
  }) : super(controller: DummyController());

  @override
  State createState() => DocFieldCheckListViewState();
}

class DocFieldCheckListViewState
    extends DocFieldViewState<DocFieldCheckListView> {
  @override
  Widget buildBody(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children?.map((itemView) => itemView).toList() ?? [],
    );
  }
}
