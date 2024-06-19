import 'package:flutter/material.dart';
import 'package:mobile_auth/ui/util/extensions.dart';

class GeneralButton extends StatelessWidget {
  const GeneralButton({
    super.key,
    required this.color,
    required this.child,
    required this.onClick,
    this.width,
  });

  final Color color;
  final Widget child;
  final double? width;
  final GestureTapCallback onClick;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onClick,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(color),
        fixedSize: WidgetStateProperty.all(Size(width ?? context.width, 60)),
        shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))),
      ),
      child: child,
    );
  }
}
