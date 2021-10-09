import 'package:flutter/material.dart';

class RTextButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;

  const RTextButton({Key? key, required this.child, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        primary: Theme.of(context).iconTheme.color,
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
