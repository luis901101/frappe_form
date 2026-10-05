import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:frappe_form/frappe_form.dart';
import 'package:material_ui/material_ui.dart';

/// Created by luis901101 on 05/06/25.
class DocFieldRatingView extends DocFieldView {
  DocFieldRatingView({
    super.key,
    required super.field,
    CustomValueController<double>? controller,
    super.dependsOnController,
  }) : super(
         controller:
             controller ??
             CustomValueController<double>(focusNode: FocusNode()),
       );

  @override
  CustomValueController<double> get controller =>
      super.controller as CustomValueController<double>;

  @override
  void initController() {
    super.initController();
    controller.value ??= field.initial?.toString().asDouble;
  }

  @override
  State createState() => DocFieldRatingViewState();
}

class DocFieldRatingViewState<SF extends DocFieldRatingView>
    extends DocFieldViewState<SF> {
  @override
  CustomValueController<double> get controller =>
      super.controller as CustomValueController<double>;

  void onRatingUpdate(double rating) => controller.value = rating / 5;

  double get initialRating => (controller.value ?? 0) * 5;

  @override
  Widget buildBody(BuildContext context) {
    // RatingBar brings its own Material; the scope keeps its theme reads
    // (the unrated colour) on the app theme.
    return LegacyMaterialScope(
      material: false,
      child: RatingBar(
        initialRating: initialRating,
        minRating: 0,
        maxRating: 5,
        itemCount: 5,
        direction: Axis.horizontal,
        ignoreGestures: isReadOnly,
        allowHalfRating: true,
        glowColor: Colors.yellow,
        ratingWidget: RatingWidget(
          full: const Icon(Icons.star, color: Colors.amber),
          half: const Icon(Icons.star_half, color: Colors.amber),
          empty: const Icon(Icons.star_outline, color: Colors.amber),
        ),
        // itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
        onRatingUpdate: onRatingUpdate,
      ),
    );
  }
}
