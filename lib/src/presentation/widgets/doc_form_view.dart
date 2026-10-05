import 'dart:async';

import 'package:collection/collection.dart';
import 'package:frappe_form/frappe_form.dart';
import 'package:material_ui/material_ui.dart';

/// Created by luis901101 on 04/21/25.
class DocFormView extends StatefulWidget {
  /// The DocForm definition.
  final DocForm form;

  /// Callback when the user wants to submit Form.
  /// Return true to proceed with the submission, false otherwise.
  final Future<bool> Function()? onSubmit;

  /// Callback when the user wants to cancel the submission of the Form.
  /// Return true to allow the cancellation, false otherwise.
  final Future<bool> Function()? onCancel;

  /// Get the FormResponse after user taps on Submit button and all Form fields
  /// has been processed.
  final ValueChanged<Map<String, dynamic>>? onResponse;

  /// Necessary callback when Form has fields of type = `attachment`
  /// so the logic of loading an Attachment is handled outside of the logic
  /// of DocFormView
  final Future<Attachment?> Function()? onAttachmentLoaded;

  /// To add custom actions to the AppBar.
  final List<Widget>? actions;

  /// To indicate there is an ongoing loading process
  final bool isLoading;

  /// Indicates what should be the fallback localization if loalce is not
  /// supported.
  /// Defaults to English
  final DocFormBaseLocalization? defaultLocalization;

  /// Indicates the definition of extra supported localizations.
  /// By default Spanish and English are supported, but you can set
  /// other localizations on this List to be considered.
  final List<DocFormBaseLocalization>? localizations;

  /// The expected locale to show, by default Platform locale is used.
  final Locale? locale;

  /// The DocFormController to use for item view and response generation.
  final DocFormController? controller;
  const DocFormView({
    super.key,
    required this.form,
    this.onSubmit,
    this.onCancel,
    this.onResponse,
    this.controller,
    this.onAttachmentLoaded,
    this.actions,
    this.isLoading = false,
    this.defaultLocalization,
    this.localizations,
    this.locale,
  });

  @override
  State createState() => DocFormViewState();
}

class DocFormViewState extends State<DocFormView>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late final DocFormController controller;
  static const fabSize = kFloatingActionButtonMargin + 56;
  ThemeData theme = ThemeData();
  List<ScrollController> scrollControllers = [];
  bool isKeyboardVisible = false;
  bool scrollReachedBottom = false;
  late TabController tabController;
  ValueNotifier<int> tabIndex = ValueNotifier<int>(0);
  int tabsCount = 0;
  final showFAB = ValueNotifier<bool>(false);
  DocForm get form => widget.form;
  List<DocField> get formFields => form.fields;

  late final double bottomPadding;
  List<DocFieldBundle> fieldBundles = [];

  bool loading = true;
  bool offstage = false;

  void setLoading(bool value, {bool offstage = false}) {
    if (loading != value || this.offstage != offstage) {
      loading = value;
      this.offstage = offstage;
      setState(() {});
    }
  }

  bool get isLoading => widget.isLoading || loading;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? DocFormController();
    tabController = TabController(vsync: this, length: 0, initialIndex: 0);
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback(onCreated);
    bottomPadding = FlutterViewUtils.get().padding.bottom;
    if (!widget.isLoading) {
      Locale? locale;
      try {
        locale =
            widget.locale ?? FlutterViewUtils.get().platformDispatcher.locale;
      } catch (_) {}
      DocFormLocalization.instance.init(
        defaultLocalization: widget.defaultLocalization,
        localizations: widget.localizations,
        locale: locale,
      );
      buildFormFields();
    }
  }

  void onCreated(Duration timeStamp) {
    checkScrollOnInit();
  }

  void checkScrollOnInit() {
    if (loading) return;
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (scrollController.hasClients) {
        onScrollListener();
      }
    });
  }

  void onScrollListener() {
    if (scrollController.hasClients &&
        scrollController.offset >=
            scrollController.position.maxScrollExtent - fabSize) {
      if (!scrollReachedBottom) {
        scrollReachedBottom = true;
        updateFABVisibility();
      }
    } else {
      if (scrollReachedBottom) {
        scrollReachedBottom = false;
        updateFABVisibility();
      }
    }
  }

  void onTabScrollListener() {
    if (tabIndex.value != tabController.index) {
      tabIndex.value = tabController.index;
    }
  }

  Future<void> buildFormFields() async {
    fieldBundles = await controller.buildFormFields(
      form,
      onAttachmentLoaded: widget.onAttachmentLoaded,
    );
    tabsCount = fieldBundles.length;
    tabController = TabController(
      vsync: this,
      length: tabsCount,
      initialIndex: tabIndex.value,
    );
    tabController.addListener(onTabScrollListener);
    clearScrollControllers();
    scrollControllers = List.generate(
      tabController.length,
      (index) => ScrollController()..addListener(onScrollListener),
    );
    setLoading(false, offstage: tabsCount > 1);
    renderAllTabs();
    checkScrollOnInit();
  }

  void clearScrollControllers() {
    for (final controller in scrollControllers) {
      controller.dispose();
    }
    scrollControllers.clear();
  }

  ScrollController get scrollController {
    if (tabController.index < scrollControllers.length) {
      return scrollControllers[tabController.index];
    }
    return ScrollController();
  }

  // This is a workaround to make sure all Tabs are built so all fields evaluate
  // their controllers validations which are necessary for required fields on
  // other tabs than the current one.
  Future<void> renderAllTabs() async {
    if (tabsCount < 2) return;
    for (int i = 0; i < tabsCount; ++i) {
      tabController.animateTo(i);
      await Future.delayed(const Duration(milliseconds: 100));
    }
    tabController.animateTo(0);
    setLoading(false, offstage: false);
  }

  int get listViewCount =>
      fieldBundles.length + (form.title.isNotEmpty ? 1 : 0);

  List<Widget> get tabViews => fieldBundles.map(tabView).toList();
  Widget tabView(DocFieldBundle fieldBundle) =>
      Tab(text: fieldBundle.field.title);
  void onTabTap(int index) {
    if (index == tabIndex.value) {
      // This delay here is to ensure the current tab has already loaded all content
      // and scrollController is attached to any scroll views.
      Future.delayed(const Duration(milliseconds: 100), () {
        if (scrollController.hasClients) {
          if (scrollController.offset == 0) {
            onScrollListener();
          } else {
            scrollController.animateTo(
              0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, result) {
        if (didPop) return;
        onBackPressed(result: result)
            .then((canPop) {
              if (canPop && context.mounted) {
                Navigator.of(context).pop(result);
              }
            })
            .onError((error, stackTrace) {
              debugPrint('Error: $error');
            });
      },
      child: Scaffold(
        appBar: AppBar(
          title: form.title.isEmpty
              ? null
              : Text(form.title, textAlign: TextAlign.center, maxLines: 2),
          actions: widget.actions,
          bottom: offstage || tabsCount < 2
              ? null
              : TabBar.secondary(
                  controller: tabController,
                  isScrollable: true,
                  tabAlignment: TabAlignment.center,
                  // indicatorWeight: 20,
                  // lineIndicatorWeight: 0,
                  // tabsAlignment: CrossAxisAlignment.center,
                  tabs: tabViews,
                  onTap: onTabTap,
                ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: ValueListenableBuilder(
          valueListenable: showFAB,
          builder: (context, value, child) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: !showFAB.value ? const SizedBox() : child,
            );
          },
          child: Padding(
            padding: EdgeInsets.only(bottom: bottomPadding > 0 ? 0 : 16),
            child: ValueListenableBuilder(
              valueListenable: tabIndex,
              builder: (context, value, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (showNavButtons) ...[
                      backButton,
                      const SizedBox(width: 16),
                    ],
                    submitButton,
                    if (showNavButtons) ...[
                      const SizedBox(width: 16),
                      nextButton,
                    ],
                  ],
                );
              },
            ),
          ),
        ),
        body: UnfocusView(child: buildBody),
      ),
    );
  }

  bool get showSubmitButton => tabController.index == tabController.length - 1;
  bool get canSubmit => !isLoading && widget.onSubmit != null;
  bool get showNavButtons => tabController.length > 1;
  bool get canGoNext => tabController.index < tabController.length - 1;
  bool get canGoBack => tabController.index > 0;

  Widget get submitButton => AnimatedSize(
    duration: const Duration(milliseconds: 300),
    child: SizedBox(
      key: ValueKey('submit-btn-$showSubmitButton'),
      width: showSubmitButton ? 200 : 0,
      height: showSubmitButton ? null : 0,
      child: FloatingActionButton.extended(
        shape: const StadiumBorder(),
        backgroundColor: canSubmit ? null : theme.disabledColor,
        foregroundColor: canSubmit ? null : theme.disabledColor,
        onPressed: canSubmit ? onSubmit : null,
        label: Text(
          showSubmitButton
              ? DocFormLocalization.instance.localization.btnSubmit
              : '',
        ),
      ),
    ),
  );

  Widget get nextButton => AnimatedSwitcher(
    duration: const Duration(milliseconds: 300),
    child: FloatingActionButton(
      key: ValueKey('next-btn-$canGoNext'),
      shape: const StadiumBorder(),
      backgroundColor: canGoNext ? null : theme.disabledColor,
      foregroundColor: canGoNext ? null : theme.disabledColor,
      onPressed: canGoNext ? onNextTab : null,
      child: const Icon(Icons.arrow_forward_ios_rounded),
    ),
  );

  Widget get backButton => AnimatedSwitcher(
    duration: const Duration(milliseconds: 300),
    child: FloatingActionButton(
      key: ValueKey('back-btn-$canGoBack'),
      shape: const StadiumBorder(),
      backgroundColor: canGoBack ? null : theme.disabledColor,
      foregroundColor: canGoBack ? null : theme.disabledColor,
      onPressed: canGoBack ? onPreviousTab : null,
      child: const Icon(Icons.arrow_back_ios_new_rounded),
    ),
  );

  List<Widget> get tabContentViews =>
      fieldBundles.mapIndexed(tabContentView).toList();
  Widget tabContentView(int index, DocFieldBundle fieldBundle) {
    final controller = scrollControllers[index];
    return Scrollbar(
      controller: controller,
      child: ListView.builder(
        controller: controller,
        addAutomaticKeepAlives: true,
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: const EdgeInsets.only(
          top: 16,
          left: 16,
          right: 16,
          bottom: fabSize + 64,
        ),
        // shrinkWrap: true,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        itemBuilder: (context, index) {
          return fieldBundle.children[index].view;
        },
        // separatorBuilder: (context, index) =>
        //     const SizedBox(height: 24.0),
        itemCount: fieldBundle.children.length,
      ),
    );
  }

  Widget get buildBody {
    Widget loadingView = const Padding(
      padding: EdgeInsets.all(16),
      child: DocFormLoadingView(),
    );
    if (isLoading) return loadingView;
    final view = switch (tabsCount) {
      0 => const Center(child: Text('No form available')),
      _ => TabBarView(controller: tabController, children: tabContentViews),
    };

    return offstage
        ? Stack(
            children: [
              // Offstage(child: view),
              loadingView,
            ],
          )
        : view;
  }

  bool validate() {
    setState(() {});
    final validation = validateRecursive(fieldBundles: fieldBundles);
    if (!validation.isValid) {
      setState(() {});
      scrollToField(
        controller: validation.controller,
        indexOffset: validation.offset,
        tabIndex: validation.tabIndex,
      );
    }
    return validation.isValid;
  }

  ({bool isValid, double offset, FieldController? controller, int tabIndex})
  validateRecursive({required List<DocFieldBundle> fieldBundles}) {
    bool isValid = true;
    FieldController? controller;
    double tempOffset = 0;
    double indexOffset = 0;
    int tabIndex = 0;
    for (int i = 0; i < fieldBundles.length; ++i) {
      final fieldBundle = fieldBundles[i];
      if (isValid && fieldBundle.field.type == FieldType.tabBreak) {
        tabIndex = i;
      }
      if (!fieldBundle.controller.validate() && isValid) {
        isValid = false;
        indexOffset = tempOffset;
        controller = fieldBundle.controller;
      }
      tempOffset += fieldBundle.controller.size.height;
      if (fieldBundle.children.isNotEmpty) {
        final result = validateRecursive(fieldBundles: fieldBundle.children);
        if (!result.isValid && isValid) {
          isValid = false;
          indexOffset += result.offset;
          controller = result.controller;
        }
      }
    }
    return (
      isValid: isValid,
      offset: indexOffset,
      controller: controller,
      tabIndex: tabIndex,
    );
  }

  Future<void> scrollToField({
    required FieldController? controller,
    required double indexOffset,
    required int tabIndex,
  }) async {
    if (controller == null) return;
    Duration delay = Duration.zero;
    if (tabIndex != tabController.index) {
      tabController.animateTo(tabIndex);
      delay = const Duration(milliseconds: 300);
    }
    Future.delayed(delay, () {
      scrollController.animateTo(
        indexOffset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }).whenComplete(() {
      Future.delayed(const Duration(milliseconds: 200), () {
        final fieldContext = controller.key.currentContext;
        if (fieldContext == null || !fieldContext.mounted) return;
        Scrollable.ensureVisible(
          fieldContext,
          duration: const Duration(milliseconds: 100),
          curve: Curves.ease,
        );
      }).whenComplete(
        () => Future.delayed(
          const Duration(milliseconds: 100),
          () => controller.focusNode?.requestFocus(),
        ),
      );
    });
  }

  Future<void> onSubmit() async {
    if (validate()) {
      if (!(await widget.onSubmit?.call() ?? false)) return;
      final formResponse = await controller.generateResponse(
        form: form,
        itemBundles: fieldBundles,
      );
      widget.onResponse?.call(formResponse);
    }
  }

  Future<void> onNextTab() async {
    tabController.animateTo(tabController.index + 1);
  }

  Future<void> onPreviousTab() async {
    tabController.animateTo(tabController.index - 1);
  }

  void updateFABVisibility() {
    final temp = !isKeyboardVisible && scrollReachedBottom;
    if (showFAB.value != temp) {
      showFAB.value = temp;
      setState(() {});
    }
  }

  void checkKeyboardVisibility() {
    bool keyboardVisible =
        FlutterViewUtils.get(context: context).viewInsets.bottom > 0.0;
    if (isKeyboardVisible != keyboardVisible) {
      isKeyboardVisible = keyboardVisible;
      updateFABVisibility();
    }
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    checkKeyboardVisibility();
  }

  Future<bool> onBackPressed({dynamic result}) async =>
      (await widget.onCancel?.call()) ?? true;

  @override
  void dispose() {
    showFAB.dispose();
    WidgetsBinding.instance.removeObserver(this);
    clearScrollControllers();
    tabController.dispose();
    for (final item in fieldBundles) {
      item.controller.focusNode?.dispose();
    }
    super.dispose();
  }
}
