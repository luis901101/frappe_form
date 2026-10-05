import 'package:frappe_form/frappe_form.dart';
import 'package:material_ui/material_ui.dart';

/// Created by luis901101 on 07/10/25.
class DocFieldTableView extends DocFieldView {
  DocFieldTableView({
    super.key,
    required super.field,
    super.children,
    super.childrenBundles,
    super.dependsOnController,
  }) : super(controller: CustomTextEditingController());

  @override
  State createState() => DocFieldTableViewState();
}

class DocFieldTableViewState<SF extends DocFieldTableView>
    extends DocFieldViewState<SF> {
  @override
  CustomTextEditingController get controller =>
      super.controller as CustomTextEditingController;

  late final DocFormController docFormController;
  late final PageController pageController;
  final pageIndexNotifier = ValueNotifier<int>(0);
  double pageViewSize = 0;
  double removeButtonOffset = 16.0;

  @override
  void initState() {
    super.initState();
    initFormController();
    pageController = PageController(initialPage: pageIndexNotifier.value);
  }

  void initFormController() {
    docFormController = DocFormController();
  }

  void onMediaPageChanged(int index) {
    pageIndexNotifier.value = index;
  }

  Widget? pageItemView(BuildContext context, int index) {
    final childView = childrenBundles[index].view;
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(top: removeButtonOffset),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Center(child: childView),
            ),
          ),
        ),
        Positioned(right: 0, top: 0, child: removeButton(index)),
      ],
    );
  }

  Widget get pageView => PageView.builder(
    key: ValueKey('pageView-${childrenBundles.length}'),
    controller: pageController,
    onPageChanged: onMediaPageChanged,
    padEnds: true,
    itemCount: childrenBundles.length,
    itemBuilder: pageItemView,
  );

  Widget get pageViewContainer {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (pageViewSize == 0)
          Offstage(
            child: SizeRenderer(
              onSizeRendered: onPageViewChildSizeRendered,
              child: childrenBundles.firstOrNull?.view ?? const SizedBox(),
            ),
          ),
        if (pageViewSize > 0) ...[
          SizedBox(height: pageViewSize, child: pageView),
          pageIndicatorView,
        ],
      ],
    );
  }

  Widget get pageIndicatorView => Padding(
    padding: const EdgeInsets.only(bottom: 16.0),
    child: ValueListenableBuilder(
      valueListenable: pageIndexNotifier,
      builder: (context, value, child) =>
          Text('${pageIndexNotifier.value + 1} / ${childrenBundles.length}'),
    ),
  );

  Widget removeButton(int index) => Material(
    shape: const CircleBorder(),
    color: theme.colorScheme.error,
    clipBehavior: Clip.hardEdge,
    child: InkWell(
      onTap: () => onRemove(index),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(Icons.delete, color: theme.colorScheme.onError),
      ),
    ),
  );

  Widget get addButton => Center(
    child: FloatingActionButton(
      heroTag: null,
      onPressed: onAdd,
      child: const Icon(Icons.add),
    ),
  );

  @override
  Widget buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        children: [
          if (childrenBundles.isNotEmpty) pageViewContainer,
          if (field.childForm != null) addButton,
        ],
      ),
    );
  }

  void onPageViewChildSizeRendered(Size size, GlobalKey key) {
    if (pageViewSize == 0) {
      setState(() => pageViewSize = size.height + removeButtonOffset);
    }
  }

  Future<void> onRemove(int index) async {
    if (index >= 0 && index < childrenBundles.length) {
      if (pageIndexNotifier.value > 0 &&
          pageIndexNotifier.value == childrenBundles.length - 1) {
        --pageIndexNotifier.value;
      }
      childrenBundles.removeAt(index);
      setState(() {});
      animateToPage(pageIndexNotifier.value);
      // Update the controller text value to comply with controller validation if field is required
      int value = (int.tryParse(controller.text) ?? 0) - 1;
      controller.text = '${value > 0 ? value : ''}';
    }
  }

  Future<void> onAdd() async {
    // Get all the children from the child table as DocFieldBundle
    List<DocFieldBundle> childrenFieldBundles = await docFormController
        .buildFormFields(field.childForm ?? DocForm());

    // Get the first child bundle if exists, a Child Table must only have one Parent Group which must be a Tab Break
    final DocFieldBundle? parentChildBundle = childrenFieldBundles.firstOrNull;

    // Get the children of the parent bundle, we ignore the parent bundle itself, because we only want the children, so no Tabs will be rendered here.
    final List<DocFieldBundle> childrenOfParentBundle =
        parentChildBundle?.children ?? [];

    if (childrenOfParentBundle.isNotEmpty) {
      childrenBundles.addAll(childrenOfParentBundle);
      setState(() {});
      // Scroll to the last item added
      animateToPage(childrenBundles.length - 1);
      // Update the controller text value to comply with controller validation if field is required
      controller.text = '${(int.tryParse(controller.text) ?? 0) + 1}';
    }
  }

  void animateToPage(int index) {
    if (index >= 0 && index < childrenBundles.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (pageController.hasClients) {
          pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }
}
