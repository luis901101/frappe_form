import 'dart:async';

import 'package:flutter/services.dart';
import 'package:frappe_form/frappe_form.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:material_ui/material_ui.dart';

/// An [IntlPhoneField] with this package's defaults and localized messages,
/// themed from the app's `material_ui` theme through a [LegacyMaterialScope].
class CustomIntlPhoneField extends StatelessWidget {
  const CustomIntlPhoneField({
    super.key,
    this.initialCountryCode,
    this.obscureText = false,
    this.textAlign = TextAlign.left,
    this.textAlignVertical,
    this.onTap,
    this.readOnly = false,
    this.initialValue,
    this.keyboardType = TextInputType.phone,
    this.controller,
    this.focusNode,
    this.decoration = const InputDecoration(),
    this.style,
    this.dropdownTextStyle = const TextStyle(fontSize: 16),
    this.onSubmitted,
    this.validator,
    this.onChanged,
    this.countries,
    this.onCountryChanged,
    this.onSaved,
    this.showDropdownIcon = true,
    this.dropdownDecoration = const BoxDecoration(),
    this.inputFormatters,
    this.enabled = true,
    this.keyboardAppearance,
    this.dropdownIconPosition = IconPosition.trailing,
    this.dropdownIcon = const Icon(Icons.arrow_drop_down),
    this.autofocus = false,
    this.textInputAction,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.showCountryFlag = true,
    this.cursorColor,
    this.disableLengthCheck = false,
    this.flagsButtonPadding = const EdgeInsets.only(left: 8),
    this.invalidNumberMessage,
    this.cursorHeight,
    this.cursorRadius = Radius.zero,
    this.cursorWidth = 2.0,
    this.showCursor = true,
    this.pickerDialogStyle,
    this.searchFieldInputDecoration,
    this.flagsButtonMargin = EdgeInsets.zero,
  });

  /// Defaults to [PhoneUtils.defaultInitialCountryCode].
  final String? initialCountryCode;
  final bool obscureText;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final VoidCallback? onTap;
  final bool readOnly;
  final String? initialValue;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final InputDecoration decoration;
  final TextStyle? style;
  final TextStyle? dropdownTextStyle;
  final void Function(String)? onSubmitted;
  final FutureOr<String?> Function(PhoneNumber?)? validator;
  final ValueChanged<PhoneNumber>? onChanged;
  final List<Country>? countries;
  final ValueChanged<Country>? onCountryChanged;
  final FormFieldSetter<PhoneNumber>? onSaved;
  final bool showDropdownIcon;
  final BoxDecoration dropdownDecoration;
  final List<TextInputFormatter>? inputFormatters;
  final bool enabled;
  final Brightness? keyboardAppearance;
  final IconPosition dropdownIconPosition;
  final Icon dropdownIcon;
  final bool autofocus;
  final TextInputAction? textInputAction;
  final AutovalidateMode? autovalidateMode;
  final bool showCountryFlag;
  final Color? cursorColor;
  final bool disableLengthCheck;
  final EdgeInsetsGeometry flagsButtonPadding;

  /// Defaults to the localized invalid phone number message.
  final String? invalidNumberMessage;
  final double? cursorHeight;
  final Radius? cursorRadius;
  final double cursorWidth;
  final bool? showCursor;
  final PickerDialogStyle? pickerDialogStyle;

  /// The country picker's search field decoration. Takes precedence over
  /// [pickerDialogStyle]'s, and defaults to the localized search hint.
  final InputDecoration? searchFieldInputDecoration;
  final EdgeInsets flagsButtonMargin;

  @override
  Widget build(BuildContext context) {
    final localization = DocFormLocalization.instance.localization;
    return LegacyMaterialScope(
      child: IntlPhoneField(
        initialCountryCode:
            initialCountryCode ?? PhoneUtils.defaultInitialCountryCode,
        obscureText: obscureText,
        textAlign: textAlign,
        textAlignVertical: textAlignVertical,
        onTap: onTap,
        readOnly: readOnly,
        initialValue: initialValue,
        keyboardType: keyboardType,
        controller: controller,
        focusNode: focusNode,
        decoration: LegacyMaterial.inputDecoration(decoration),
        style: style,
        dropdownTextStyle: dropdownTextStyle,
        onSubmitted: onSubmitted,
        validator: validator,
        onChanged: onChanged,
        countries: countries,
        onCountryChanged: onCountryChanged,
        onSaved: onSaved,
        showDropdownIcon: showDropdownIcon,
        dropdownDecoration: dropdownDecoration,
        inputFormatters: inputFormatters,
        enabled: enabled,
        keyboardAppearance: keyboardAppearance,
        dropdownIconPosition: dropdownIconPosition,
        dropdownIcon: dropdownIcon,
        autofocus: autofocus,
        textInputAction: textInputAction,
        autovalidateMode: autovalidateMode,
        showCountryFlag: showCountryFlag,
        cursorColor: cursorColor,
        disableLengthCheck: disableLengthCheck,
        flagsButtonPadding: flagsButtonPadding,
        invalidNumberMessage:
            invalidNumberMessage ?? localization.exceptionInvalidPhoneNumber,
        cursorHeight: cursorHeight,
        cursorRadius: cursorRadius,
        cursorWidth: cursorWidth,
        showCursor: showCursor,
        pickerDialogStyle: _pickerDialogStyle(
          localization.textSearchPhoneCountryCode,
        ),
        flagsButtonMargin: flagsButtonMargin,
      ),
    );
  }

  /// [PickerDialogStyle] has no `copyWith`, so the search decoration is
  /// merged into a copy field by field.
  PickerDialogStyle _pickerDialogStyle(String searchHint) {
    final style = pickerDialogStyle;
    final searchDecoration = searchFieldInputDecoration;
    return PickerDialogStyle(
      backgroundColor: style?.backgroundColor,
      countryCodeStyle: style?.countryCodeStyle,
      countryNameStyle: style?.countryNameStyle,
      listTileDivider: style?.listTileDivider,
      listTilePadding: style?.listTilePadding,
      padding: style?.padding,
      searchFieldCursorColor: style?.searchFieldCursorColor,
      searchFieldInputDecoration: searchDecoration != null
          ? LegacyMaterial.inputDecoration(searchDecoration)
          : style?.searchFieldInputDecoration ??
                LegacyMaterial.inputDecoration(
                  InputDecoration(hintText: searchHint),
                ),
      searchFieldPadding: style?.searchFieldPadding,
      width: style?.width,
    );
  }
}
