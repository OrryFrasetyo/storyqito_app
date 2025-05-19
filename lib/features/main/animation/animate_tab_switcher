import 'package:flutter/material.dart';

class AnimateTabSwitcher extends StatefulWidget {
  final int index;
  final List<Widget> children;

  const AnimateTabSwitcher({
    super.key,
    required this.index,
    required this.children,
  });

  @override
  State<AnimateTabSwitcher> createState() => _AnimateTabSwitcherState();
}

class _AnimateTabSwitcherState extends State<AnimateTabSwitcher> {
  int _oldIndex = 0;

  @override
  void didUpdateWidget(covariant AnimateTabSwitcher oldWidget) {
    if (widget.index != oldWidget.index) {
      _oldIndex = oldWidget.index;
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(widget.children.length, (i) {
        final isActive = i == widget.index;
        final isOld = i == _oldIndex;

        return AnimatedOpacity(
          duration: const Duration(milliseconds: 700),
          opacity: isActive ? 1.0 : 0.0,
          child: IgnorePointer(ignoring: !isActive, child: widget.children[i]),
        );
      }),
    );
  }
}
