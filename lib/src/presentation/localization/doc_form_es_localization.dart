import 'dart:ui';

import 'package:frappe_form/src/presentation/localization/doc_form_base_localization.dart';

/// Spanish localizations
class DocFormEsLocalization extends DocFormBaseLocalization {
  DocFormEsLocalization() : super(Locale('es', 'ES'));

  @override
  String get btnSubmit => 'Enviar';
  @override
  String get btnUpload => 'Cargar';
  @override
  String get btnChange => 'Cambiar';
  @override
  String get btnRemove => 'Quitar';
  @override
  String get textOtherOption => 'Optra opción';
  @override
  String get textDate => 'Fecha';
  @override
  String get textTime => 'Hora';
  @override
  String get textLatitude => 'Latitud';
  @override
  String get textLongitude => 'Longitud';
  @override
  String get textPhone => 'Teléfono';
  @override
  String get textSearchPhoneCountryCode =>
      'Nombre del país o código de marcación';
  @override
  String get exceptionNoEmptyField => 'Este campo es requerido.';
  @override
  String get exceptionValueMustBeAPositiveIntegerNumber =>
      'El valor debe ser un número entero positivo.';
  @override
  String get exceptionValueMustBeAPositiveNumber =>
      'El valor debe ser un número positivo.';
  @override
  String get exceptionValueMustBeANumber =>
      'El valor debe ser un número positivo.';
  @override
  String get exceptionInvalidUrl => 'Url inválida.';
  @override
  String get exceptionInvalidPhoneNumber => 'Número de teléfono inválido.';
  @override
  String exceptionValueOutOfRange(dynamic minValue, dynamic maxValue) =>
      'El valor debe estar en un rango de $minValue a $maxValue.';
  @override
  String exceptionTextLength(dynamic minLength, dynamic maxLength) =>
      'El texto debe tener al menos $minLength caracteres y $maxLength como máximo.';
  @override
  String exceptionTextMaxLength(dynamic maxLength) =>
      'El texto debe tener $maxLength caracteres como máximo.';
}
