import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:frappe_form/frappe_form.dart';
import 'package:flutter/material.dart';

/// Created by luis901101 on 05/06/25.
class DocFieldRatingView extends DocFieldView {
  DocFieldRatingView({
    super.key,
    required super.field,
    CustomValueController<double>? controller,
    super.enableWhenController,
  }) : super(
            controller: controller ??
                CustomValueController<double>(
                  focusNode: FocusNode(),
                ));

  @override
  State createState() => DocFieldRatingViewState();
}

class DocFieldRatingViewState extends DocFieldViewState<DocFieldRatingView> {
  @override
  CustomValueController<double> get controller =>
      super.controller as CustomValueController<double>;

  @override
  void initState() {
    super.initState();
    controller.value ??= field.initial?.toString().asDouble;
  }

  @override
  Widget buildBody(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RatingBar(
          initialRating: controller.value ?? 0,
          minRating: 0,
          maxRating: 5,
          itemCount: 5,
          direction: Axis.horizontal,
          ignoreGestures: field.isRadOnly,
          allowHalfRating: true,
          glowColor: Colors.yellow,
          ratingWidget: RatingWidget(
            full: const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            half: const Icon(
              Icons.star_half,
              color: Colors.amber,
            ),
            empty: const Icon(
              Icons.star_outline,
              color: Colors.amber,
            ),
          ),
          // itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
          onRatingUpdate: (rating) {
            controller.value = rating / 5;
          },
        ),
      ],
    );
  }
}
