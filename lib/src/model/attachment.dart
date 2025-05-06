import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:frappe_form/src/logic/utils/text_utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'attachment.g.dart';

@JsonSerializable()
@CopyWith()
class Attachment {
  /// The media type of the file in the attachment.
  final String? mediaType;

  /// The file path in the local file system for the file, if it is a local file.
  final String? path;

  /// The url of the attachment, if it is a remote file.
  final String? url;

  /// The url of the attachment, if it is a remote file.
  final String? base64;

  Attachment({this.mediaType, this.path, this.url, this.base64});

  bool get isImage => mediaType?.startsWith('image/') ?? false;
  bool get hasSource => path.isNotEmpty || url.isNotEmpty;

  factory Attachment.fromJson(Map<String, dynamic> json) {
    return _$AttachmentFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$AttachmentToJson(this);
  }

  @override
  String toString() => url ?? path ?? base64 ?? '';
}
