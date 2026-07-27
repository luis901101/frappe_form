import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frappe_form/frappe_form.dart';
import 'package:intl_phone_field/countries.dart';

/// Created by luis901101 on 05/02/25.
class DocFieldPhoneView extends DocFieldView {
  DocFieldPhoneView({
    super.key,
    CustomTextEditingController? controller,
    required super.field,
    super.dependsOnController,
  }) : super(
         controller:
             controller ?? CustomTextEditingController(focusNode: FocusNode()),
       );

  @override
  CustomTextEditingController get controller =>
      super.controller as CustomTextEditingController;

  @override
  void initController() {
    super.initController();
    if (controller.text.isEmpty) {
      final initial = field.initial?.toString();
      if (initial.isNotEmpty) {
        controller.text = PhoneUtils.parse(initial).toFrappePhone;
      }
    }
  }

  @override
  State createState() => DocFieldPhoneViewState();
}

class DocFieldPhoneViewState<SF extends DocFieldPhoneView>
    extends DocFieldViewState<SF> {
  String? initialPhoneNumber;
  Country? phoneCountry;
  bool isValidPhoneNumber = true;

  @override
  CustomTextEditingController get controller =>
      super.controller as CustomTextEditingController;
  @override
  void initState() {
    super.initState();
    try {
      isValidPhoneNumber = true;
      final phoneInfo = PhoneUtils.parse(controller.text);
      initialPhoneNumber = phoneInfo.number;
      phoneCountry = phoneInfo.country;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  TextInputType? get keyboardType => TextInputType.text;
  TextInputAction? get textInputAction => TextInputAction.next;
  TextCapitalization? get textCapitalization => TextCapitalization.sentences;
  int? get maxLines => null;

  @override
  Widget buildBody(BuildContext context) {
    return CustomIntlPhoneField(
      key: ValueKey('phoneController-${controller.hasError}'),
      // controller: phoneController,
      initialValue: initialPhoneNumber,
      focusNode: controller.focusNode,
      enabled: !isReadOnly,
      initialCountryCode: phoneCountry?.code,
      textInputAction: TextInputAction.next,
      onCountryChanged: (country) => phoneCountry = country,
      validator: (phoneNumber) async {
        isValidPhoneNumber =
            (phoneNumber?.number.isEmpty ?? true) ||
            ValidationUtils.isPhoneNumberValid(
              number: phoneNumber?.number,
              country: phoneCountry,
            );
        return isValidPhoneNumber
            ? null
            : DocFormLocalization
                  .instance
                  .localization
                  .exceptionInvalidPhoneNumber;
      },
      onSubmitted: (term) {
        controller.focusNode?.unfocus();
      },
      onChanged: (phone) {
        if (controller.hasError) {
          controller.clear();
          setState(() {});
        }
        controller.text = phone.toFrappePhone;
      },
      decoration: InputDecoration(
        hintText:
            placeholder ?? DocFormLocalization.instance.localization.textPhone,
        errorText: controller.error,
      ),
    );
  }
}
