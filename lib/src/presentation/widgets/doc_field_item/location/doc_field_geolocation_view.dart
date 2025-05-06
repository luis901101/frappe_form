import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frappe_form/frappe_form.dart';

/// Created by luis901101 on 05/02/25.
class DocFieldGeolocationView extends DocFieldView {
  DocFieldGeolocationView({
    super.key,
    CustomValueController<DocGeolocation>? controller,
    required super.field,
    super.enableWhenController,
  }) : super(
            controller: controller ??
                CustomValueController<DocGeolocation>(
                  focusNode: FocusNode(),
                ));

  @override
  State createState() => DocFieldGeolocationViewState();
}

class DocFieldGeolocationViewState<SF extends DocFieldGeolocationView>
    extends DocFieldViewState<SF> {
  @override
  CustomValueController<DocGeolocation> get controller =>
      super.controller as CustomValueController<DocGeolocation>;

  late CustomTextEditingController latController;
  late CustomTextEditingController lngController;

  double? latitude, longitude;

  @override
  void initState() {
    super.initState();
    if (controller.value == null) {
      try {
        if (field.initial?.toString().isNotEmpty ?? false) {
          final initial =
              DocGeolocation.fromJsonString(field.initial!.toString());
          controller.value = initial;
        }
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }

    latitude = controller.value?.features?.first.geometry?.coordinates?[0];
    longitude = controller.value?.features?.first.geometry?.coordinates?[1];

    latController = CustomTextEditingController(
      text: latitude?.toString() ?? '',
      focusNode: FocusNode(),
    );
    lngController = CustomTextEditingController(
      text: longitude?.toString() ?? '',
      focusNode: FocusNode(),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: latController,
                focusNode: latController.focusNode,
                enabled: !isReadOnly,
                maxLength: maxLength,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.numberWithOptions(
                    signed: true, decimal: true),
                onSubmitted: (_) {
                  latController.focusNode?.unfocus();
                  lngController.focusNode?.requestFocus();
                },
                decoration: InputDecoration(
                  labelText:
                      DocFormLocalization.instance.localization.textLatitude,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: CustomTextField(
                controller: lngController,
                focusNode: lngController.focusNode,
                enabled: !isReadOnly,
                maxLength: maxLength,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.numberWithOptions(
                    signed: true, decimal: true),
                decoration: InputDecoration(
                  labelText:
                      DocFormLocalization.instance.localization.textLongitude,
                ),
              ),
            ),
          ],
        ),
        if (handleControllerErrorManually && controller.hasError)
          Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
              right: 8.0,
              top: 4.0,
            ),
            child: Text(
              '${controller.error}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
      ],
    );
  }
}
