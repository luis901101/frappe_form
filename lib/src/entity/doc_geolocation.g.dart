// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doc_geolocation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DocGeolocation _$DocGeolocationFromJson(Map<String, dynamic> json) =>
    DocGeolocation(
      type: $enumDecodeNullable(_$GeolocationTypeEnumMap, json['type'],
          unknownValue: JsonKey.nullForUndefinedEnumValue),
      features: (json['features'] as List<dynamic>?)
          ?.map((e) => Features.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

abstract final class _$DocGeolocationJsonKeys {
  static const String type = 'type';
  static const String features = 'features';
}

Map<String, dynamic> _$DocGeolocationToJson(DocGeolocation instance) =>
    <String, dynamic>{
      if (_$GeolocationTypeEnumMap[instance.type] case final value?)
        'type': value,
      if (instance.features case final value?) 'features': value,
    };

const _$GeolocationTypeEnumMap = {
  GeolocationType.featureCollection: 'FeatureCollection',
};

Features _$FeaturesFromJson(Map<String, dynamic> json) => Features(
      type: $enumDecodeNullable(_$FeatureTypeEnumMap, json['type'],
          unknownValue: JsonKey.nullForUndefinedEnumValue),
      properties: json['properties'] == null
          ? null
          : GeometryProperty.fromJson(
              json['properties'] as Map<String, dynamic>),
      geometry: json['geometry'] == null
          ? null
          : Geometry.fromJson(json['geometry'] as Map<String, dynamic>),
    );

abstract final class _$FeaturesJsonKeys {
  static const String type = 'type';
  static const String properties = 'properties';
  static const String geometry = 'geometry';
}

Map<String, dynamic> _$FeaturesToJson(Features instance) => <String, dynamic>{
      if (_$FeatureTypeEnumMap[instance.type] case final value?) 'type': value,
      if (instance.properties case final value?) 'properties': value,
      if (instance.geometry case final value?) 'geometry': value,
    };

const _$FeatureTypeEnumMap = {
  FeatureType.feature: 'Feature',
};

Geometry _$GeometryFromJson(Map<String, dynamic> json) => Geometry(
      type: $enumDecodeNullable(_$GeometryTypeEnumMap, json['type'],
          unknownValue: JsonKey.nullForUndefinedEnumValue),
      coordinates: (json['coordinates'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
    );

abstract final class _$GeometryJsonKeys {
  static const String type = 'type';
  static const String coordinates = 'coordinates';
}

Map<String, dynamic> _$GeometryToJson(Geometry instance) => <String, dynamic>{
      if (_$GeometryTypeEnumMap[instance.type] case final value?) 'type': value,
      if (instance.coordinates case final value?) 'coordinates': value,
    };

const _$GeometryTypeEnumMap = {
  GeometryType.point: 'Point',
  GeometryType.lineString: 'LineString',
  GeometryType.polygon: 'Polygon',
};

GeometryProperty _$GeometryPropertyFromJson(Map<String, dynamic> json) =>
    GeometryProperty(
      pointType: $enumDecodeNullable(
          _$GeometryPropertyTypeEnumMap, json['point_type'],
          unknownValue: JsonKey.nullForUndefinedEnumValue),
      radius: (json['radius'] as num?)?.toDouble(),
    );

abstract final class _$GeometryPropertyJsonKeys {
  static const String pointType = 'point_type';
  static const String radius = 'radius';
}

Map<String, dynamic> _$GeometryPropertyToJson(GeometryProperty instance) =>
    <String, dynamic>{
      if (_$GeometryPropertyTypeEnumMap[instance.pointType] case final value?)
        'point_type': value,
      if (instance.radius case final value?) 'radius': value,
    };

const _$GeometryPropertyTypeEnumMap = {
  GeometryPropertyType.circle: 'circle',
  GeometryPropertyType.circleMarker: 'circlemarker',
};
