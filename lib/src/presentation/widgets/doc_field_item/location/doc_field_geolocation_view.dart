import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:frappe_form/frappe_form.dart';

/// Created by luis901101 on 05/02/25.
class DocFieldGeolocationView extends DocFieldView {
  DocFieldGeolocationView({
    super.key,
    CustomValueController<DocGeolocation>? controller,
    required super.field,
    super.dependsOnController,
  }) : super(
         controller:
             controller ??
             CustomValueController<DocGeolocation>(focusNode: FocusNode()),
       );

  @override
  CustomValueController<DocGeolocation> get controller =>
      super.controller as CustomValueController<DocGeolocation>;

  @override
  void initController() {
    super.initController();
    if (controller.value == null) {
      try {
        if (field.initial?.toString().isNotEmpty ?? false) {
          final initial = DocGeolocation.fromJsonString(
            field.initial!.toString(),
          );
          controller.value = initial;
        }
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }
  }

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
    initValue();
    initControllers();
  }

  void initValue() {
    latitude = controller.value?.features?.first.geometry?.latitude;
    longitude = controller.value?.features?.first.geometry?.longitude;
  }

  void initControllers() {
    latController = CustomTextEditingController(
      text: latitude?.toString() ?? '',
      focusNode: FocusNode(),
    );
    lngController = CustomTextEditingController(
      text: longitude?.toString() ?? '',
      focusNode: FocusNode(),
    );
  }

  void onLocationChanged() {
    if (latitude == null || longitude == null) return;
    controller.value = DocGeolocation.fromLatLng(
      latitude: latitude!,
      longitude: longitude!,
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
                keyboardType: const TextInputType.numberWithOptions(
                  signed: true,
                  decimal: true,
                ),
                onSubmitted: (_) {
                  latController.focusNode?.unfocus();
                  lngController.focusNode?.requestFocus();
                },
                decoration: InputDecoration(
                  labelText:
                      DocFormLocalization.instance.localization.textLatitude,
                ),
                onChanged: (text) {
                  latitude = double.tryParse(text);
                  onLocationChanged();
                },
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
                keyboardType: const TextInputType.numberWithOptions(
                  signed: true,
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText:
                      DocFormLocalization.instance.localization.textLongitude,
                ),
                onChanged: (text) {
                  longitude = double.tryParse(text);
                  onLocationChanged();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
