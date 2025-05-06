import 'dart:ui';

import 'package:frappe_form/src/presentation/localization/doc_form_base_localization.dart';
import 'package:frappe_form/src/presentation/localization/doc_form_en_localization.dart';
import 'package:frappe_form/src/presentation/localization/doc_form_es_localization.dart';

class DocFormLocalization {
  static final instance = DocFormLocalization();
  DocFormBaseLocalization localization = DocFormEnLocalization();
  DocFormBaseLocalization _defaultLocalization = DocFormEnLocalization();
  final Map<String, DocFormBaseLocalization> _localizationsMap = {
    'en': DocFormEnLocalization(),
    'es': DocFormEsLocalization(),
  };
  DocFormLocalization();

  void init({
    DocFormBaseLocalization? defaultLocalization,
    List<DocFormBaseLocalization>? localizations,
    Locale? locale,
  }) {
    if (defaultLocalization != null) {
      _defaultLocalization = defaultLocalization;
    }
    if (localizations != null) {
      for (final localization in localizations) {
        _localizationsMap[localization.locale.toLanguageTag()] = localization;
      }
    }
    if (locale != null) {
      localization = _localizationsMap[locale.toLanguageTag()] ??
          _localizationsMap[locale.languageCode] ??
          _defaultLocalization;
    }
  }
}
