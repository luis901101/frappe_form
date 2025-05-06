import 'package:frappe_form/src/logic/enumerator/doc_field_depends_on_operator.dart';
import 'package:frappe_form/src/logic/utils/text_utils.dart';

class DocFieldDependsOnBundle {
  late final DocFieldDependsOnOperator operator;
  final FieldController controller;
  final dynamic expectedAnswer;
  DocFieldDependsOnBundle({
    required this.controller,
    required this.operator,
    required this.expectedAnswer,
  });
}
