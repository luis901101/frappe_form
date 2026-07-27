import 'package:flutter/material.dart';
import 'package:frappe_form/src/entity/doc_field.dart';
import 'package:frappe_form/src/logic/utils/text_utils.dart';
import 'package:frappe_form/src/model/doc_field_bundle.dart';
import 'package:frappe_form/src/model/doc_field_depends_on_controller.dart';
import 'package:frappe_form/src/presentation/utils/validation_utils.dart';
import 'package:frappe_form/src/presentation/widgets/custom_html.dart';
import 'package:frappe_form/src/presentation/widgets/size_renderer.dart';

/// Created by luis901101 on 04/21/25.
abstract class DocFieldView extends StatefulWidget {
  final FieldController controller;
  final DocField field;
  final List<DocFieldView> children;
  final List<DocFieldBundle> childrenBundles;
  final DocFieldDependsOnController dependsOnController;
  static final ValidationController defaultRequiredFieldValidation =
      ValidationUtils.requiredFieldValidation;
  DocFieldView({
    super.key,
    required this.controller,
    required this.field,
    List<DocFieldView>? children,
    List<DocFieldBundle>? childrenBundles,
    DocFieldDependsOnController? dependsOnController,
  }) : children = children ?? <DocFieldView>[],
       childrenBundles = childrenBundles ?? <DocFieldBundle>[],
       dependsOnController =
           dependsOnController ?? DocFieldDependsOnController() {
    initController();
  }

  bool get isRequired => field.isRequired;
  bool get isReadOnly => field.isReadOnly;
  int? get maxLength => field.maxLength;

  void initController() {
    controller.validations.addAll({
      if (isRequired) defaultRequiredFieldValidation,
      if ((maxLength ?? 0) > 0)
        ValidationUtils.maxLengthValidation(maxLength: maxLength!),
    });
  }
}

abstract class DocFieldViewState<SF extends DocFieldView> extends State<SF>
    with AutomaticKeepAliveClientMixin {
  ThemeData theme = ThemeData();
  bool isRequiredFromDependencies = false;
  bool isReadOnlyFromDependencies = false;
  bool isVisibleFromDependencies = true;
  String? lastControllerError;
  FieldController get controller => widget.controller;
  DocFieldDependsOnController? get dependsOnController =>
      widget.dependsOnController;
  DocField get field => widget.field;
  List<DocFieldView> get children => widget.children;
  List<DocFieldBundle> get childrenBundles => widget.childrenBundles;

  bool get isRequired => widget.isRequired || isRequiredFromDependencies;
  bool get isReadOnly => widget.isReadOnly || isReadOnlyFromDependencies;
  int? get maxLength => widget.maxLength;
  @override
  bool get wantKeepAlive => false;

  bool get isHidden => field.isHidden;

  String? get placeholder => field.placeholder;

  bool get handleControllerErrorManually => true;

  @override
  void initState() {
    super.initState();
    if (handleControllerErrorManually) {
      controller.addListener(onControllerErrorChanged);
    }
    isRequiredFromDependencies =
        dependsOnController?.listenOnRequiredDependsOnChangesAndCheck(
          onRequiredFromDependenciesChanged,
        ) ??
        false;
    isReadOnlyFromDependencies =
        dependsOnController?.listenOnReadOnlyDependsOnChangesAndCheck(
          onReadOnlyFromDependenciesChanged,
        ) ??
        false;
    isVisibleFromDependencies =
        dependsOnController?.listenOnVisibilityDependsOnChangesAndCheck(
          onVisibilityFromDependenciesChanged,
        ) ??
        true;
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

  void onRequiredFromDependenciesChanged(bool value) {
    if (isRequiredFromDependencies != value) {
      if (value) {
        controller.validations.add(DocFieldView.defaultRequiredFieldValidation);
      } else {
        controller.validations.remove(
          DocFieldView.defaultRequiredFieldValidation,
        );
      }
      setState(() => isRequiredFromDependencies = value);
    }
  }

  void onReadOnlyFromDependenciesChanged(bool value) {
    if (isReadOnlyFromDependencies != value) {
      setState(() => isReadOnlyFromDependencies = value);
    }
  }

  void onVisibilityFromDependenciesChanged(bool value) {
    if (isVisibleFromDependencies != value) {
      setState(() => isVisibleFromDependencies = value);
    }
  }

  @override
  void setState(VoidCallback fn) {
    if (!mounted) return;
    super.setState(fn);
  }

  Widget buildBody(BuildContext context);

  Widget? buildTitleView(BuildContext context) {
    if (field.title.isEmpty && !isRequired) return null;
    final fieldRadius =
        (theme.inputDecorationTheme.border is OutlineInputBorder)
        ? (theme.inputDecorationTheme.border as OutlineInputBorder).borderRadius
        : const BorderRadius.all(Radius.circular(8));
    return Padding(
      padding: EdgeInsets.only(
        left: fieldRadius.topLeft.x / 2,
        right: fieldRadius.topRight.x / 2,
        bottom: 4.0,
      ),
      child: Text.rich(
        TextSpan(
          style: theme.textTheme.titleSmall,
          children: [
            if (field.title.isNotEmpty) TextSpan(text: field.title),
            if (isRequired)
              TextSpan(
                text: '${field.title.isNotEmpty ? ' ' : ''}*',
                style: TextStyle(color: theme.colorScheme.error),
              ),
          ],
        ),
      ),
    );
  }

  Widget? buildDescriptionView(BuildContext context) {
    if (field.description.isEmpty) return null;
    final inputBorderRadius =
        (theme.inputDecorationTheme.border is OutlineInputBorder)
        ? (theme.inputDecorationTheme.border as OutlineInputBorder).borderRadius
        : const BorderRadius.all(Radius.circular(4));
    return Padding(
      padding: EdgeInsets.only(
        top: 8,
        left: inputBorderRadius.bottomLeft.x / 2,
        right: inputBorderRadius.bottomLeft.x / 2,
      ),
      child: CustomHtml(
        data: field.description!,
        style: theme.textTheme.bodyMedium
            ?.copyWith(color: theme.colorScheme.outline)
            .asHtmlStyle,
      ),
    );
  }

  Widget? buildErrorManuallyView(BuildContext context) {
    if (!handleControllerErrorManually || !controller.hasError) return null;
    final inputBorderRadius =
        (theme.inputDecorationTheme.border is OutlineInputBorder)
        ? (theme.inputDecorationTheme.border as OutlineInputBorder).borderRadius
        : const BorderRadius.all(Radius.circular(4));
    return Padding(
      padding: EdgeInsets.only(
        left: inputBorderRadius.bottomLeft.x / 2,
        right: inputBorderRadius.bottomLeft.x / 2,
        top: 4.0,
      ),
      child: Text(
        '${controller.error}',
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.error,
        ),
      ),
    );
  }

  EdgeInsetsGeometry get defaultPadding => const EdgeInsets.only(bottom: 24.0);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    theme = Theme.of(context);
    final titleView = buildTitleView(context);
    final descriptionView = buildDescriptionView(context);
    final errorManuallyView = buildErrorManuallyView(context);
    if (isHidden) return const SizedBox.shrink();
    final view = AnimatedSize(
      duration: const Duration(milliseconds: 300),
      child: ClipRect(
        clipBehavior: Clip.hardEdge,
        child: SizedBox(
          height: isVisibleFromDependencies ? null : 0,
          child: SizeRenderer(
            onSizeRendered: onSizeRendered,
            child: Padding(
              padding: defaultPadding,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (titleView != null) titleView,
                  buildBody(context),
                  if (descriptionView != null) descriptionView,
                  if (errorManuallyView != null) errorManuallyView,
                ],
              ),
            ),
          ),
        ),
      ),
    );
    return isReadOnly ? IgnorePointer(ignoring: true, child: view) : view;
  }

  void onSizeRendered(Size size, GlobalKey key) {
    controller.size = size;
    controller.key = key;
  }

  @override
  void dispose() {
    controller.removeListener(onControllerErrorChanged);
    dependsOnController?.dispose();
    super.dispose();
  }
}
