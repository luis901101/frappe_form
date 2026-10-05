// The SDK Material types the bridged dependencies build with.
import 'package:flutter/material.dart' as legacy;
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frappe_form/frappe_form.dart';
import 'package:material_ui/material_ui.dart';

final _theme = ThemeData(colorSchemeSeed: const Color(0xFF00696D));

Widget _app(Widget body, {bool legacyDelegates = true}) => MaterialApp(
  theme: _theme,
  localizationsDelegates: [
    ...GlobalMaterialLocalizations.delegates,
    if (legacyDelegates) ...LegacyMaterial.localizationsDelegates,
  ],
  home: Scaffold(body: SingleChildScrollView(child: body)),
);

void main() {
  testWidgets('DocFieldPhoneView stores the Frappe phone format', (
    tester,
  ) async {
    final controller = CustomTextEditingController(focusNode: FocusNode());
    await tester.pumpWidget(
      _app(
        DocFieldPhoneView(
          field: DocField(type: FieldType.phone, label: 'Phone'),
          controller: controller,
        ),
      ),
    );

    await tester.enterText(find.byType(EditableText), '2015550123');
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(controller.text, '+1-2015550123');
  });

  testWidgets('DocFieldRatingView stores the tapped rating', (tester) async {
    final controller = CustomValueController<double>(focusNode: FocusNode());
    await tester.pumpWidget(
      _app(
        DocFieldRatingView(
          field: DocField(type: FieldType.rating, label: 'Rating'),
          controller: controller,
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    // The rating bar reads the app theme, not the SDK default one.
    expect(
      legacy.Theme.of(tester.element(find.byType(RatingBar)))
          .colorScheme
          .primary,
      _theme.colorScheme.primary,
    );

    // The right half of the third star is a full three-star rating.
    final third = find.byIcon(Icons.star_outline).at(2);
    final size = tester.getSize(third);
    await tester.tapAt(tester.getCenter(third) + Offset(size.width / 4, 0));
    await tester.pump();

    expect(controller.value, closeTo(3 / 5, 1e-9));
  });

  group('CustomHtml', () {
    const html = '<details><summary>More</summary><p>Hidden body</p></details>';

    // Semantics off: on Flutter 3.47 the expanded tile trips the framework's
    // `!conflict` semantics assertion for a widget inside a RichText.
    // flutter_html's own SDK built-in trips the same assertion on its first
    // render, so it predates this extension.
    testWidgets(
      'renders <details> with the material_ui ExpansionTile',
      semanticsEnabled: false,
      (tester) async {
        // No SDK localizations or scope: the built-in SDK tile is not used.
        await tester.pumpWidget(
          _app(CustomHtml(data: html), legacyDelegates: false),
        );

        expect(tester.takeException(), isNull);
        expect(find.byType(ExpansionTile), findsOneWidget);
        expect(find.byType(legacy.ExpansionTile), findsNothing);
        expect(find.text('More', findRichText: true), findsOneWidget);
        expect(find.text('Hidden body', findRichText: true), findsNothing);

        await tester.tap(find.byType(ExpansionTile));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.text('Hidden body', findRichText: true), findsOneWidget);
      },
    );

    testWidgets('lets a given extension handle <details>', (tester) async {
      await tester.pumpWidget(
        _app(
          CustomHtml(
            data: html,
            extensions: [
              TagExtension(
                tagsToExtend: {'details'},
                child: const Text('Custom details'),
              ),
            ],
          ),
          legacyDelegates: false,
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('Custom details'), findsOneWidget);
      expect(find.byType(ExpansionTile), findsNothing);
    });
  });
}
