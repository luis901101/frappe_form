import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

enum FeatureType {
  @JsonValue('Feature')
  feature('Feature'),
  ;

  final String name;
  const FeatureType(this.name);

  static FeatureType? valueOf(String? name) =>
      FeatureType.values.firstWhereOrNull((value) => value.name == name);
}
