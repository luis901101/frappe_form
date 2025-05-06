import 'dart:convert';

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:frappe_form/src/entity/doc_field.dart';
import 'package:frappe_form/src/entity/doc_type.dart';
import 'package:frappe_form/src/entity/enumerator/doc_type_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'doc_form.g.dart';

@JsonSerializable()
@CopyWith()
class DocForm extends DocType {
  @JsonKey(name: "fields")
  final List<DocField> fields;

  DocForm({
    super.name,
    super.creation,
    super.modified,
    super.modifiedBy,
    super.owner,
    super.idx,
    super.module,
    super.sortField,
    super.sortOrder,
    super.readOnly,
    super.maxAttachments,
    super.isSubmittable,
    super.showTitleFieldInLink,
    super.translatedDocType,
    super.allowAutoRepeat,
    super.docType,
    super.docStatus,
    super.description,
    List<DocField>? fields,
  }) : fields = fields ?? [];

  Map<String, dynamic> toAnswerMap() => {
        _$DocFormJsonKeys.owner: owner,
        // _$DocFormJsonKeys.modifiedBy: modifiedBy,
        _$DocFormJsonKeys.docStatus: docStatus,
        _$DocFormJsonKeys.idx: idx,
        _$DocFormJsonKeys.docType: name,
      };

  factory DocForm.fromJson(Map<String, dynamic> json) =>
      _$DocFormFromJson(json);

  factory DocForm.fromJsonString(String json) =>
      DocForm.fromJson(jsonDecode(json));

  @override
  Map<String, dynamic> toJson() {
    return _$DocFormToJson(this);
  }
}
