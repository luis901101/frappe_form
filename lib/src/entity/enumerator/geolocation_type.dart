import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

enum GeolocationType {
  @JsonValue('FeatureCollection')
  featureCollection('FeatureCollection'),
  ;

  final String name;
  const GeolocationType(this.name);

  static GeolocationType? valueOf(String? name) =>
      GeolocationType.values.firstWhereOrNull((value) => value.name == name);
}
