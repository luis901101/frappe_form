import 'package:flutter/widgets.dart';
import 'package:flutter/scheduler.dart';

class SizeRenderer extends StatefulWidget {
  final Function(Size size, GlobalKey key) onSizeRendered;
  final bool listenContinuously;
  final Widget child;

  const SizeRenderer({
    super.key,
    required this.onSizeRendered,
    this.listenContinuously = false,
    required this.child,
  });

  @override
  State createState() => _SizeRendererState();
}

class _SizeRendererState extends State<SizeRenderer> {
  final key = GlobalKey();
  Size currentSize = Size.zero;

  @override
  void initState() {
    super.initState();
    if (!widget.listenContinuously) {
      SchedulerBinding.instance.addPostFrameCallback(onCreated);
    }
  }

  void onCreated(Duration timeStamp) {
    var context = key.currentContext;
    if (context == null) return;

    var newSize = context.size;
    if (newSize == null || currentSize == newSize) return;

    currentSize = newSize;
    widget.onSizeRendered(newSize, key);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.listenContinuously) {
      SchedulerBinding.instance.addPostFrameCallback(onCreated);
    }
    return SizedBox(key: key, child: widget.child);
  }
}
