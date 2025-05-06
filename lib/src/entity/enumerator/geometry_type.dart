import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

enum GeometryType {
  @JsonValue('Point')
  point('Point'),
  @JsonValue('LineString')
  lineString('LineString'),
  @JsonValue('Polygon')
  polygon('Polygon'),
  ;

  final String name;
  const GeometryType(this.name);

  static GeometryType? valueOf(String? name) =>
      GeometryType.values.firstWhereOrNull((value) => value.name == name);
}
