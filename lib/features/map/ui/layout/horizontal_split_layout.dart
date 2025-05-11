import 'package:flutter/material.dart';

class HorizontalSplitLayout extends StatefulWidget {
  final Widget top;
  final Widget bottom;
  final double totalHeight;
  final double ratio;

  const HorizontalSplitLayout({
    super.key,
    required this.top,
    required this.bottom,
    required this.totalHeight,
    this.ratio = 0.5,
  }) : assert(ratio >= 0),
       assert(ratio <= 1);

  @override
  State<HorizontalSplitLayout> createState() => HorizontalSplitLayoutState();
}

class HorizontalSplitLayoutState extends State<HorizontalSplitLayout>
    with SingleTickerProviderStateMixin {
  final _dividerHeight = 16.0;
  late AnimationController _animationController;
  late Animation<double> _animation;
  double _ratio = 0.5;
  double _maxHeight = 0.0;
  bool _isAnimate = false;

  get _height1 => _ratio * _maxHeight;
  get _height2 => (1 - _ratio) * _maxHeight;

  void expandTopView() {
    if (_ratio < 0.4) {
      _snapToPosition(0.4);
    }
  }

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

  void _snapToPosition(double targetRatio) {
    if (_isAnimate) return;

    _isAnimate = true;
    _animation = Tween<double>(begin: _ratio, end: targetRatio).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.reset();
    _animationController.forward();
  }

  void _checkForSnap() {
    if (_height1 / widget.totalHeight * 100 < 17) {
      _snapToPosition(0.0);
    }
    if (_height2 / widget.totalHeight * 100 < 17) {
      _snapToPosition(1.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, BoxConstraints constraints) {
        assert(_ratio <= 1);
        assert(_ratio >= 0);
        if (_maxHeight != constraints.maxHeight) {
          _maxHeight = constraints.maxHeight - _dividerHeight;
        }

        return SizedBox(
          height: constraints.maxHeight,
          child: Column(
            children: <Widget>[
              SizedBox(height: _height1, child: widget.top),
              MouseRegion(
                cursor: SystemMouseCursors.resizeUpDown,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  child: SizedBox(
                    height: _dividerHeight,
                    width: constraints.maxWidth,
                    child: const Icon(Icons.drag_handle),
                  ),
                  onPanUpdate: (DragUpdateDetails details) {
                    if (_isAnimate) return;

                    setState(() {
                      _ratio += details.delta.dy / _maxHeight;
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
              SizedBox(height: _height2, child: widget.bottom),
            ],
          ),
        );
      },
    );
  }
}
