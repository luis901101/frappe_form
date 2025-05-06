import 'dart:convert';

import 'package:frappe_form/src/entity/enumerator/feature_type.dart';
import 'package:frappe_form/src/entity/enumerator/geolocation_type.dart';
import 'package:frappe_form/src/entity/enumerator/geometry_property_type.dart';
import 'package:frappe_form/src/entity/enumerator/geometry_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'doc_geolocation.g.dart';

@JsonSerializable()
class DocGeolocation {
  @JsonKey(name: "type", unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final GeolocationType? type;
  @JsonKey(name: "features")
  final List<Features>? features;

  DocGeolocation({
    this.type,
    this.features,
  });

  factory DocGeolocation.fromLatLng(
      {required double latitude, required double longitude}) {
    return DocGeolocation(type: GeolocationType.featureCollection, features: [
      Features(
        type: FeatureType.feature,
        geometry: Geometry(
          type: GeometryType.point,
          coordinates: [longitude, latitude],
        ),
      )
    ]);
  }

  factory DocGeolocation.fromJson(Map<String, dynamic> json) {
    return _$DocGeolocationFromJson(json);
  }

  factory DocGeolocation.fromJsonString(String json) =>
      DocGeolocation.fromJson(jsonDecode(json));

  Map<String, dynamic> toJson() {
    return _$DocGeolocationToJson(this);
  }

  String toJsonString() => jsonEncode(toJson());

  @override
  String toString() => toJsonString();
}

@JsonSerializable()
class Features {
  @JsonKey(name: "type", unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final FeatureType? type;
  @JsonKey(name: "properties")
  final GeometryProperty? properties;
  @JsonKey(name: "geometry")
  final Geometry? geometry;

  Features({
    this.type,
    this.properties,
    this.geometry,
  });

  factory Features.fromJson(Map<String, dynamic> json) {
    return _$FeaturesFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$FeaturesToJson(this);
  }
}

@JsonSerializable()
class Geometry {
  @JsonKey(name: "type", unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final GeometryType? type;
  @JsonKey(name: "coordinates")
  final List<double>? coordinates;

  Geometry({
    this.type,
    this.coordinates,
  });

  factory Geometry.fromJson(Map<String, dynamic> json) {
    return _$GeometryFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$GeometryToJson(this);
  }
}

@JsonSerializable()
class GeometryProperty {
  @JsonKey(
      name: "point_type", unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final GeometryPropertyType? pointType;
  @JsonKey(name: "radius")
  final double? radius;

  GeometryProperty({
    this.pointType,
    this.radius,
  });

  factory GeometryProperty.fromJson(Map<String, dynamic> json) {
    return _$GeometryPropertyFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$GeometryPropertyToJson(this);
  }
}
