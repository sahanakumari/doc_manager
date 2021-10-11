import 'package:doc_manager/utils/app_styles.dart';
import 'package:flutter/material.dart';

class STextButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;

  const STextButton({Key? key, required this.child, this.onPressed})
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

class SElevatedButton extends StatelessWidget {
  final Widget child;
  final bool isSecondary;
  final VoidCallback? onPressed;

  const SElevatedButton(
      {Key? key, required this.child, this.onPressed, this.isSecondary = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: isSecondary
            ? Theme.of(context).hintColor
            : Theme.of(context).buttonTheme.colorScheme!.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.kRadius),
        ),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
