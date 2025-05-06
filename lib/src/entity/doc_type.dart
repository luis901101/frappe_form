import 'dart:convert';

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:frappe_form/src/entity/enumerator/doc_type_type.dart';
import 'package:frappe_form/src/logic/utils/num_utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'doc_type.g.dart';

@JsonSerializable()
@CopyWith()
class DocType {
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "creation")
  final DateTime? creation;
  @JsonKey(name: "modified")
  final DateTime? modified;
  @JsonKey(name: "modified_by")
  final String? modifiedBy;
  @JsonKey(name: "owner")
  final String? owner;
  @JsonKey(name: "idx")
  final int? idx;
  @JsonKey(name: "module")
  final String? module;
  @JsonKey(name: "sort_field")
  final String? sortField;
  @JsonKey(name: "sort_order")
  final String? sortOrder;
  @JsonKey(name: "read_only")
  final int? readOnly;
  @JsonKey(name: "max_attachments")
  final int? maxAttachments;
  @JsonKey(name: "is_submittable")
  final int? isSubmittable;
  @JsonKey(name: "show_title_field_in_link")
  final int? showTitleFieldInLink;
  @JsonKey(name: "translated_doctype")
  final int? translatedDocType;
  @JsonKey(name: "allow_auto_repeat")
  final int? allowAutoRepeat;
  @JsonKey(name: "doctype", unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final DocTypeType? docType;
  @JsonKey(name: "docstatus")
  final int? docStatus;
  @JsonKey(name: "description")
  final String? description;

  DocType({
    this.name,
    this.creation,
    this.modified,
    this.modifiedBy,
    this.owner,
    this.idx,
    this.module,
    this.sortField,
    this.sortOrder,
    this.readOnly,
    this.maxAttachments,
    this.isSubmittable,
    this.showTitleFieldInLink,
    this.translatedDocType,
    this.allowAutoRepeat,
    this.docType,
    this.docStatus,
    this.description,
  });

  bool get isRadOnly => readOnly.asBool;

  String get title => name ?? '';

  factory DocType.fromJson(Map<String, dynamic> json) =>
      _$DocTypeFromJson(json);

  factory DocType.fromJsonString(String json) =>
      DocType.fromJson(jsonDecode(json));

  Map<String, dynamic> toJson() {
    return _$DocTypeToJson(this);
  }
}
