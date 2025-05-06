// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doc_field_answer.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DocFieldAnswerCWProxy {
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// DocFieldAnswer(...).copyWith(id: 12, name: "My name")
  /// ````
  DocFieldAnswer call({
    FieldType? type,
    String? name,
    dynamic value,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDocFieldAnswer.copyWith(...)`.
class _$DocFieldAnswerCWProxyImpl implements _$DocFieldAnswerCWProxy {
  const _$DocFieldAnswerCWProxyImpl(this._value);

  final DocFieldAnswer _value;

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// DocFieldAnswer(...).copyWith(id: 12, name: "My name")
  /// ````
  DocFieldAnswer call({
    Object? type = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? value = const $CopyWithPlaceholder(),
  }) {
    return DocFieldAnswer(
      type: type == const $CopyWithPlaceholder()
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as FieldType?,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String?,
      value: value == const $CopyWithPlaceholder()
          ? _value.value
          // ignore: cast_nullable_to_non_nullable
          : value as dynamic,
    );
  }
}

extension $DocFieldAnswerCopyWith on DocFieldAnswer {
  /// Returns a callable class that can be used as follows: `instanceOfDocFieldAnswer.copyWith(...)`.
  // ignore: library_private_types_in_public_api
  _$DocFieldAnswerCWProxy get copyWith => _$DocFieldAnswerCWProxyImpl(this);
}
