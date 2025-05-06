import 'dart:convert';

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:frappe_form/src/entity/doc_type.dart';
import 'package:frappe_form/src/entity/enumerator/doc_type_type.dart';
import 'package:frappe_form/src/entity/enumerator/field_type.dart';
import 'package:frappe_form/src/logic/utils/num_utils.dart';
import 'package:frappe_form/src/logic/utils/text_utils.dart';
import 'package:frappe_form/src/model/depends_on_eval.dart';
import 'package:json_annotation/json_annotation.dart';

part 'doc_field.g.dart';

@JsonSerializable()
@CopyWith()
class DocField extends DocType {
  @JsonKey(name: "parent")
  final String? parent;
  @JsonKey(name: "parentfield")
  final String? parentField;
  @JsonKey(name: "parenttype")
  final String? parentType;
  @JsonKey(name: "fieldname")
  final String? fieldName;
  @JsonKey(name: "label")
  final String? label;
  @JsonKey(name: "options")
  final String? options;
  @JsonKey(
      name: "fieldtype", unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final FieldType? type;
  @JsonKey(name: "hidden")
  final int? hidden;
  @JsonKey(name: "set_only_once")
  final int? setOnlyOnce;
  @JsonKey(name: "reqd")
  final int? required;
  @JsonKey(name: "bold")
  final int? bold;
  @JsonKey(name: "collapsible")
  final int? collapsible;
  @JsonKey(name: "unique")
  final int? unique;
  @JsonKey(name: "depends_on")
  final String? dependsOn;
  List<DependsOnEval>? _dependsOnEvalList; // Only for cache
  @JsonKey(name: "in_list_view")
  final int? inListView;
  @JsonKey(name: "length")
  final int? length;
  @JsonKey(name: "translatable")
  final int? translatable;
  @JsonKey(name: "hide_days")
  final int? hideDays;
  @JsonKey(name: "hide_seconds")
  final int? hideSeconds;
  @JsonKey(name: "non_negative")
  final int? nonNegative;
  @JsonKey(name: "sort_options")
  final int? sortOptions;
  @JsonKey(name: "default")
  final Object? initial;
  @JsonKey(name: "precision")
  final String? precision;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final List<DocField> children;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final List<String> optionsAsList; // Only for cache

  DocField({
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
    this.parent,
    this.parentField,
    this.parentType,
    this.fieldName,
    this.label,
    this.options,
    this.type,
    this.hidden,
    this.setOnlyOnce,
    this.required,
    this.bold,
    this.collapsible,
    this.unique,
    this.dependsOn,
    this.inListView,
    this.length,
    this.translatable,
    this.hideDays,
    this.hideSeconds,
    this.nonNegative,
    this.sortOptions,
    this.initial,
    this.precision,
    List<DocField>? children,
  })  : children = children ?? [],
        optionsAsList = options?.split('\n').toList() ?? [];

  factory DocField.dummy() => DocField();

  @override
  String get title => label ?? super.title;

  bool get isGroupType => type?.isGroup ?? false;

  bool get isParentGroupType => type?.isParentGroupType ?? false;

  bool get isHidden => hidden.asBool;
  bool get isRequired => required.asBool;
  int? get maxLength => (length ?? 0) == 0 ? null : length!;
  int? get precisionDecimals => precision?.asInt;

  List<DependsOnEval> get dependsOnEvalList =>
      _dependsOnEvalList ??= DependsOnEval.fromExpression(dependsOn);

  DateTime? get defaultAsDateTime => DateTime.tryParse('$initial');

  factory DocField.fromJson(Map<String, dynamic> json) =>
      _$DocFieldFromJson(json);

  factory DocField.fromJsonString(String json) =>
      DocField.fromJson(jsonDecode(json));

  @override
  Map<String, dynamic> toJson() {
    return _$DocFieldToJson(this);
  }
}
