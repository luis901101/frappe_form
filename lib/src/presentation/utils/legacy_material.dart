// The one file in lib/ that may import SDK Material. Everything else imports
// package:material_ui/material_ui.dart.
import 'package:flutter/material.dart' as legacy;
import 'package:flutter_localizations/flutter_localizations.dart' as legacy;
import 'package:material_ui/material_ui.dart';

/// Bridges the app's `package:material_ui` theme to widgets that are still
/// built on SDK Material (`package:flutter/material.dart`): in this package,
/// intl_phone_field, html_editor_enhanced and flutter_rating_bar.
///
/// The two libraries declare separate `ThemeData`, `InputDecoration`,
/// `Material`... types, so an SDK widget under a `material_ui` theme finds
/// neither an SDK `Theme` (it falls back to the default light theme) nor an
/// SDK `Material` (it fails its `debugCheckHasMaterial`). Widgets-layer types
/// such as `Color`, `TextStyle`, `IconThemeData`, `BorderSide` and
/// `WidgetStateProperty` are shared and copy across as they are.
///
/// Fields that only exist in `material_ui` have no SDK counterpart and are
/// dropped: `InputDecoration.labelTextDirection`, the `ButtonStyle` size and
/// shape variants, `IconButtonThemeData.variant` and
/// `TooltipThemeData.ignorePointer`.
abstract final class LegacyMaterial {
  static final _themes = Expando<legacy.ThemeData>('LegacyMaterial.themeFrom');
  static final _inputDecorationThemes =
      Expando<legacy.InputDecorationThemeData>(
        'LegacyMaterial.inputDecorationTheme',
      );

  /// The SDK localizations that SDK widgets look up: register them in
  /// `MaterialApp.localizationsDelegates` next to `material_ui`'s own.
  ///
  /// ```dart
  /// MaterialApp(
  ///   localizationsDelegates: const [
  ///     ...GlobalMaterialLocalizations.delegates,
  ///     ...LegacyMaterial.localizationsDelegates,
  ///   ],
  /// )
  /// ```
  ///
  /// A [LegacyMaterialScope] cannot provide them itself: dialogs opened by SDK
  /// widgets are built under the app's `Navigator`, so they resolve the
  /// app-root `Localizations`.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      legacy.GlobalMaterialLocalizations.delegates;

  /// The SDK counterpart of [theme], cached per instance. `Theme.of` hands
  /// out cached localized instances, so lookups normally hit the cache.
  ///
  /// Maps the colour scheme, text themes, resolved scalar colours and the
  /// sub-themes read by the SDK widgets this package uses (text fields,
  /// dialogs, list tiles, buttons, toggle buttons, checkboxes, tooltips,
  /// scrollbars and popup menus).
  static legacy.ThemeData themeFrom(ThemeData theme) =>
      _themes[theme] ??= _themeFrom(theme);

  static legacy.ThemeData _themeFrom(ThemeData theme) => legacy.ThemeData(
    useMaterial3: theme.useMaterial3,
    brightness: theme.brightness,
    platform: theme.platform,
    visualDensity: _visualDensity(theme.visualDensity),
    materialTapTargetSize: _byName(
      legacy.MaterialTapTargetSize.values,
      theme.materialTapTargetSize,
    ),
    applyElevationOverlayColor: theme.applyElevationOverlayColor,
    splashFactory: _splashFactory(theme.splashFactory),
    colorScheme: _colorScheme(theme.colorScheme),
    textTheme: _textTheme(theme.textTheme),
    primaryTextTheme: _textTheme(theme.primaryTextTheme),
    // Already resolved on the source theme; copying them avoids relying on
    // both ThemeData constructors deriving the same defaults.
    canvasColor: theme.canvasColor,
    cardColor: theme.cardColor,
    disabledColor: theme.disabledColor,
    dividerColor: theme.dividerColor,
    focusColor: theme.focusColor,
    highlightColor: theme.highlightColor,
    hintColor: theme.hintColor,
    hoverColor: theme.hoverColor,
    primaryColor: theme.primaryColor,
    primaryColorDark: theme.primaryColorDark,
    primaryColorLight: theme.primaryColorLight,
    scaffoldBackgroundColor: theme.scaffoldBackgroundColor,
    secondaryHeaderColor: theme.secondaryHeaderColor,
    shadowColor: theme.shadowColor,
    splashColor: theme.splashColor,
    unselectedWidgetColor: theme.unselectedWidgetColor,
    // SDK Theme re-provides IconTheme and DefaultSelectionStyle, which are
    // shared widgets-layer types, to everything below it, material_ui widgets
    // included.
    iconTheme: theme.iconTheme,
    primaryIconTheme: theme.primaryIconTheme,
    textSelectionTheme: legacy.TextSelectionThemeData(
      cursorColor: theme.textSelectionTheme.cursorColor,
      selectionColor: theme.textSelectionTheme.selectionColor,
      selectionHandleColor: theme.textSelectionTheme.selectionHandleColor,
    ),
    dialogTheme: _dialogTheme(theme.dialogTheme),
    dividerTheme: _dividerTheme(theme.dividerTheme),
    listTileTheme: _listTileTheme(theme.listTileTheme),
    elevatedButtonTheme: legacy.ElevatedButtonThemeData(
      style: buttonStyle(theme.elevatedButtonTheme.style),
    ),
    outlinedButtonTheme: legacy.OutlinedButtonThemeData(
      style: buttonStyle(theme.outlinedButtonTheme.style),
    ),
    textButtonTheme: legacy.TextButtonThemeData(
      style: buttonStyle(theme.textButtonTheme.style),
    ),
    iconButtonTheme: legacy.IconButtonThemeData(
      style: buttonStyle(theme.iconButtonTheme.style),
    ),
    toggleButtonsTheme: _toggleButtonsTheme(theme.toggleButtonsTheme),
    checkboxTheme: _checkboxTheme(theme.checkboxTheme),
    tooltipTheme: _tooltipTheme(theme.tooltipTheme),
    scrollbarTheme: _scrollbarTheme(theme.scrollbarTheme),
    popupMenuTheme: _popupMenuTheme(theme.popupMenuTheme),
    inputDecorationTheme: inputDecorationTheme(theme.inputDecorationTheme),
  );

  static legacy.ColorScheme _colorScheme(ColorScheme scheme) =>
      legacy.ColorScheme(
        brightness: scheme.brightness,
        primary: scheme.primary,
        onPrimary: scheme.onPrimary,
        primaryContainer: scheme.primaryContainer,
        onPrimaryContainer: scheme.onPrimaryContainer,
        primaryFixed: scheme.primaryFixed,
        primaryFixedDim: scheme.primaryFixedDim,
        onPrimaryFixed: scheme.onPrimaryFixed,
        onPrimaryFixedVariant: scheme.onPrimaryFixedVariant,
        secondary: scheme.secondary,
        onSecondary: scheme.onSecondary,
        secondaryContainer: scheme.secondaryContainer,
        onSecondaryContainer: scheme.onSecondaryContainer,
        secondaryFixed: scheme.secondaryFixed,
        secondaryFixedDim: scheme.secondaryFixedDim,
        onSecondaryFixed: scheme.onSecondaryFixed,
        onSecondaryFixedVariant: scheme.onSecondaryFixedVariant,
        tertiary: scheme.tertiary,
        onTertiary: scheme.onTertiary,
        tertiaryContainer: scheme.tertiaryContainer,
        onTertiaryContainer: scheme.onTertiaryContainer,
        tertiaryFixed: scheme.tertiaryFixed,
        tertiaryFixedDim: scheme.tertiaryFixedDim,
        onTertiaryFixed: scheme.onTertiaryFixed,
        onTertiaryFixedVariant: scheme.onTertiaryFixedVariant,
        error: scheme.error,
        onError: scheme.onError,
        errorContainer: scheme.errorContainer,
        onErrorContainer: scheme.onErrorContainer,
        surface: scheme.surface,
        onSurface: scheme.onSurface,
        surfaceDim: scheme.surfaceDim,
        surfaceBright: scheme.surfaceBright,
        surfaceContainerLowest: scheme.surfaceContainerLowest,
        surfaceContainerLow: scheme.surfaceContainerLow,
        surfaceContainer: scheme.surfaceContainer,
        surfaceContainerHigh: scheme.surfaceContainerHigh,
        surfaceContainerHighest: scheme.surfaceContainerHighest,
        onSurfaceVariant: scheme.onSurfaceVariant,
        outline: scheme.outline,
        outlineVariant: scheme.outlineVariant,
        shadow: scheme.shadow,
        scrim: scheme.scrim,
        inverseSurface: scheme.inverseSurface,
        onInverseSurface: scheme.onInverseSurface,
        inversePrimary: scheme.inversePrimary,
        surfaceTint: scheme.surfaceTint,
      );

  static legacy.TextTheme _textTheme(TextTheme textTheme) => legacy.TextTheme(
    displayLarge: textTheme.displayLarge,
    displayMedium: textTheme.displayMedium,
    displaySmall: textTheme.displaySmall,
    headlineLarge: textTheme.headlineLarge,
    headlineMedium: textTheme.headlineMedium,
    headlineSmall: textTheme.headlineSmall,
    titleLarge: textTheme.titleLarge,
    titleMedium: textTheme.titleMedium,
    titleSmall: textTheme.titleSmall,
    bodyLarge: textTheme.bodyLarge,
    bodyMedium: textTheme.bodyMedium,
    bodySmall: textTheme.bodySmall,
    labelLarge: textTheme.labelLarge,
    labelMedium: textTheme.labelMedium,
    labelSmall: textTheme.labelSmall,
  );

  static legacy.DialogThemeData _dialogTheme(DialogThemeData theme) =>
      legacy.DialogThemeData(
        backgroundColor: theme.backgroundColor,
        elevation: theme.elevation,
        shadowColor: theme.shadowColor,
        surfaceTintColor: theme.surfaceTintColor,
        shape: theme.shape,
        alignment: theme.alignment,
        iconColor: theme.iconColor,
        titleTextStyle: theme.titleTextStyle,
        contentTextStyle: theme.contentTextStyle,
        actionsPadding: theme.actionsPadding,
        barrierColor: theme.barrierColor,
        insetPadding: theme.insetPadding,
        clipBehavior: theme.clipBehavior,
        constraints: theme.constraints,
      );

  static legacy.DividerThemeData _dividerTheme(DividerThemeData theme) =>
      legacy.DividerThemeData(
        color: theme.color,
        space: theme.space,
        thickness: theme.thickness,
        indent: theme.indent,
        endIndent: theme.endIndent,
        radius: theme.radius,
      );

  static legacy.ListTileThemeData _listTileTheme(ListTileThemeData theme) =>
      legacy.ListTileThemeData(
        dense: theme.dense,
        shape: theme.shape,
        style: _byName(legacy.ListTileStyle.values, theme.style),
        selectedColor: theme.selectedColor,
        iconColor: theme.iconColor,
        textColor: theme.textColor,
        titleTextStyle: theme.titleTextStyle,
        subtitleTextStyle: theme.subtitleTextStyle,
        leadingAndTrailingTextStyle: theme.leadingAndTrailingTextStyle,
        contentPadding: theme.contentPadding,
        tileColor: theme.tileColor,
        selectedTileColor: theme.selectedTileColor,
        horizontalTitleGap: theme.horizontalTitleGap,
        minVerticalPadding: theme.minVerticalPadding,
        minLeadingWidth: theme.minLeadingWidth,
        enableFeedback: theme.enableFeedback,
        mouseCursor: theme.mouseCursor,
        visualDensity: _visualDensityOrNull(theme.visualDensity),
        minTileHeight: theme.minTileHeight,
        titleAlignment: _byName(
          legacy.ListTileTitleAlignment.values,
          theme.titleAlignment,
        ),
        controlAffinity: _byName(
          legacy.ListTileControlAffinity.values,
          theme.controlAffinity,
        ),
        isThreeLine: theme.isThreeLine,
      );

  static legacy.ToggleButtonsThemeData _toggleButtonsTheme(
    ToggleButtonsThemeData theme,
  ) => legacy.ToggleButtonsThemeData(
    textStyle: theme.textStyle,
    constraints: theme.constraints,
    color: theme.color,
    selectedColor: theme.selectedColor,
    disabledColor: theme.disabledColor,
    fillColor: theme.fillColor,
    focusColor: theme.focusColor,
    highlightColor: theme.highlightColor,
    hoverColor: theme.hoverColor,
    splashColor: theme.splashColor,
    borderColor: theme.borderColor,
    selectedBorderColor: theme.selectedBorderColor,
    disabledBorderColor: theme.disabledBorderColor,
    borderRadius: theme.borderRadius,
    borderWidth: theme.borderWidth,
  );

  static legacy.CheckboxThemeData _checkboxTheme(CheckboxThemeData theme) =>
      legacy.CheckboxThemeData(
        mouseCursor: theme.mouseCursor,
        fillColor: theme.fillColor,
        checkColor: theme.checkColor,
        overlayColor: theme.overlayColor,
        splashRadius: theme.splashRadius,
        materialTapTargetSize: _byName(
          legacy.MaterialTapTargetSize.values,
          theme.materialTapTargetSize,
        ),
        visualDensity: _visualDensityOrNull(theme.visualDensity),
        shape: theme.shape,
        side: theme.side,
      );

  /// The deprecated `height` is not copied; `constraints` replaces it.
  static legacy.TooltipThemeData _tooltipTheme(TooltipThemeData theme) =>
      legacy.TooltipThemeData(
        constraints: theme.constraints,
        padding: theme.padding,
        margin: theme.margin,
        verticalOffset: theme.verticalOffset,
        preferBelow: theme.preferBelow,
        excludeFromSemantics: theme.excludeFromSemantics,
        decoration: theme.decoration,
        textStyle: theme.textStyle,
        textAlign: theme.textAlign,
        waitDuration: theme.waitDuration,
        showDuration: theme.showDuration,
        exitDuration: theme.exitDuration,
        triggerMode: theme.triggerMode,
        enableFeedback: theme.enableFeedback,
      );

  static legacy.ScrollbarThemeData _scrollbarTheme(ScrollbarThemeData theme) =>
      legacy.ScrollbarThemeData(
        thumbVisibility: theme.thumbVisibility,
        thickness: theme.thickness,
        trackVisibility: theme.trackVisibility,
        radius: theme.radius,
        thumbColor: theme.thumbColor,
        trackColor: theme.trackColor,
        trackBorderColor: theme.trackBorderColor,
        crossAxisMargin: theme.crossAxisMargin,
        mainAxisMargin: theme.mainAxisMargin,
        minThumbLength: theme.minThumbLength,
        interactive: theme.interactive,
      );

  static legacy.PopupMenuThemeData _popupMenuTheme(PopupMenuThemeData theme) =>
      legacy.PopupMenuThemeData(
        color: theme.color,
        shape: theme.shape,
        menuPadding: theme.menuPadding,
        elevation: theme.elevation,
        shadowColor: theme.shadowColor,
        surfaceTintColor: theme.surfaceTintColor,
        textStyle: theme.textStyle,
        labelTextStyle: theme.labelTextStyle,
        enableFeedback: theme.enableFeedback,
        mouseCursor: theme.mouseCursor,
        position: _byName(legacy.PopupMenuPosition.values, theme.position),
        iconColor: theme.iconColor,
        iconSize: theme.iconSize,
      );

  /// Converts a button style. The `material_ui`-only size and shape variants
  /// are dropped.
  static legacy.ButtonStyle? buttonStyle(ButtonStyle? style) {
    if (style == null) return null;
    return legacy.ButtonStyle(
      textStyle: style.textStyle,
      backgroundColor: style.backgroundColor,
      foregroundColor: style.foregroundColor,
      overlayColor: style.overlayColor,
      shadowColor: style.shadowColor,
      surfaceTintColor: style.surfaceTintColor,
      elevation: style.elevation,
      padding: style.padding,
      minimumSize: style.minimumSize,
      fixedSize: style.fixedSize,
      maximumSize: style.maximumSize,
      iconColor: style.iconColor,
      iconSize: style.iconSize,
      iconAlignment: _byName(legacy.IconAlignment.values, style.iconAlignment),
      side: style.side,
      shape: style.shape,
      mouseCursor: style.mouseCursor,
      visualDensity: _visualDensityOrNull(style.visualDensity),
      tapTargetSize: _byName(
        legacy.MaterialTapTargetSize.values,
        style.tapTargetSize,
      ),
      animationDuration: style.animationDuration,
      enableFeedback: style.enableFeedback,
      alignment: style.alignment,
      splashFactory: _splashFactory(style.splashFactory),
      backgroundBuilder: style.backgroundBuilder,
      foregroundBuilder: style.foregroundBuilder,
    );
  }

  static legacy.InputDecorationThemeData inputDecorationTheme(
    InputDecorationThemeData theme,
  ) => legacy.InputDecorationThemeData(
    labelStyle: theme.labelStyle,
    floatingLabelStyle: theme.floatingLabelStyle,
    helperStyle: theme.helperStyle,
    helperMaxLines: theme.helperMaxLines,
    hintStyle: theme.hintStyle,
    hintFadeDuration: theme.hintFadeDuration,
    hintMaxLines: theme.hintMaxLines,
    errorStyle: theme.errorStyle,
    errorMaxLines: theme.errorMaxLines,
    floatingLabelBehavior: legacy.FloatingLabelBehavior.values.byName(
      theme.floatingLabelBehavior.name,
    ),
    floatingLabelAlignment: _floatingLabelAlignment(
      theme.floatingLabelAlignment,
    )!,
    isDense: theme.isDense,
    contentPadding: theme.contentPadding,
    isCollapsed: theme.isCollapsed,
    iconColor: theme.iconColor,
    prefixStyle: theme.prefixStyle,
    prefixIconColor: theme.prefixIconColor,
    prefixIconConstraints: theme.prefixIconConstraints,
    suffixStyle: theme.suffixStyle,
    suffixIconColor: theme.suffixIconColor,
    suffixIconConstraints: theme.suffixIconConstraints,
    counterStyle: theme.counterStyle,
    filled: theme.filled,
    fillColor: theme.fillColor,
    activeIndicatorBorder: theme.activeIndicatorBorder,
    outlineBorder: theme.outlineBorder,
    focusColor: theme.focusColor,
    hoverColor: theme.hoverColor,
    errorBorder: inputBorder(theme.errorBorder),
    focusedBorder: inputBorder(theme.focusedBorder),
    focusedErrorBorder: inputBorder(theme.focusedErrorBorder),
    disabledBorder: inputBorder(theme.disabledBorder),
    enabledBorder: inputBorder(theme.enabledBorder),
    border: inputBorder(theme.border),
    alignLabelWithHint: theme.alignLabelWithHint,
    constraints: theme.constraints,
    visualDensity: _visualDensityOrNull(theme.visualDensity),
  );

  /// The SDK counterpart of a local `InputDecorationTheme` widget, cached per
  /// widget: its `data` is rebuilt on every read when the widget was created
  /// from separate fields.
  static legacy.InputDecorationThemeData _localInputDecorationTheme(
    InputDecorationTheme widget,
  ) => _inputDecorationThemes[widget] ??= inputDecorationTheme(widget.data);

  /// Converts a decoration for an SDK text field, such as `IntlPhoneField`.
  /// `labelTextDirection` has no SDK counterpart and is dropped.
  static legacy.InputDecoration inputDecoration(InputDecoration decoration) =>
      legacy.InputDecoration(
        icon: decoration.icon,
        iconColor: decoration.iconColor,
        label: decoration.label,
        labelText: decoration.labelText,
        labelStyle: decoration.labelStyle,
        floatingLabelStyle: decoration.floatingLabelStyle,
        helper: decoration.helper,
        helperText: decoration.helperText,
        helperStyle: decoration.helperStyle,
        helperMaxLines: decoration.helperMaxLines,
        hintText: decoration.hintText,
        hint: decoration.hint,
        hintStyle: decoration.hintStyle,
        hintTextDirection: decoration.hintTextDirection,
        hintMaxLines: decoration.hintMaxLines,
        hintFadeDuration: decoration.hintFadeDuration,
        maintainHintSize: decoration.maintainHintSize,
        maintainLabelSize: decoration.maintainLabelSize,
        error: decoration.error,
        errorText: decoration.errorText,
        errorStyle: decoration.errorStyle,
        errorMaxLines: decoration.errorMaxLines,
        floatingLabelBehavior: _byName(
          legacy.FloatingLabelBehavior.values,
          decoration.floatingLabelBehavior,
        ),
        floatingLabelAlignment: _floatingLabelAlignment(
          decoration.floatingLabelAlignment,
        ),
        isCollapsed: decoration.isCollapsed,
        isDense: decoration.isDense,
        contentPadding: decoration.contentPadding,
        prefixIcon: decoration.prefixIcon,
        prefixIconConstraints: decoration.prefixIconConstraints,
        prefix: decoration.prefix,
        prefixText: decoration.prefixText,
        prefixStyle: decoration.prefixStyle,
        prefixIconColor: decoration.prefixIconColor,
        suffixIcon: decoration.suffixIcon,
        suffix: decoration.suffix,
        suffixText: decoration.suffixText,
        suffixStyle: decoration.suffixStyle,
        suffixIconColor: decoration.suffixIconColor,
        suffixIconConstraints: decoration.suffixIconConstraints,
        counter: decoration.counter,
        counterText: decoration.counterText,
        counterStyle: decoration.counterStyle,
        filled: decoration.filled,
        fillColor: decoration.fillColor,
        focusColor: decoration.focusColor,
        hoverColor: decoration.hoverColor,
        errorBorder: inputBorder(decoration.errorBorder),
        focusedBorder: inputBorder(decoration.focusedBorder),
        focusedErrorBorder: inputBorder(decoration.focusedErrorBorder),
        disabledBorder: inputBorder(decoration.disabledBorder),
        enabledBorder: inputBorder(decoration.enabledBorder),
        border: inputBorder(decoration.border),
        enabled: decoration.enabled,
        semanticCounterText: decoration.semanticCounterText,
        alignLabelWithHint: decoration.alignLabelWithHint,
        constraints: decoration.constraints,
        visualDensity: _visualDensityOrNull(decoration.visualDensity),
      );

  /// Converts [WidgetStateInputBorder], [OutlineInputBorder],
  /// [UnderlineInputBorder] and [InputBorder.none]. Any other border becomes
  /// an outline or underline border with the same side, by its `isOutline`.
  static legacy.InputBorder? inputBorder(InputBorder? border) {
    if (border == null) return null;
    // Checked first: the resolveWith variant is itself an OutlineInputBorder.
    if (border is WidgetStateInputBorder) {
      return legacy.WidgetStateInputBorder.resolveWith(
        (states) => inputBorder(border.resolve(states))!,
      );
    }
    if (border is OutlineInputBorder) {
      return legacy.OutlineInputBorder(
        borderSide: border.borderSide,
        borderRadius: border.borderRadius,
        gapPadding: border.gapPadding,
      );
    }
    if (border is UnderlineInputBorder) {
      return legacy.UnderlineInputBorder(
        borderSide: border.borderSide,
        borderRadius: border.borderRadius,
      );
    }
    if (border == InputBorder.none) return legacy.InputBorder.none;
    return border.isOutline
        ? legacy.OutlineInputBorder(borderSide: border.borderSide)
        : legacy.UnderlineInputBorder(borderSide: border.borderSide);
  }

  /// Maps the ink factories both libraries declare; any other factory
  /// leaves the SDK default.
  static legacy.InteractiveInkFeatureFactory? _splashFactory(
    InteractiveInkFeatureFactory? factory,
  ) => switch (factory) {
    InkSplash.splashFactory => legacy.InkSplash.splashFactory,
    InkRipple.splashFactory => legacy.InkRipple.splashFactory,
    InkSparkle.splashFactory => legacy.InkSparkle.splashFactory,
    InkSparkle.constantTurbulenceSeedSplashFactory =>
      legacy.InkSparkle.constantTurbulenceSeedSplashFactory,
    NoSplash.splashFactory => legacy.NoSplash.splashFactory,
    _ => null,
  };

  static legacy.FloatingLabelAlignment? _floatingLabelAlignment(
    FloatingLabelAlignment? alignment,
  ) => switch (alignment) {
    null => null,
    FloatingLabelAlignment.center => legacy.FloatingLabelAlignment.center,
    _ => legacy.FloatingLabelAlignment.start,
  };

  static legacy.VisualDensity _visualDensity(VisualDensity density) =>
      legacy.VisualDensity(
        horizontal: density.horizontal,
        vertical: density.vertical,
      );

  static legacy.VisualDensity? _visualDensityOrNull(VisualDensity? density) =>
      density == null ? null : _visualDensity(density);

  static T? _byName<T extends Enum>(List<T> values, Enum? value) =>
      value == null ? null : values.byName(value.name);
}

/// Provides SDK Material context to the SDK widgets below it: an SDK `Theme`
/// converted from the app's `Theme.of(context)`, the SDK counterpart of a
/// local `InputDecorationTheme`, and, with [material], an SDK transparency
/// `Material` for their ink and text fields.
///
/// Everything is derived at this widget's own position, so a local `Theme`
/// or `InputDecorationTheme` above it carries over, and SDK dialogs opened
/// from below it capture the converted theme. The app must also register
/// [LegacyMaterial.localizationsDelegates]; with [material] on, a debug check
/// reports a missing registration on the first build.
///
/// Wrap an app's own SDK Material widgets in a scope too, or install one with
/// [material] off in `MaterialApp.builder` to cover every route.
class LegacyMaterialScope extends StatelessWidget {
  const LegacyMaterialScope({
    super.key,
    this.material = true,
    required this.child,
  });

  final bool material;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    assert(!material || _debugCheckHasLegacyLocalizations(context));
    Widget result = child;
    if (material) {
      result = legacy.Material(
        type: legacy.MaterialType.transparency,
        // Material resets DefaultTextStyle below it; keep the inherited one.
        textStyle: DefaultTextStyle.of(context).style,
        child: result,
      );
    }
    final localInputs = context
        .dependOnInheritedWidgetOfExactType<InputDecorationTheme>();
    if (localInputs != null) {
      result = legacy.InputDecorationTheme(
        data: LegacyMaterial._localInputDecorationTheme(localInputs),
        child: result,
      );
    }
    return legacy.Theme(
      data: LegacyMaterial.themeFrom(Theme.of(context)),
      child: result,
    );
  }

  static bool _debugCheckHasLegacyLocalizations(BuildContext context) {
    if (Localizations.of<legacy.MaterialLocalizations>(
          context,
          legacy.MaterialLocalizations,
        ) ==
        null) {
      throw FlutterError.fromParts([
        ErrorSummary(
          'No flutter/material.dart MaterialLocalizations found for '
          'LegacyMaterialScope.',
        ),
        ErrorDescription(
          'The widgets below a LegacyMaterialScope are built on '
          'flutter/material.dart and look up its MaterialLocalizations, which '
          "material_ui's GlobalMaterialLocalizations.delegates do not provide.",
        ),
        ErrorHint(
          'Add LegacyMaterial.localizationsDelegates to '
          'MaterialApp.localizationsDelegates, next to '
          'GlobalMaterialLocalizations.delegates.',
        ),
        ...context.describeMissingAncestor(
          expectedAncestorType: legacy.MaterialLocalizations,
        ),
      ]);
    }
    return true;
  }
}
