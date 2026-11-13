// The SDK Material types IntlPhoneField builds with.
// ignore: deprecated_member_use, migrate_design_widgets
import 'package:flutter/material.dart' as legacy;
import 'package:flutter_test/flutter_test.dart';
import 'package:frappe_form/frappe_form.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:material_ui/material_ui.dart';

const _fill = Color(0xFFE8F0FE);
const _radius = BorderRadius.all(Radius.circular(28));

final _theme = ThemeData(
  inputDecorationTheme: const InputDecorationThemeData(
    filled: true,
    fillColor: _fill,
    border: OutlineInputBorder(borderRadius: _radius),
  ),
);

Widget _app(Widget field) => MaterialApp(
  theme: _theme,
  localizationsDelegates: const [
    ...GlobalMaterialLocalizations.delegates,
    ...LegacyMaterial.localizationsDelegates,
  ],
  home: Scaffold(body: field),
);

final _dialog = find.byType(legacy.Dialog);

legacy.InputDecoration _decoration(WidgetTester tester, {Finder? of}) {
  final finder = find.byType(legacy.InputDecorator);
  return tester
      .widget<legacy.InputDecorator>(
        of == null ? finder.first : find.descendant(of: of, matching: finder),
      )
      .decoration;
}

/// Opens the country picker from the flags button, which shows the dial
/// code of the default country (US).
Future<void> _openPicker(WidgetTester tester) async {
  await tester.tap(find.text('+1'));
  await tester.pumpAndSettle();
  expect(_dialog, findsOneWidget);
}

void main() {
  final localization = DocFormLocalization.instance.localization;

  testWidgets('themes the SDK field from the material_ui theme', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        const CustomIntlPhoneField(
          decoration: InputDecoration(hintText: 'Phone'),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    final decoration = _decoration(tester);
    expect(decoration.hintText, 'Phone');
    expect(decoration.filled, isTrue);
    expect(decoration.fillColor, _fill);
    expect(
      (decoration.border! as legacy.OutlineInputBorder).borderRadius,
      _radius,
    );
  });

  testWidgets('reports typed input through onChanged', (tester) async {
    PhoneNumber? changed;
    await tester.pumpWidget(
      _app(CustomIntlPhoneField(onChanged: (phone) => changed = phone)),
    );

    await tester.enterText(find.byType(EditableText), '2015550123');
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(changed?.number, '2015550123');
    expect(changed?.countryISOCode, 'US');
    expect(changed?.toFrappePhone, '+1-2015550123');
  });

  testWidgets('opens a themed country picker and selects a country', (
    tester,
  ) async {
    String? selectedCode;
    await tester.pumpWidget(
      _app(
        CustomIntlPhoneField(
          onCountryChanged: (country) => selectedCode = country.code,
        ),
      ),
    );

    await _openPicker(tester);
    expect(tester.takeException(), isNull);
    final search = _decoration(tester, of: _dialog);
    expect(search.hintText, localization.textSearchPhoneCountryCode);
    expect(search.fillColor, _fill);

    await tester.enterText(
      find.descendant(of: _dialog, matching: find.byType(EditableText)),
      'Spain',
    );
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(legacy.ListTile, 'Spain'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(_dialog, findsNothing);
    expect(selectedCode, 'ES');
    expect(find.text('+34'), findsOneWidget);
  });

  testWidgets('searchFieldInputDecoration overrides the picker style', (
    tester,
  ) async {
    const background = Color(0xFF102030);
    await tester.pumpWidget(
      _app(
        CustomIntlPhoneField(
          pickerDialogStyle: PickerDialogStyle(
            backgroundColor: background,
            searchFieldInputDecoration: const legacy.InputDecoration(
              hintText: 'From the style',
            ),
          ),
          searchFieldInputDecoration: const InputDecoration(
            hintText: 'Find a country',
          ),
        ),
      ),
    );

    await _openPicker(tester);
    expect(_decoration(tester, of: _dialog).hintText, 'Find a country');
    // The rest of the given style is kept.
    expect(tester.widget<legacy.Dialog>(_dialog).backgroundColor, background);
  });

  testWidgets('keeps the picker style search decoration as a fallback', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        CustomIntlPhoneField(
          pickerDialogStyle: PickerDialogStyle(
            searchFieldInputDecoration: const legacy.InputDecoration(
              hintText: 'From the style',
            ),
          ),
        ),
      ),
    );

    await _openPicker(tester);
    expect(_decoration(tester, of: _dialog).hintText, 'From the style');
  });

  testWidgets('renders the error text', (tester) async {
    await tester.pumpWidget(
      _app(
        const CustomIntlPhoneField(
          decoration: InputDecoration(errorText: 'Bad number'),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('Bad number'), findsOneWidget);
  });

  testWidgets('remounts the SDK field when its key changes', (tester) async {
    Future<State> pumpWithKey(int key) async {
      await tester.pumpWidget(_app(CustomIntlPhoneField(key: ValueKey(key))));
      return tester.state(find.byType(IntlPhoneField));
    }

    final first = await pumpWithKey(1);
    // Otherwise a remount could not be told from a fresh state per pump.
    expect(await pumpWithKey(1), same(first));
    expect(await pumpWithKey(2), isNot(same(first)));
  });
}
