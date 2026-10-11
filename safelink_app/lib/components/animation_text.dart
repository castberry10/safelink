import 'package:flutter/material.dart';

class DelayedSlideText extends StatefulWidget {
  final String text;
  final double size;
  final Color color;
  final bool isBorder;
  final Duration delay;
  final TextAlign textAlign;
  const DelayedSlideText({
    super.key,
    required this.text,
    required this.delay,
    required this.size,
    required this.color,
    this.isBorder = true,
    this.textAlign = TextAlign.center,
  });

  @override
  State<DelayedSlideText> createState() => _DelayedSlideTextState();
}

class _DelayedSlideTextState extends State<DelayedSlideText> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.delay, () {
      if (mounted) setState(() => _visible = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _visible
        ? TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0), // 0=fully transparent, 1=fully opaque
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOut,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, (1 - value) * 30), // slide from bottom to top (~30px)
                  child: child,
                ),
              );
            },
            child: Text(
              widget.text,
              style: TextStyle(
                fontWeight:
                    widget.isBorder ? FontWeight.bold : FontWeight.normal,
                fontSize: widget.size,
                color: widget.color,
              ),
            ),
          )
        : Text(
            widget.text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: widget.size,
              color: Colors.white.withValues(alpha: 0),
            ),
          );
  }
}