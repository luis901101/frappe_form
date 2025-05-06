import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:frappe_form/src/entity/enumerator/field_type.dart';
import 'package:frappe_form/src/logic/utils/text_utils.dart';

part 'doc_field_answer.g.dart';

@CopyWith()
class DocFieldAnswer {
  final FieldType? type;
  final String? name;
  final dynamic value;

  DocFieldAnswer({required this.type, this.name, this.value});

  Map<String, dynamic> toAnswerMap() {
    if (!(type?.isAnswerable ?? false) ||
        name.isEmpty /*|| (fieldValue?.toString().isEmpty ?? true)*/) {
      return {};
    }
    return {
      name!: (value?.toString().isEmpty ?? true) ? null : value,
    };
  }
}
