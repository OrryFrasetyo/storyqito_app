import 'package:flutter/material.dart';

class VerticalSplitLayout extends StatefulWidget {
  final Widget left;
  final Widget right;
  final double snapThreshold;
  final double ratio;

  const VerticalSplitLayout({
    super.key,
    required this.left,
    required this.right,
    this.ratio = 0.5,
    this.snapThreshold = 170.0,
  }) : assert(ratio >= 0),
       assert(ratio <= 1);

  @override
  State<VerticalSplitLayout> createState() => _VerticalSplitLayoutState();
}

class _VerticalSplitLayoutState extends State<VerticalSplitLayout>
    with SingleTickerProviderStateMixin {
  final _dividerWidth = 16.0;
  late AnimationController _animationController;
  late Animation<double> _animation;
  double _ratio = 0.5;
  double _maxWidth = 0.0;
  bool _isAnimate = false;

  get _width1 => _ratio * _maxWidth;
  get _width2 => (1 - _ratio) * _maxWidth;

  @override
  void initState() {
    super.initState();
    _ratio = widget.ratio;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    _animationController.addListener(() {
      setState(() {
        _ratio = _animation.value;
      });
    });

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _isAnimate = false;
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _snapToClose() {
    if (_isAnimate) return;

    _isAnimate = true;
    _animation = Tween<double>(begin: _ratio, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.reset();
    _animationController.forward();
  }

  void _checkForSnap() {
    if (_width1 < widget.snapThreshold && _width1 > 0) {
      _snapToClose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, BoxConstraints constraints) {
        assert(_ratio <= 1);
        assert(_ratio >= 0);
        if (_maxWidth != constraints.maxWidth) {
          _maxWidth = constraints.maxWidth - _dividerWidth;
        }

        return SizedBox(
          width: constraints.maxWidth,
          child: Row(
            children: <Widget>[
              SizedBox(width: _width1, child: widget.left),
              MouseRegion(
                cursor: SystemMouseCursors.resizeLeftRight,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  child: SizedBox(
                    width: _dividerWidth,
                    height: constraints.maxHeight,
                    child: const RotationTransition(
                      turns: AlwaysStoppedAnimation(0.25),
                      child: Icon(Icons.drag_handle),
                    ),
                  ),
                  onPanUpdate: (DragUpdateDetails details) {
                    if (_isAnimate) return;

                    setState(() {
                      _ratio += details.delta.dx / _maxWidth;
                      if (_ratio > 1) {
                        _ratio = 1;
                      } else if (_ratio < 0.0) {
                        _ratio = 0.0;
                      }
                    });
                  },
                  onPanEnd: (DragEndDetails details) {
                    _checkForSnap();
                  },
                ),
              ),
              SizedBox(width: _width2, child: widget.right),
            ],
          ),
        );
      },
    );
  }
}
