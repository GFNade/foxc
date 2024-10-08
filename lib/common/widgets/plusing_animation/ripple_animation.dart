import 'package:flutter/material.dart';
import 'package:untitled/utilities/const.dart';

import 'circle_painter.dart';

class RipplesAnimation extends StatefulWidget {
  const RipplesAnimation({
    super.key,
    this.size = 100.0,
    required this.onPressed,
    required this.child,
  });

  final double size;
  final Widget child;
  final VoidCallback onPressed;

  @override
  State<RipplesAnimation> createState() => _RipplesAnimationState();
}

class _RipplesAnimationState extends State<RipplesAnimation>
    with TickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Widget _button() {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.size),
        child: widget.child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomPaint(
        painter: CirclePainter(
          _controller!,
          color: cPulsing,
        ),
        child: SizedBox(
          width: widget.size * 3.5,
          height: widget.size * 3.5,
          child: _button(),
        ),
      ),
    );
  }
}
