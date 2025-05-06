// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attachment.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AttachmentCWProxy {
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// Attachment(...).copyWith(id: 12, name: "My name")
  /// ````
  Attachment call({
    String? mediaType,
    String? path,
    String? url,
    String? base64,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAttachment.copyWith(...)`.
class _$AttachmentCWProxyImpl implements _$AttachmentCWProxy {
  const _$AttachmentCWProxyImpl(this._value);

  final Attachment _value;

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// Attachment(...).copyWith(id: 12, name: "My name")
  /// ````
  Attachment call({
    Object? mediaType = const $CopyWithPlaceholder(),
    Object? path = const $CopyWithPlaceholder(),
    Object? url = const $CopyWithPlaceholder(),
    Object? base64 = const $CopyWithPlaceholder(),
  }) {
    return Attachment(
      mediaType: mediaType == const $CopyWithPlaceholder()
          ? _value.mediaType
          // ignore: cast_nullable_to_non_nullable
          : mediaType as String?,
      path: path == const $CopyWithPlaceholder()
          ? _value.path
          // ignore: cast_nullable_to_non_nullable
          : path as String?,
      url: url == const $CopyWithPlaceholder()
          ? _value.url
          // ignore: cast_nullable_to_non_nullable
          : url as String?,
      base64: base64 == const $CopyWithPlaceholder()
          ? _value.base64
          // ignore: cast_nullable_to_non_nullable
          : base64 as String?,
    );
  }
}

extension $AttachmentCopyWith on Attachment {
  /// Returns a callable class that can be used as follows: `instanceOfAttachment.copyWith(...)`.
  // ignore: library_private_types_in_public_api
  _$AttachmentCWProxy get copyWith => _$AttachmentCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Attachment _$AttachmentFromJson(Map<String, dynamic> json) => Attachment(
      mediaType: json['mediaType'] as String?,
      path: json['path'] as String?,
      url: json['url'] as String?,
      base64: json['base64'] as String?,
    );

abstract final class _$AttachmentJsonKeys {
  static const String mediaType = 'mediaType';
  static const String path = 'path';
  static const String url = 'url';
  static const String base64 = 'base64';
}

Map<String, dynamic> _$AttachmentToJson(Attachment instance) =>
    <String, dynamic>{
      if (instance.mediaType case final value?) 'mediaType': value,
      if (instance.path case final value?) 'path': value,
      if (instance.url case final value?) 'url': value,
      if (instance.base64 case final value?) 'base64': value,
    };
