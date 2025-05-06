import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:example/attachment_utils.dart';
import 'package:example/doc_form_samples.dart';
import 'package:frappe_form/frappe_form.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

StreamController<InputDecorationTheme?> inputDecorationThemeStream =
    StreamController<InputDecorationTheme>.broadcast();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<InputDecorationTheme?>(
      stream: inputDecorationThemeStream.stream,
      initialData: null,
      builder: (context, snapshot) {
        return MaterialApp(
          title: 'Frappe Doc Form Demo',
          scrollBehavior: const CustomScrollBehavior(),
          theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
              useMaterial3: true,
              inputDecorationTheme: snapshot.data),
          home: const MyHomePage(),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<({String name, Locale? value})> locales = [
    (name: 'System default', value: null),
    (name: 'English', value: Locale('en', 'US')),
    (name: 'Spanish', value: Locale('es', 'ES')),
    (name: 'French', value: Locale('fr', 'FR')),
  ];
  final List<({String name, int value})> forms = [
    (name: 'Generic', value: 0),
  ];
  final List<({String name, InputDecorationTheme value})>
      inputDecorationThemes = [
    (name: 'Default', value: const InputDecorationTheme()),
    (
      name: 'Outline',
      value: const InputDecorationTheme(
        contentPadding: EdgeInsets.only(left: 16, top: 12, bottom: 12),
        border: OutlineInputBorder(),
      )
    ),
    (
      name: 'Outline Stretched Rounded',
      value: const InputDecorationTheme(
        contentPadding: EdgeInsets.only(left: 16, top: 12, bottom: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(28)),
        ),
      )
    ),
    (
      name: 'Outline Stretched Rounded Filled',
      value: const InputDecorationTheme(
        contentPadding: EdgeInsets.only(left: 16, top: 12, bottom: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(28)),
        ),
        filled: true,
      )
    ),
    (
      name: 'Outline Stretched Rounded Filled No Borders',
      value: const InputDecorationTheme(
        contentPadding: EdgeInsets.only(left: 16, top: 12, bottom: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(28)),
          borderSide: BorderSide(
            style: BorderStyle.none,
            width: 0,
          ),
        ),
        isDense: true,
        alignLabelWithHint: true,
        filled: true,
      )
    ),
  ];
  Locale? selectedLocale;
  int selectedForm = 0;
  InputDecorationTheme? selectedInputDecorationTheme = InputDecorationTheme();
  final extraLocalizations = [DocFormFrLocalization()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Frappe Doc Form Demo'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButtonFormField<int>(
                  decoration: const InputDecoration(
                      label: Text('Select a Form sample')),
                  value: selectedForm,
                  items: forms
                      .map((e) => DropdownMenuItem<int>(
                            value: e.value,
                            child: Text(e.name),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      selectedForm = value;
                    }
                  }),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<Locale?>(
                  decoration: const InputDecoration(
                      label: Text('Select the Form locale')),
                  value: selectedLocale,
                  items: locales
                      .map((e) => DropdownMenuItem<Locale>(
                            value: e.value,
                            child: Text(e.name),
                          ))
                      .toList(),
                  onChanged: (value) {
                    selectedLocale = value;
                  }),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<InputDecorationTheme?>(
                  decoration: const InputDecoration(
                      label: Text('Select input decoration theme ')),
                  value: selectedInputDecorationTheme,
                  items: inputDecorationThemes
                      .map((e) => DropdownMenuItem<InputDecorationTheme>(
                            value: e.value,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.78,
                              child: Text(e.name),
                            ),
                          ))
                      .toList(),
                  onChanged: (value) {
                    selectedInputDecorationTheme = value;
                    inputDecorationThemeStream
                        .add(selectedInputDecorationTheme);
                  }),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        extendedPadding: const EdgeInsets.symmetric(horizontal: 32.0),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DocFormPage(
                  form: form,
                  locale: selectedLocale,
                  localizations: extraLocalizations,
                ),
              ));
        },
        label: const Text('Open Form'),
      ),
    );
  }

  DocForm get form => DocForm.fromJsonString(switch (selectedForm) {
        0 || _ => DocFormSamples.sampleGeneric,
      });
}

class DocFormPage extends StatefulWidget {
  final DocForm form;
  final Locale? locale;
  final List<DocFormBaseLocalization>? localizations;
  const DocFormPage({
    super.key,
    required this.form,
    this.locale,
    this.localizations,
  });

  @override
  State createState() => DocFormPageState();
}

class DocFormPageState extends State<DocFormPage> {
  bool loading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(
        const Duration(seconds: 1), () => setState(() => loading = false));
  }

  @override
  Widget build(BuildContext context) {
    return DocFormView(
      key: ValueKey(loading),
      form: widget.form,
      onAttachmentLoaded: onAttachmentLoaded,
      locale: widget.locale,
      localizations: widget.localizations,
      isLoading: loading,
      onSubmit: onSubmit,
    );
  }

  Future<Attachment?> onAttachmentLoaded() async {
    return AttachmentUtils.pickAttachment(context);
  }

  void onSubmit(Map<String, dynamic> formResponse) async {
    Navigator.pop(context);
    var prettyString = const JsonEncoder.withIndent('  ').convert(formResponse);

    debugPrint('''
      ========================================================================
      $prettyString
      ========================================================================
      ''');
  }
}

/// French localizations
class DocFormFrLocalization extends DocFormBaseLocalization {
  DocFormFrLocalization() : super(Locale('fr', 'FR'));

  @override
  String get btnSubmit => 'Soumettre';
  @override
  String get btnUpload => 'Télécharger';
  @override
  String get btnChange => 'Changement';
  @override
  String get btnRemove => 'Retirer';
  @override
  String get textOtherOption => 'Autre option';
  @override
  String get textDate => 'Date';
  @override
  String get textTime => 'Temps';
  @override
  String get textLatitude => 'Latitude';
  @override
  String get textLongitude => 'Longitude';
  @override
  String get textPhone => 'Téléphone';
  @override
  String get textSearchPhoneCountryCode => 'Nom du pays ou code de composition';
  @override
  String get exceptionNoEmptyField => 'Ce champ est obligatoire.';
  @override
  String get exceptionValueMustBeAPositiveIntegerNumber =>
      'La valeur doit être un nombre entier positif.';
  @override
  String get exceptionValueMustBeAPositiveNumber =>
      'La valeur doit être un nombre positif.';
  @override
  String get exceptionValueMustBeANumber => 'La valeur doit être un numéro.';
  @override
  String get exceptionInvalidUrl => 'Invalid url.';
  @override
  String get exceptionInvalidPhoneNumber => 'Numéro de téléphone non valide.';
  @override
  String exceptionValueOutOfRange(dynamic minValue, dynamic maxValue) =>
      'La valeur doit être comprise entre $minValue et $maxValue.';
  @override
  String exceptionTextLength(dynamic minLength, dynamic maxLength) =>
      'Le texte doit contenir au moins des caractères $minLength et au maximum $maxLength.';
  @override
  String exceptionTextMaxLength(dynamic maxLength) =>
      'Le texte doit contenir au maximum des caractères $maxLength.';
}

class CustomScrollBehavior extends MaterialScrollBehavior {
  static const _webScrollPhysics =
      BouncingScrollPhysics(parent: RangeMaintainingScrollPhysics());

  const CustomScrollBehavior() : super();

  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => PointerDeviceKind.values.toSet();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      kIsWeb ? _webScrollPhysics : super.getScrollPhysics(context);
}
