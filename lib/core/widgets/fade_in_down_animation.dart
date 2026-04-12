import 'package:flutter/material.dart';

class FadeInDownAnimation extends StatefulWidget {
  const FadeInDownAnimation({
    super.key,
    this.duration = const Duration(seconds: 1),
    required this.child,
  });
  final Duration duration;
  final Widget child;
  @override
  State<FadeInDownAnimation> createState() => _FadeInDownAnimationState();
}

class _FadeInDownAnimationState extends State<FadeInDownAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _fadeAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _slideAnimation = Tween(
      begin: Offset(0, -.13),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(opacity: _fadeAnimation, child: widget.child),
    );
  }
}
