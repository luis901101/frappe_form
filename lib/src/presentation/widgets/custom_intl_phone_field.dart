import 'package:flutter/material.dart';
import 'package:frappe_form/frappe_form.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class CustomIntlPhoneField extends IntlPhoneField {
  CustomIntlPhoneField({
    super.key,
    String? initialCountryCode,
    super.obscureText = false,
    super.textAlign = TextAlign.left,
    super.textAlignVertical,
    super.onTap,
    super.readOnly = false,
    super.initialValue,
    super.keyboardType = TextInputType.phone,
    super.controller,
    super.focusNode,
    super.decoration = const InputDecoration(),
    super.style,
    super.dropdownTextStyle = const TextStyle(fontSize: 16),
    super.onSubmitted,
    super.validator,
    super.onChanged,
    super.countries,
    super.onCountryChanged,
    super.onSaved,
    super.showDropdownIcon = true,
    super.dropdownDecoration = const BoxDecoration(),
    super.inputFormatters,
    super.enabled = true,
    super.keyboardAppearance,
    @Deprecated('Use searchFieldInputDecoration of PickerDialogStyle instead')
    super.searchText = 'Search country',
    super.dropdownIconPosition = IconPosition.trailing,
    super.dropdownIcon = const Icon(Icons.arrow_drop_down),
    super.autofocus = false,
    super.textInputAction,
    super.autovalidateMode = AutovalidateMode.onUserInteraction,
    super.showCountryFlag = true,
    super.cursorColor,
    super.disableLengthCheck = false,
    super.flagsButtonPadding = const EdgeInsets.only(left: 8),
    String? invalidNumberMessage,
    super.cursorHeight,
    super.cursorRadius = Radius.zero,
    super.cursorWidth = 2.0,
    super.showCursor = true,
    PickerDialogStyle? pickerDialogStyle,
    super.flagsButtonMargin = EdgeInsets.zero,
  }) : super(
          initialCountryCode: initialCountryCode ?? defaultInitialCountryCode,
          invalidNumberMessage: invalidNumberMessage ??
              DocFormLocalization
                  .instance.localization.exceptionInvalidPhoneNumber,
          pickerDialogStyle: pickerDialogStyle ??
              PickerDialogStyle(
                  searchFieldInputDecoration: InputDecoration(
                      hintText: DocFormLocalization
                          .instance.localization.textSearchPhoneCountryCode)),
        );

  static String get defaultInitialCountryCode =>
      DocFormLocalization.instance.localization.locale.countryCode ?? 'US';
  static Country get defaultInitialCountry {
    return countries.firstWhere(
        (country) => country.code == defaultInitialCountryCode,
        orElse: () => countries.first);
  }

  static PhoneInfo parse(String? number) {
    if (number == null) return PhoneInfo(country: defaultInitialCountry);
    final tempNumber = (number.startsWith('+') ? number.substring(1) : number)
        .replaceAll('(', '')
        .replaceAll(')', '')
        .replaceAll(' ', '');
    final country = countries.firstWhere((country) {
      if (tempNumber.startsWith(country.dialCode)) {
        final numberLength = tempNumber.length - country.dialCode.length;
        return numberLength >= country.minLength &&
            numberLength <= country.maxLength;
      }
      return false;
    }, orElse: () => defaultInitialCountry);
    return PhoneInfo(
        number: tempNumber.length >= country.dialCode.length
            ? tempNumber.substring(country.dialCode.length)
            : tempNumber,
        country: country);
  }
}

class PhoneInfo {
  String? number;
  Country? country;

  PhoneInfo({
    this.number,
    this.country,
  });

  String get completeNumber =>
      '${country?.dialCode != null ? '+${country?.dialCode}' : ''}$number';
}
