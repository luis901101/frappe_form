import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

enum DocTypeType {
  @JsonValue('DocType')
  docType('DocType'),
  @JsonValue('DocField')
  docField('DocField'),
  ;

  final String name;
  const DocTypeType(this.name);

  static DocTypeType? valueOf(String? name) =>
      DocTypeType.values.firstWhereOrNull((value) => value.name == name);
}
