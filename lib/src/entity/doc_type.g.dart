// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doc_type.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DocTypeCWProxy {
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// DocType(...).copyWith(id: 12, name: "My name")
  /// ````
  DocType call({
    String? name,
    DateTime? creation,
    DateTime? modified,
    String? modifiedBy,
    String? owner,
    int? idx,
    String? module,
    String? sortField,
    String? sortOrder,
    int? readOnly,
    int? maxAttachments,
    int? isSubmittable,
    int? showTitleFieldInLink,
    int? translatedDocType,
    int? allowAutoRepeat,
    DocTypeType? docType,
    int? docStatus,
    String? description,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDocType.copyWith(...)`.
class _$DocTypeCWProxyImpl implements _$DocTypeCWProxy {
  const _$DocTypeCWProxyImpl(this._value);

  final DocType _value;

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// DocType(...).copyWith(id: 12, name: "My name")
  /// ````
  DocType call({
    Object? name = const $CopyWithPlaceholder(),
    Object? creation = const $CopyWithPlaceholder(),
    Object? modified = const $CopyWithPlaceholder(),
    Object? modifiedBy = const $CopyWithPlaceholder(),
    Object? owner = const $CopyWithPlaceholder(),
    Object? idx = const $CopyWithPlaceholder(),
    Object? module = const $CopyWithPlaceholder(),
    Object? sortField = const $CopyWithPlaceholder(),
    Object? sortOrder = const $CopyWithPlaceholder(),
    Object? readOnly = const $CopyWithPlaceholder(),
    Object? maxAttachments = const $CopyWithPlaceholder(),
    Object? isSubmittable = const $CopyWithPlaceholder(),
    Object? showTitleFieldInLink = const $CopyWithPlaceholder(),
    Object? translatedDocType = const $CopyWithPlaceholder(),
    Object? allowAutoRepeat = const $CopyWithPlaceholder(),
    Object? docType = const $CopyWithPlaceholder(),
    Object? docStatus = const $CopyWithPlaceholder(),
    Object? description = const $CopyWithPlaceholder(),
  }) {
    return DocType(
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String?,
      creation: creation == const $CopyWithPlaceholder()
          ? _value.creation
          // ignore: cast_nullable_to_non_nullable
          : creation as DateTime?,
      modified: modified == const $CopyWithPlaceholder()
          ? _value.modified
          // ignore: cast_nullable_to_non_nullable
          : modified as DateTime?,
      modifiedBy: modifiedBy == const $CopyWithPlaceholder()
          ? _value.modifiedBy
          // ignore: cast_nullable_to_non_nullable
          : modifiedBy as String?,
      owner: owner == const $CopyWithPlaceholder()
          ? _value.owner
          // ignore: cast_nullable_to_non_nullable
          : owner as String?,
      idx: idx == const $CopyWithPlaceholder()
          ? _value.idx
          // ignore: cast_nullable_to_non_nullable
          : idx as int?,
      module: module == const $CopyWithPlaceholder()
          ? _value.module
          // ignore: cast_nullable_to_non_nullable
          : module as String?,
      sortField: sortField == const $CopyWithPlaceholder()
          ? _value.sortField
          // ignore: cast_nullable_to_non_nullable
          : sortField as String?,
      sortOrder: sortOrder == const $CopyWithPlaceholder()
          ? _value.sortOrder
          // ignore: cast_nullable_to_non_nullable
          : sortOrder as String?,
      readOnly: readOnly == const $CopyWithPlaceholder()
          ? _value.readOnly
          // ignore: cast_nullable_to_non_nullable
          : readOnly as int?,
      maxAttachments: maxAttachments == const $CopyWithPlaceholder()
          ? _value.maxAttachments
          // ignore: cast_nullable_to_non_nullable
          : maxAttachments as int?,
      isSubmittable: isSubmittable == const $CopyWithPlaceholder()
          ? _value.isSubmittable
          // ignore: cast_nullable_to_non_nullable
          : isSubmittable as int?,
      showTitleFieldInLink: showTitleFieldInLink == const $CopyWithPlaceholder()
          ? _value.showTitleFieldInLink
          // ignore: cast_nullable_to_non_nullable
          : showTitleFieldInLink as int?,
      translatedDocType: translatedDocType == const $CopyWithPlaceholder()
          ? _value.translatedDocType
          // ignore: cast_nullable_to_non_nullable
          : translatedDocType as int?,
      allowAutoRepeat: allowAutoRepeat == const $CopyWithPlaceholder()
          ? _value.allowAutoRepeat
          // ignore: cast_nullable_to_non_nullable
          : allowAutoRepeat as int?,
      docType: docType == const $CopyWithPlaceholder()
          ? _value.docType
          // ignore: cast_nullable_to_non_nullable
          : docType as DocTypeType?,
      docStatus: docStatus == const $CopyWithPlaceholder()
          ? _value.docStatus
          // ignore: cast_nullable_to_non_nullable
          : docStatus as int?,
      description: description == const $CopyWithPlaceholder()
          ? _value.description
          // ignore: cast_nullable_to_non_nullable
          : description as String?,
    );
  }
}

extension $DocTypeCopyWith on DocType {
  /// Returns a callable class that can be used as follows: `instanceOfDocType.copyWith(...)`.
  // ignore: library_private_types_in_public_api
  _$DocTypeCWProxy get copyWith => _$DocTypeCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DocType _$DocTypeFromJson(Map<String, dynamic> json) => DocType(
      name: json['name'] as String?,
      creation: json['creation'] == null
          ? null
          : DateTime.parse(json['creation'] as String),
      modified: json['modified'] == null
          ? null
          : DateTime.parse(json['modified'] as String),
      modifiedBy: json['modified_by'] as String?,
      owner: json['owner'] as String?,
      idx: (json['idx'] as num?)?.toInt(),
      module: json['module'] as String?,
      sortField: json['sort_field'] as String?,
      sortOrder: json['sort_order'] as String?,
      readOnly: (json['read_only'] as num?)?.toInt(),
      maxAttachments: (json['max_attachments'] as num?)?.toInt(),
      isSubmittable: (json['is_submittable'] as num?)?.toInt(),
      showTitleFieldInLink: (json['show_title_field_in_link'] as num?)?.toInt(),
      translatedDocType: (json['translated_doctype'] as num?)?.toInt(),
      allowAutoRepeat: (json['allow_auto_repeat'] as num?)?.toInt(),
      docType: $enumDecodeNullable(_$DocTypeTypeEnumMap, json['doctype'],
          unknownValue: JsonKey.nullForUndefinedEnumValue),
      docStatus: (json['docstatus'] as num?)?.toInt(),
      description: json['description'] as String?,
    );

abstract final class _$DocTypeJsonKeys {
  static const String name = 'name';
  static const String creation = 'creation';
  static const String modified = 'modified';
  static const String modifiedBy = 'modified_by';
  static const String owner = 'owner';
  static const String idx = 'idx';
  static const String module = 'module';
  static const String sortField = 'sort_field';
  static const String sortOrder = 'sort_order';
  static const String readOnly = 'read_only';
  static const String maxAttachments = 'max_attachments';
  static const String isSubmittable = 'is_submittable';
  static const String showTitleFieldInLink = 'show_title_field_in_link';
  static const String translatedDocType = 'translated_doctype';
  static const String allowAutoRepeat = 'allow_auto_repeat';
  static const String docType = 'doctype';
  static const String docStatus = 'docstatus';
  static const String description = 'description';
}

Map<String, dynamic> _$DocTypeToJson(DocType instance) => <String, dynamic>{
      if (instance.name case final value?) 'name': value,
      if (instance.creation?.toIso8601String() case final value?)
        'creation': value,
      if (instance.modified?.toIso8601String() case final value?)
        'modified': value,
      if (instance.modifiedBy case final value?) 'modified_by': value,
      if (instance.owner case final value?) 'owner': value,
      if (instance.idx case final value?) 'idx': value,
      if (instance.module case final value?) 'module': value,
      if (instance.sortField case final value?) 'sort_field': value,
      if (instance.sortOrder case final value?) 'sort_order': value,
      if (instance.readOnly case final value?) 'read_only': value,
      if (instance.maxAttachments case final value?) 'max_attachments': value,
      if (instance.isSubmittable case final value?) 'is_submittable': value,
      if (instance.showTitleFieldInLink case final value?)
        'show_title_field_in_link': value,
      if (instance.translatedDocType case final value?)
        'translated_doctype': value,
      if (instance.allowAutoRepeat case final value?)
        'allow_auto_repeat': value,
      if (_$DocTypeTypeEnumMap[instance.docType] case final value?)
        'doctype': value,
      if (instance.docStatus case final value?) 'docstatus': value,
      if (instance.description case final value?) 'description': value,
    };

const _$DocTypeTypeEnumMap = {
  DocTypeType.docType: 'DocType',
  DocTypeType.docField: 'DocField',
};
