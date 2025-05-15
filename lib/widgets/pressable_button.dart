import 'package:flutter/material.dart';

class PressableButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? pressedColor;
  final Color? borderColor;
  final List<BoxShadow>? boxShadow;

  const PressableButton({
    super.key,
    required this.child,
    this.onTap,
    this.borderRadius,
    this.padding,
    this.backgroundColor,
    this.pressedColor,
    this.borderColor,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: boxShadow,
      ),
      child: Material(
        color: backgroundColor,
        borderRadius: borderRadius,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius,
          splashColor: pressedColor?.withOpacity(0.3),
          highlightColor: pressedColor?.withOpacity(0.2),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              border: Border.all(
                color: borderColor ?? Colors.transparent,
                width: 1,
              ),
              borderRadius: borderRadius,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
