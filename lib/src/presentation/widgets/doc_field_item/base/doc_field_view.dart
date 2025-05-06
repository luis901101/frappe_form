import 'package:flutter/material.dart';
import 'package:frappe_form/src/entity/doc_field.dart';
import 'package:frappe_form/src/logic/utils/text_utils.dart';
import 'package:frappe_form/src/model/doc_field_depends_on_controller.dart';
import 'package:frappe_form/src/presentation/utils/validation_utils.dart';
import 'package:frappe_form/src/presentation/widgets/size_renderer.dart';

/// Created by luis901101 on 04/21/25.
abstract class DocFieldView extends StatefulWidget {
  final FieldController controller;
  final DocField field;
  final List<DocFieldView>? children;
  final DocFieldDependsOnController? enableWhenController;
  const DocFieldView(
      {super.key,
      required this.controller,
      required this.field,
      this.children,
      this.enableWhenController});
}

abstract class DocFieldViewState<SF extends DocFieldView> extends State<SF>
    with AutomaticKeepAliveClientMixin {
  ThemeData theme = ThemeData();
  bool isEnabled = true;
  String? lastControllerError;
  FieldController get controller => widget.controller;
  DocFieldDependsOnController? get enableWhenController =>
      widget.enableWhenController;
  DocField get field => widget.field;
  List<DocFieldView>? get children => widget.children;

  bool get isRequired => field.isRequired;
  bool get isReadOnly => field.isRadOnly;
  int? get maxLength => field.maxLength;
  @override
  bool get wantKeepAlive => false;

  bool get isHidden => field.isHidden;

  bool get handleControllerErrorManually => true;

  @override
  void initState() {
    super.initState();
    if (handleControllerErrorManually) {
      controller.addListener(onControllerErrorChanged);
    }
    controller.validations.addAll([
      if (isRequired) ValidationUtils.requiredFieldValidation,
    ]);
    isEnabled =
        enableWhenController?.init(onEnabledChangedListener: onEnabled) ?? true;
  }

  void onControllerErrorChanged() {
    if (lastControllerError != controller.error) {
      lastControllerError = controller.error;
      setState(() {});
    } else if (lastControllerError.isNotEmpty && controller.isNotEmpty) {
      controller.clearError();
      setState(() {});
    }
  }

  void onEnabled(bool enabled) {
    if (isEnabled != enabled) {
      setState(() => isEnabled = enabled);
    }
  }

  @override
  void setState(VoidCallback fn) {
    if (!mounted) return;
    super.setState(fn);
  }

  Widget buildBody(BuildContext context);

  Widget? buildDescriptionView(BuildContext context) {
    if (field.description.isEmpty) return null;
    final inputBorderRadius = (theme.inputDecorationTheme.border
            is OutlineInputBorder)
        ? (theme.inputDecorationTheme.border as OutlineInputBorder).borderRadius
        : const BorderRadius.all(Radius.circular(4));
    return Padding(
      padding: EdgeInsets.only(
        top: 8,
        left: inputBorderRadius.bottomLeft.x / 2,
        right: inputBorderRadius.bottomLeft.x / 2,
      ),
      child: Text(
        field.description!,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.outline,
        ),
      ),
    );
  }

  EdgeInsetsGeometry get defaultPadding => const EdgeInsets.only(bottom: 24.0);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    theme = Theme.of(context);
    final descriptionView = buildDescriptionView(context);
    return isHidden
        ? const SizedBox.shrink()
        : AnimatedSize(
            duration: const Duration(milliseconds: 300),
            child: ClipRect(
              clipBehavior: Clip.hardEdge,
              child: SizedBox(
                height: isEnabled ? null : 0,
                child: SizeRenderer(
                  onSizeRendered: onSizeRendered,
                  child: Padding(
                    padding: defaultPadding,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildBody(context),
                        if (descriptionView != null) descriptionView,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  void onSizeRendered(Size size, GlobalKey key) {
    controller.size = size;
    controller.key = key;
  }

  @override
  void dispose() {
    controller.removeListener(onControllerErrorChanged);
    enableWhenController?.dispose();
    super.dispose();
  }
}
