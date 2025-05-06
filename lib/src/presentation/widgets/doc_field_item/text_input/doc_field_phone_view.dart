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
    super.enableWhenController,
  }) : super(
            controller: controller ??
                CustomTextEditingController(
                  focusNode: FocusNode(),
                ));

  @override
  State createState() => DocFieldPhoneViewState();
}

class DocFieldPhoneViewState<SF extends DocFieldPhoneView>
    extends DocFieldViewState<SF> {
  String? initialPhoneNumber;
  String? phoneNumber;
  Country? phoneCountry;
  bool isValidPhoneNumber = true;

  @override
  CustomTextEditingController get controller =>
      super.controller as CustomTextEditingController;
  @override
  void initState() {
    super.initState();
    if (controller.text.isEmpty) {
      final initial = field.initial?.toString();

      if (initial.isNotEmpty) {
        controller.text = initial!;
        try {
          isValidPhoneNumber = true;
          final phoneInfo = CustomIntlPhoneField.parse(phoneNumber = initial);
          initialPhoneNumber = phoneInfo.number;
          phoneCountry = phoneInfo.country;
        } catch (e) {
          if (kDebugMode) {
            print(e);
          }
        }
      }
    }

    controller.validations.addAll([
      if ((maxLength ?? 0) > 0)
        ValidationUtils.maxLengthValidation(maxLength: maxLength!),
    ]);
  }

  TextInputType? get keyboardType => TextInputType.text;
  TextInputAction? get textInputAction => TextInputAction.next;
  TextCapitalization? get textCapitalization => TextCapitalization.sentences;
  int? get maxLines => null;

  @override
  Widget buildBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (field.title.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
              right: 8.0,
              bottom: 4.0,
            ),
            child: Text(
              field.title,
              style: theme.textTheme.titleSmall,
            ),
          ),
        CustomIntlPhoneField(
          key: ValueKey('phoneController-${controller.hasError}'),
          // controller: phoneController,
          initialValue: initialPhoneNumber,
          initialCountryCode: phoneCountry?.code,
          textInputAction: TextInputAction.next,
          focusNode: controller.focusNode,
          onCountryChanged: (country) => phoneCountry = country,
          validator: (phoneNumber) async {
            isValidPhoneNumber = (phoneNumber?.number.isEmpty ?? true) ||
                ValidationUtils.isPhoneNumberValid(
                    number: phoneNumber?.number, country: phoneCountry);
            return isValidPhoneNumber
                ? null
                : DocFormLocalization
                    .instance.localization.exceptionInvalidPhoneNumber;
          },
          onSubmitted: (term) {
            controller.focusNode?.unfocus();
          },
          onChanged: (phone) {
            if (controller.hasError) {
              controller.clear();
              setState(() {});
            }
            phoneNumber = phone.completeNumber;
            controller.text = phoneNumber!;
          },
          decoration: InputDecoration(
            hintText: DocFormLocalization.instance.localization.textPhone,
            errorText: controller.error,
          ),
        ),
      ],
    );
  }
}
