import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled/utilities/const.dart';

class DoubleClickLikeAnimator extends StatefulWidget {
  final Widget child;
  final Function() onAnimation;
  final Function() onTap;

  const DoubleClickLikeAnimator({super.key, required this.child, required this.onAnimation, required this.onTap});

  @override
  State<DoubleClickLikeAnimator> createState() => _DoubleClickLikeAnimatorState();
}

class _DoubleClickLikeAnimatorState extends State<DoubleClickLikeAnimator> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scale;
  bool isAnimating = false;

  @override
  void initState() {
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    scale = Tween<double>(begin: 1, end: 1.2).animate(controller);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () async {
        setState(() {
          isAnimating = true;
        });

        if (isAnimating) {
          HapticFeedback.lightImpact();
          await controller.forward();
          await controller.reverse();
          widget.onAnimation();
          await Future.delayed(const Duration(milliseconds: 400));

          setState(() {
            isAnimating = false;
          });
        }
      },
      onTap: () {
        widget.onTap();
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          widget.child,
          ScaleTransition(
            scale: scale,
            child: Opacity(
              opacity: isAnimating ? 1 : 0,
              child: Icon(
                shadows: [Shadow(color: cBlack.withOpacity(0.1), blurRadius: 10)],
                Icons.favorite_rounded,
                color: cWhite,
                size: 100,
              ),
            ),
          )
        ],
      ),
    );
  }
}
