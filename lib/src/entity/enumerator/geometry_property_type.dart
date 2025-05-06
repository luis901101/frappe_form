import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

enum GeometryPropertyType {
  @JsonValue('circle')
  circle('circle'),
  @JsonValue('circlemarker')
  circleMarker('circlemarker'),
  ;

  final String name;
  const GeometryPropertyType(this.name);

  static GeometryPropertyType? valueOf(String? name) =>
      GeometryPropertyType.values
          .firstWhereOrNull((value) => value.name == name);
}
