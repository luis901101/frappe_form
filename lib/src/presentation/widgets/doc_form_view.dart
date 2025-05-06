import 'package:frappe_form/frappe_form.dart';
import 'package:flutter/material.dart';

/// Created by luis901101 on 04/21/25.
class DocFormView extends StatefulWidget {
  /// The DocForm definition.
  final DocForm form;

  /// Get the FormResponse once the user taps on Submit button.
  final ValueChanged<Map<String, dynamic>> onSubmit;

  /// Necessary callback when Form has fields of type = `attachment`
  /// so the logic of loading an Attachment is handled outside of the logic
  /// of DocFormView
  final Future<Attachment?> Function()? onAttachmentLoaded;

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
    required this.onSubmit,
    this.controller,
    this.onAttachmentLoaded,
    this.isLoading = false,
    this.defaultLocalization,
    this.localizations,
    this.locale,
  });

  @override
  State createState() => DocFormViewState();
}

class DocFormViewState extends State<DocFormView>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  late final DocFormController controller;
  static const fabSize = kFloatingActionButtonMargin + 56;
  ScrollController? scrollController;
  bool isKeyboardVisible = false;
  bool scrollReachedBottom = false;
  late final TabController tabController;
  int tabsCount = 0;
  final showFAB = ValueNotifier<bool>(false);
  DocForm get form => widget.form;
  List<DocField> get formFields => form.fields;

  late final double bottomPadding;
  List<DocFieldBundle> fieldBundles = [];

  bool _isLoading = true;

  void loading(bool value) {
    if (_isLoading != value) setState(() => _isLoading = value);
  }

  bool get isLoading => widget.isLoading || _isLoading;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? DocFormController();
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
      checkScrollOnInit();
    }
  }

  void onCreated(_) {
    if (!widget.isLoading && scrollController == null) {
      scrollController = PrimaryScrollController.of(context);
      scrollController?.addListener(onScrollListener);
    }
    checkScrollOnInit();
  }

  void checkScrollOnInit() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (scrollController?.hasClients ?? false) {
        onScrollListener();
      }
    });
  }

  void onScrollListener() {
    if (scrollController!.hasClients &&
        scrollController!.position.pixels >=
            scrollController!.position.maxScrollExtent - fabSize) {
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

  Future<void> buildFormFields() async {
    fieldBundles = controller.buildFormFields(form,
        onAttachmentLoaded: widget.onAttachmentLoaded);
    tabsCount = fieldBundles.length;
    tabController = TabController(
      vsync: this,
      length: tabsCount,
      initialIndex: 0,
    );
    loading(false);
  }

  int get listViewCount =>
      fieldBundles.length + (form.title.isNotEmpty ? 1 : 0);

  List<Widget> get tabViews => fieldBundles.map(tabView).toList();
  Widget tabView(DocFieldBundle fieldBundle) =>
      Tab(text: fieldBundle.field.title);
  void onTabTap(int index) {
    if (index == tabController.index) {
      PrimaryScrollController.of(context).animateTo(
        0,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: form.title.isEmpty ? null : Text(form.title),
        bottom: tabsCount < 2
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
        child: SizedBox(
          width: 200,
          key: ValueKey('showFAB: ${showFAB.value}'),
          child: Padding(
            padding: EdgeInsets.only(bottom: bottomPadding > 0 ? 0 : 16),
            child: FloatingActionButton.extended(
              shape: const StadiumBorder(),
              onPressed: isLoading ? null : onSubmit,
              label: Text(DocFormLocalization.instance.localization.btnSubmit),
            ),
          ),
        ),
      ),
      body: UnfocusView(
        child: buildBody,
      ),
      // body: UnfocusView(
      //   child: isLoading
      //       ? const Padding(
      //           padding: EdgeInsets.all(16),
      //           child: DocFormLoadingView(),
      //         )
      //       : Scrollbar(
      //           child: ListView.builder(
      //               primary: true,
      //               addAutomaticKeepAlives: true,
      //               padding: const EdgeInsets.only(
      //                   top: 16, left: 16, right: 16, bottom: fabSize + 64),
      //               shrinkWrap: true,
      //               keyboardDismissBehavior:
      //                   ScrollViewKeyboardDismissBehavior.onDrag,
      //               itemBuilder: (context, index) {
      //                 if (index == 0 && form.title.isNotEmpty) {
      //                   return Padding(
      //                     padding: const EdgeInsets.only(
      //                       bottom: 24.0,
      //                     ),
      //                     child: Text(
      //                       form.title,
      //                       style: theme.textTheme.titleLarge
      //                           ?.copyWith(color: theme.colorScheme.primary),
      //                       textAlign: TextAlign.center,
      //                     ),
      //                   );
      //                 }
      //                 return fieldBundles[
      //                         index - (form.title.isNotEmpty ? 1 : 0)]
      //                     .view;
      //               },
      //               // separatorBuilder: (context, index) =>
      //               //     const SizedBox(height: 24.0),
      //               itemCount: listViewCount),
      //         ),
      // ),
    );
  }

  List<Widget> get tabContentViews => fieldBundles.map(tabContentView).toList();
  Widget tabContentView(DocFieldBundle fieldBundle) {
    return Scrollbar(
      child: ListView.builder(
        primary: true,
        addAutomaticKeepAlives: true,
        padding: const EdgeInsets.only(
            top: 16, left: 16, right: 16, bottom: fabSize + 64),
        // shrinkWrap: true,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        itemBuilder: (context, index) {
          return fieldBundle.children?[index].view;
        },
        // separatorBuilder: (context, index) =>
        //     const SizedBox(height: 24.0),
        itemCount: fieldBundle.children?.length,
      ),
    );
  }

  Widget get buildBody {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: DocFormLoadingView(),
      );
    }
    switch (tabsCount) {
      case 0:
        return Center(
          child: Text('No form available'),
        );
      default:
        return TabBarView(
          controller: tabController,
          children: tabContentViews,
        );
    }
  }

  bool validate() {
    setState(() {});
    final validation = validateRecursive(fieldBundles: fieldBundles);
    if (!validation.isValid) {
      setState(() {});
      scrollToField(
          controller: validation.controller, indexOffset: validation.offset);
    }
    return validation.isValid;
  }

  ({bool isValid, double offset, FieldController? controller})
      validateRecursive({
    required List<DocFieldBundle> fieldBundles,
  }) {
    bool isValid = true;
    FieldController? controller;
    double tempOffset = 0;
    double indexOffset = 0;
    for (final fieldBundle in fieldBundles) {
      if (!fieldBundle.field.isGroupType) {
        if (!fieldBundle.controller.validate() && isValid) {
          isValid = false;
          indexOffset = tempOffset;
          controller = fieldBundle.controller;
        }
        tempOffset += fieldBundle.controller.size.height;
      }
      if (fieldBundle.children.isNotEmpty) {
        final result = validateRecursive(fieldBundles: fieldBundle.children!);
        if (!result.isValid && isValid) {
          isValid = false;
          indexOffset += result.offset;
          controller = result.controller;
        }
      }
    }
    return (isValid: isValid, offset: indexOffset, controller: controller);
  }

  Future<void> scrollToField(
      {required FieldController? controller,
      required double indexOffset}) async {
    if (controller == null) return;
    scrollController?.animateTo(indexOffset,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
    Future.delayed(const Duration(milliseconds: 200), () {
      final fieldContext = controller.key.currentContext;
      if (fieldContext == null || !fieldContext.mounted) return;
      Scrollable.ensureVisible(fieldContext,
          duration: const Duration(milliseconds: 100), curve: Curves.ease);
    }).whenComplete(() => Future.delayed(const Duration(milliseconds: 100),
        () => controller.focusNode?.requestFocus()));
  }

  void onSubmit() {
    if (validate()) {
      final formResponse =
          controller.generateResponse(form: form, itemBundles: fieldBundles);
      widget.onSubmit(formResponse);
    }
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

  @override
  void dispose() {
    showFAB.dispose();
    WidgetsBinding.instance.removeObserver(this);
    scrollController?.removeListener(onScrollListener);
    for (final item in fieldBundles) {
      item.controller.focusNode?.dispose();
    }
    super.dispose();
  }
}
