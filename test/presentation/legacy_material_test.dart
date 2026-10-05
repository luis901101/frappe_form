// The SDK Material types the bridge converts to.
import 'package:flutter/material.dart' as legacy;
import 'package:flutter_test/flutter_test.dart';
import 'package:frappe_form/frappe_form.dart';
import 'package:material_ui/material_ui.dart';

List<Color> _schemeColors(ColorScheme s) => [
  s.primary, s.onPrimary, s.primaryContainer, s.onPrimaryContainer, //
  s.primaryFixed, s.primaryFixedDim, s.onPrimaryFixed, s.onPrimaryFixedVariant,
  s.secondary, s.onSecondary, s.secondaryContainer, s.onSecondaryContainer,
  s.secondaryFixed, s.secondaryFixedDim, s.onSecondaryFixed,
  s.onSecondaryFixedVariant, s.tertiary, s.onTertiary, s.tertiaryContainer,
  s.onTertiaryContainer, s.tertiaryFixed, s.tertiaryFixedDim,
  s.onTertiaryFixed, s.onTertiaryFixedVariant, s.error, s.onError,
  s.errorContainer, s.onErrorContainer, s.surface, s.onSurface, s.surfaceDim,
  s.surfaceBright, s.surfaceContainerLowest, s.surfaceContainerLow,
  s.surfaceContainer, s.surfaceContainerHigh, s.surfaceContainerHighest,
  s.onSurfaceVariant, s.outline, s.outlineVariant, s.shadow, s.scrim,
  s.inverseSurface, s.onInverseSurface, s.inversePrimary, s.surfaceTint,
];

List<Color> _legacySchemeColors(legacy.ColorScheme s) => [
  s.primary, s.onPrimary, s.primaryContainer, s.onPrimaryContainer, //
  s.primaryFixed, s.primaryFixedDim, s.onPrimaryFixed, s.onPrimaryFixedVariant,
  s.secondary, s.onSecondary, s.secondaryContainer, s.onSecondaryContainer,
  s.secondaryFixed, s.secondaryFixedDim, s.onSecondaryFixed,
  s.onSecondaryFixedVariant, s.tertiary, s.onTertiary, s.tertiaryContainer,
  s.onTertiaryContainer, s.tertiaryFixed, s.tertiaryFixedDim,
  s.onTertiaryFixed, s.onTertiaryFixedVariant, s.error, s.onError,
  s.errorContainer, s.onErrorContainer, s.surface, s.onSurface, s.surfaceDim,
  s.surfaceBright, s.surfaceContainerLowest, s.surfaceContainerLow,
  s.surfaceContainer, s.surfaceContainerHigh, s.surfaceContainerHighest,
  s.onSurfaceVariant, s.outline, s.outlineVariant, s.shadow, s.scrim,
  s.inverseSurface, s.onInverseSurface, s.inversePrimary, s.surfaceTint,
];

List<TextStyle?> _styles(TextTheme t) => [
  t.displayLarge, t.displayMedium, t.displaySmall, t.headlineLarge, //
  t.headlineMedium, t.headlineSmall, t.titleLarge, t.titleMedium, t.titleSmall,
  t.bodyLarge, t.bodyMedium, t.bodySmall, t.labelLarge, t.labelMedium,
  t.labelSmall,
];

List<TextStyle?> _legacyStyles(legacy.TextTheme t) => [
  t.displayLarge, t.displayMedium, t.displaySmall, t.headlineLarge, //
  t.headlineMedium, t.headlineSmall, t.titleLarge, t.titleMedium, t.titleSmall,
  t.bodyLarge, t.bodyMedium, t.bodySmall, t.labelLarge, t.labelMedium,
  t.labelSmall,
];

const _radius = BorderRadius.all(Radius.circular(28));

/// A theme that sets every sub-theme the bridge maps, with a fill colour
/// that differs per brightness so a test can tell the two apart.
ThemeData _theme(Brightness brightness) {
  final light = brightness == Brightness.light;
  return ThemeData(
    brightness: brightness,
    colorSchemeSeed: const Color(0xFF6750A4),
    splashFactory: InkRipple.splashFactory,
    inputDecorationTheme: InputDecorationThemeData(
      filled: true,
      fillColor: light ? const Color(0xFFE8F0FE) : const Color(0xFF1E2A3A),
      border: const OutlineInputBorder(borderRadius: _radius),
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Color(0xFF010203),
      selectionColor: Color(0xFF040506),
      selectionHandleColor: Color(0xFF070809),
    ),
    listTileTheme: const ListTileThemeData(
      iconColor: Color(0xFF0A0B0C),
      titleAlignment: ListTileTitleAlignment.top,
    ),
    elevatedButtonTheme: const ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(Color(0xFF00AA00)),
        splashFactory: NoSplash.splashFactory,
      ),
    ),
    outlinedButtonTheme: const OutlinedButtonThemeData(
      style: ButtonStyle(
        side: WidgetStatePropertyAll(BorderSide(color: Color(0xFF0D0E0F))),
      ),
    ),
    iconButtonTheme: const IconButtonThemeData(
      style: ButtonStyle(iconColor: WidgetStatePropertyAll(Color(0xFF101112))),
    ),
    toggleButtonsTheme: const ToggleButtonsThemeData(
      selectedColor: Color(0xFF131415),
      fillColor: Color(0xFF161718),
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderWidth: 2,
    ),
    checkboxTheme: const CheckboxThemeData(
      checkColor: WidgetStatePropertyAll(Color(0xFF191A1B)),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    ),
    tooltipTheme: const TooltipThemeData(
      waitDuration: Duration(milliseconds: 300),
      textStyle: TextStyle(fontSize: 11),
      triggerMode: TooltipTriggerMode.tap,
    ),
    scrollbarTheme: const ScrollbarThemeData(
      thickness: WidgetStatePropertyAll(6),
      radius: Radius.circular(3),
    ),
    popupMenuTheme: const PopupMenuThemeData(
      color: Color(0xFF1C1D1E),
      elevation: 4,
      position: PopupMenuPosition.under,
    ),
  );
}

final _light = _theme(Brightness.light);
final _dark = _theme(Brightness.dark);

/// A material_ui app root. [legacyDelegates] adds the SDK localizations that
/// apps register next to material_ui's own.
Widget _app(Widget body, {ThemeData? theme, bool legacyDelegates = true}) =>
    MaterialApp(
      theme: theme ?? _light,
      localizationsDelegates: [
        ...GlobalMaterialLocalizations.delegates,
        if (legacyDelegates) ...LegacyMaterial.localizationsDelegates,
      ],
      home: Scaffold(body: body),
    );

legacy.InputDecoration _sdkDecoration(WidgetTester tester, {Finder? of}) {
  final finder = find.byType(legacy.InputDecorator);
  return tester
      .widget<legacy.InputDecorator>(
        of == null ? finder : find.descendant(of: of, matching: finder),
      )
      .decoration;
}

/// An input border that is neither an outline nor an underline border.
class _CustomInputBorder extends InputBorder {
  const _CustomInputBorder({super.borderSide, required this.isOutline});

  @override
  final bool isOutline;

  @override
  InputBorder copyWith({BorderSide? borderSide}) => _CustomInputBorder(
    borderSide: borderSide ?? this.borderSide,
    isOutline: isOutline,
  );

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
      Path()..addRect(rect);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) =>
      Path()..addRect(rect);

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    double? gapStart,
    double gapExtent = 0.0,
    double gapPercentage = 0.0,
    TextDirection? textDirection,
  }) {}

  @override
  ShapeBorder scale(double t) => this;
}

void main() {
  group('themeFrom', () {
    for (final MapEntry(key: name, value: theme) in {
      'light': _light,
      'dark': _dark,
    }.entries) {
      test('keeps the $name theme', () {
        final converted = LegacyMaterial.themeFrom(theme);

        expect(converted.brightness, theme.brightness);
        expect(converted.useMaterial3, theme.useMaterial3);
        expect(
          _legacySchemeColors(converted.colorScheme),
          _schemeColors(theme.colorScheme),
        );
        expect(_legacyStyles(converted.textTheme), _styles(theme.textTheme));
        expect(
          converted.scaffoldBackgroundColor,
          theme.scaffoldBackgroundColor,
        );
        expect(converted.canvasColor, theme.canvasColor);
        expect(converted.disabledColor, theme.disabledColor);
        expect(converted.iconTheme, theme.iconTheme);

        final inputs = converted.inputDecorationTheme;
        expect(inputs.filled, isTrue);
        expect(inputs.fillColor, theme.inputDecorationTheme.fillColor);
        expect(
          (inputs.border! as legacy.OutlineInputBorder).borderRadius,
          _radius,
        );

        expect(
          converted.textSelectionTheme.cursorColor,
          const Color(0xFF010203),
        );
        expect(
          converted.textSelectionTheme.selectionColor,
          const Color(0xFF040506),
        );
        expect(
          converted.textSelectionTheme.selectionHandleColor,
          const Color(0xFF070809),
        );
        expect(converted.listTileTheme.iconColor, const Color(0xFF0A0B0C));
        expect(
          converted.listTileTheme.titleAlignment,
          legacy.ListTileTitleAlignment.top,
        );
        expect(
          converted.elevatedButtonTheme.style!.backgroundColor!.resolve({}),
          const Color(0xFF00AA00),
        );
      });
    }

    test('maps the sub-themes the SDK widgets read', () {
      final converted = LegacyMaterial.themeFrom(_light);

      expect(
        converted.outlinedButtonTheme.style!.side!.resolve({}),
        const BorderSide(color: Color(0xFF0D0E0F)),
      );
      expect(
        converted.iconButtonTheme.style!.iconColor!.resolve({}),
        const Color(0xFF101112),
      );

      final toggles = converted.toggleButtonsTheme;
      expect(toggles.selectedColor, const Color(0xFF131415));
      expect(toggles.fillColor, const Color(0xFF161718));
      expect(toggles.borderRadius, const BorderRadius.all(Radius.circular(8)));
      expect(toggles.borderWidth, 2);

      final checkbox = converted.checkboxTheme;
      expect(checkbox.checkColor!.resolve({}), const Color(0xFF191A1B));
      expect(
        checkbox.materialTapTargetSize,
        legacy.MaterialTapTargetSize.shrinkWrap,
      );
      expect(checkbox.visualDensity, legacy.VisualDensity.compact);

      final tooltip = converted.tooltipTheme;
      expect(tooltip.waitDuration, const Duration(milliseconds: 300));
      expect(tooltip.textStyle, const TextStyle(fontSize: 11));
      expect(tooltip.triggerMode, TooltipTriggerMode.tap);

      final scrollbar = converted.scrollbarTheme;
      expect(scrollbar.thickness!.resolve({}), 6);
      expect(scrollbar.radius, const Radius.circular(3));

      final popupMenu = converted.popupMenuTheme;
      expect(popupMenu.color, const Color(0xFF1C1D1E));
      expect(popupMenu.elevation, 4);
      expect(popupMenu.position, legacy.PopupMenuPosition.under);
    });

    test('maps the known splash factories and drops others', () {
      expect(
        LegacyMaterial.themeFrom(_light).splashFactory,
        same(legacy.InkRipple.splashFactory),
      );
      expect(
        LegacyMaterial.themeFrom(_light)
            .elevatedButtonTheme
            .style!
            .splashFactory,
        same(legacy.NoSplash.splashFactory),
      );
      for (final (factory, expected) in [
        (InkSplash.splashFactory, legacy.InkSplash.splashFactory),
        (InkSparkle.splashFactory, legacy.InkSparkle.splashFactory),
        (
          InkSparkle.constantTurbulenceSeedSplashFactory,
          legacy.InkSparkle.constantTurbulenceSeedSplashFactory,
        ),
      ]) {
        expect(
          LegacyMaterial.buttonStyle(ButtonStyle(splashFactory: factory))!
              .splashFactory,
          same(expected),
        );
      }
      expect(
        LegacyMaterial.buttonStyle(const ButtonStyle())!.splashFactory,
        isNull,
      );
    });

    test('converts each theme instance once', () {
      expect(
        LegacyMaterial.themeFrom(_light),
        same(LegacyMaterial.themeFrom(_light)),
      );
    });
  });

  group('inputBorder', () {
    const side = BorderSide(color: Color(0xFF123456), width: 2);

    test('converts outline, underline and no borders', () {
      final converted = LegacyMaterial.inputDecoration(
        const InputDecoration(
          border: OutlineInputBorder(
            borderRadius: _radius,
            borderSide: side,
            gapPadding: 6,
          ),
          enabledBorder: UnderlineInputBorder(
            borderRadius: _radius,
            borderSide: side,
          ),
          focusedBorder: InputBorder.none,
        ),
      );

      final outline = converted.border! as legacy.OutlineInputBorder;
      expect(outline.borderRadius, _radius);
      expect(outline.borderSide, side);
      expect(outline.gapPadding, 6);
      final underline = converted.enabledBorder! as legacy.UnderlineInputBorder;
      expect(underline.borderRadius, _radius);
      expect(underline.borderSide, side);
      expect(converted.focusedBorder, same(legacy.InputBorder.none));
      expect(converted.errorBorder, isNull);
    });

    test('resolves a state-dependent border per state', () {
      final converted = LegacyMaterial.inputBorder(
        WidgetStateInputBorder.resolveWith(
          (states) => states.contains(WidgetState.focused)
              ? const OutlineInputBorder(borderSide: side)
              : const UnderlineInputBorder(),
        ),
      );

      expect(converted, isA<legacy.WidgetStateInputBorder>());
      final stateBorder = converted! as legacy.WidgetStateInputBorder;
      expect(
        stateBorder.resolve({WidgetState.focused}),
        isA<legacy.OutlineInputBorder>().having(
          (border) => border.borderSide,
          'borderSide',
          side,
        ),
      );
      expect(stateBorder.resolve({}), isA<legacy.UnderlineInputBorder>());
    });

    test('falls back on the outline flag for other borders', () {
      expect(
        LegacyMaterial.inputBorder(
          const _CustomInputBorder(borderSide: side, isOutline: true),
        ),
        isA<legacy.OutlineInputBorder>().having(
          (border) => border.borderSide,
          'borderSide',
          side,
        ),
      );
      expect(
        LegacyMaterial.inputBorder(
          const _CustomInputBorder(borderSide: side, isOutline: false),
        ),
        isA<legacy.UnderlineInputBorder>().having(
          (border) => border.borderSide,
          'borderSide',
          side,
        ),
      );
    });
  });

  group('inputDecoration', () {
    test('keeps the hint, label, icons, error and fill', () {
      const prefix = Icon(Icons.search);
      const suffix = Icon(Icons.clear);
      final converted = LegacyMaterial.inputDecoration(
        const InputDecoration(
          hintText: 'Hint',
          labelText: 'Label',
          prefixIcon: prefix,
          suffixIcon: suffix,
          errorText: 'Error',
          errorMaxLines: 4,
          filled: true,
          fillColor: Color(0xFFABCDEF),
          isDense: true,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          floatingLabelAlignment: FloatingLabelAlignment.center,
        ),
      );

      expect(converted.hintText, 'Hint');
      expect(converted.labelText, 'Label');
      expect(converted.prefixIcon, same(prefix));
      expect(converted.suffixIcon, same(suffix));
      expect(converted.errorText, 'Error');
      expect(converted.errorMaxLines, 4);
      expect(converted.filled, isTrue);
      expect(converted.fillColor, const Color(0xFFABCDEF));
      expect(converted.isDense, isTrue);
      expect(
        converted.floatingLabelBehavior,
        legacy.FloatingLabelBehavior.always,
      );
      expect(
        converted.floatingLabelAlignment,
        legacy.FloatingLabelAlignment.center,
      );
    });
  });

  group('LegacyMaterialScope under a material_ui app', () {
    testWidgets('gives an SDK field the app theme', (tester) async {
      await tester.pumpWidget(
        _app(const LegacyMaterialScope(child: legacy.TextField())),
      );

      expect(tester.takeException(), isNull);
      final decoration = _sdkDecoration(tester);
      expect(decoration.filled, isTrue);
      expect(decoration.fillColor, _light.inputDecorationTheme.fillColor);
      expect(
        (decoration.border! as legacy.OutlineInputBorder).borderRadius,
        _radius,
      );

      await tester.enterText(find.byType(legacy.TextField), 'Some text');
      await tester.pump();
      expect(tester.takeException(), isNull);
    });

    testWidgets('follows a local Theme override', (tester) async {
      // Otherwise this test could not tell the two themes apart.
      expect(
        _dark.inputDecorationTheme.fillColor,
        isNot(_light.inputDecorationTheme.fillColor),
      );

      await tester.pumpWidget(
        _app(
          Theme(
            data: _dark,
            child: const LegacyMaterialScope(child: legacy.TextField()),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(
        _sdkDecoration(tester).fillColor,
        _dark.inputDecorationTheme.fillColor,
      );
    });

    testWidgets('follows a local InputDecorationTheme', (tester) async {
      const fill = Color(0xFFFFE0B2);
      await tester.pumpWidget(
        _app(
          const InputDecorationTheme(
            data: InputDecorationThemeData(
              filled: true,
              fillColor: fill,
              border: UnderlineInputBorder(),
            ),
            child: LegacyMaterialScope(child: legacy.TextField()),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      final decoration = _sdkDecoration(tester);
      expect(decoration.fillColor, fill);
      expect(decoration.border, isA<legacy.UnderlineInputBorder>());
    });

    testWidgets('carries the converted theme into an SDK dialog', (
      tester,
    ) async {
      late BuildContext scopeContext;
      await tester.pumpWidget(
        _app(
          LegacyMaterialScope(
            child: Builder(
              builder: (context) {
                scopeContext = context;
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      legacy.showDialog<void>(
        context: scopeContext,
        builder: (_) => const legacy.AlertDialog(content: legacy.TextField()),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      final dialog = find.byType(legacy.AlertDialog);
      expect(dialog, findsOneWidget);
      final dialogTheme = legacy.Theme.of(tester.element(dialog));
      expect(dialogTheme.colorScheme.primary, _light.colorScheme.primary);
      // The SDK default theme would have filled nothing.
      expect(
        _sdkDecoration(tester, of: dialog).fillColor,
        _light.inputDecorationTheme.fillColor,
      );
      final surface = tester.widget<legacy.Material>(
        find
            .descendant(of: dialog, matching: find.byType(legacy.Material))
            .first,
      );
      expect(surface.color, _light.colorScheme.surfaceContainerHigh);
    });

    testWidgets('fails fast without the SDK localizations', (tester) async {
      await tester.pumpWidget(
        _app(
          const LegacyMaterialScope(child: SizedBox()),
          legacyDelegates: false,
        ),
      );

      final error = tester.takeException();
      expect(error, isA<FlutterError>());
      expect(
        error.toString(),
        contains('LegacyMaterial.localizationsDelegates'),
      );
    });

    testWidgets('needs no SDK localizations without material', (tester) async {
      await tester.pumpWidget(
        _app(
          const LegacyMaterialScope(material: false, child: SizedBox()),
          legacyDelegates: false,
        ),
      );

      expect(tester.takeException(), isNull);
    });
  });
}
