import 'dart:convert';

import 'package:adeptannotations/adeptannotations.dart';
import 'package:frappe_form/src/entity/doc_form.dart';
import 'package:frappe_form/src/entity/doc_type.dart';
import 'package:frappe_form/src/entity/enumerator/doc_type_type.dart';
import 'package:frappe_form/src/entity/enumerator/field_type.dart';
import 'package:frappe_form/src/logic/utils/iterable_utils.dart';
import 'package:frappe_form/src/logic/utils/num_utils.dart';
import 'package:frappe_form/src/logic/utils/text_utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'doc_field.g.dart';

@JsonSerializable()
@CopyWith()
class DocField extends DocType {
  @JsonKey(name: 'parent')
  final String? parent;
  @JsonKey(name: 'parentfield')
  final String? parentField;
  @JsonKey(name: 'parenttype')
  final String? parentType;
  @JsonKey(name: 'fieldname')
  final String? fieldName;
  @JsonKey(name: 'label')
  final String? label;
  @JsonKey(name: 'options')
  final String? options;
  @JsonKey(name: 'fieldtype')
  final String? fieldType;
  @JsonKey(includeFromJson: false, includeToJson: false)
  @CopyWithKey(ignore: true)
  final FieldType type;
  @JsonKey(name: 'hidden')
  final int? hidden;
  @JsonKey(name: 'set_only_once')
  final int? setOnlyOnce;
  @JsonKey(name: 'reqd')
  final int? required;
  @JsonKey(name: 'mandatory_depends_on')
  final String? requiredDependsOn;
  @JsonKey(name: 'bold')
  final int? bold;
  @JsonKey(name: 'collapsible')
  final int? collapsible;
  @JsonKey(name: 'unique')
  final int? unique;
  @JsonKey(name: 'read_only')
  final int? readOnly;
  @JsonKey(name: 'read_only_depends_on')
  final String? readOnlyDependsOn;
  @JsonKey(name: 'depends_on')
  final String? visibilityDependsOn;
  @JsonKey(name: 'in_list_view')
  final int? inListView;
  @JsonKey(name: 'length')
  final int? length;
  @JsonKey(name: 'translatable')
  final int? translatable;
  @JsonKey(name: 'hide_days')
  final int? hideDays;
  @JsonKey(name: 'hide_seconds')
  final int? hideSeconds;
  @JsonKey(name: 'non_negative')
  final int? nonNegative;
  @JsonKey(name: 'sort_options')
  final int? sortOptions;
  @JsonKey(name: 'default')
  final Object? initial;
  @JsonKey(name: 'precision')
  final String? precision;
  @JsonKey(name: 'child_table')
  final Object? childTable;

  /// Hint to show while the field has no value.
  ///
  /// Most field types render it as the input hint text. Attachment fields
  /// interpret it differently: when it is a valid url _(protocol required)_ it
  /// is rendered as a preview image while no file is attached, otherwise it is
  /// used as the semantic label of the attached image.
  @JsonKey(name: 'placeholder')
  final String? placeholder;
  @JsonKey(name: 'render_rules')
  final String? renderRules;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final List<DocField> children;
  @JsonKey(includeFromJson: false, includeToJson: false)
  @CopyWithKey(ignore: true)
  final List<String> optionsAsList;
  @JsonKey(includeFromJson: false, includeToJson: false)
  @CopyWithKey(ignore: true)
  final DateTime? initialAsDateTime;
  @JsonKey(includeFromJson: false, includeToJson: false)
  @CopyWithKey(ignore: true)
  final DocForm? childForm;

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
    FieldType? type,
    String? fieldType,
    this.hidden,
    this.setOnlyOnce,
    this.required,
    this.requiredDependsOn,
    this.bold,
    this.collapsible,
    this.unique,
    this.readOnly,
    this.readOnlyDependsOn,
    this.visibilityDependsOn,
    this.inListView,
    this.length,
    this.translatable,
    this.hideDays,
    this.hideSeconds,
    this.nonNegative,
    this.sortOptions,
    this.initial,
    this.precision,
    this.childTable,
    this.placeholder,
    this.renderRules,
    List<DocField>? children,
  }) : type = type ?? FieldType.valueOf(fieldType) ?? FieldType.unknown,
       fieldType = fieldType ?? type?.name,
       children = children ?? [],
       optionsAsList =
           options
               ?.split('\n')
               .mapWhere((item) => item, (item) => item.isNotEmpty)
               .toList() ??
           [],
       initialAsDateTime = DateTime.tryParse('$initial'),
       childForm = DocForm.fromJsonObject(childTable);

  factory DocField.dummy() => DocField();

  @override
  String get title => label ?? '';

  bool get isReadOnly => readOnly.asBool;

  bool get isGroupType => type.isGroup;

  bool get isParentGroupType => type.isParentGroup;

  bool get isHidden => hidden.asBool;
  bool get isRequired => required.asBool;
  int? get maxLength => (length ?? 0) == 0 ? null : length!;
  int? get precisionDecimals => precision?.asInt;

  @override
  List<Object?> get props => [fieldType, fieldName, name, idx];

  factory DocField.fromJson(Map<String, dynamic> json) =>
      _$DocFieldFromJson(json);

  factory DocField.fromJsonString(String json) =>
      DocField.fromJson(jsonDecode(json));

  @override
  Map<String, dynamic> toJson() {
    return _$DocFieldToJson(this);
  }
}
