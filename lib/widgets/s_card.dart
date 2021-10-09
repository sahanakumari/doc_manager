import 'package:doc_manager/utils/app_styles.dart';
import 'package:flutter/material.dart';

class SCard extends StatelessWidget {
  final EdgeInsets? margin;
  final Widget? child;
  final Color? color;

  const SCard({Key? key, this.margin, this.child, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.zero,
      decoration: BoxDecoration(
        color: color ??
            (Theme.of(context).brightness == Brightness.dark
                ? Theme.of(context).canvasColor
                : Theme.of(context).canvasColor.withOpacity(0.8)),
        boxShadow: [
          BoxShadow(
              color: Theme.of(context).dividerColor.withOpacity(0.3),
              blurRadius: 5),
        ],
        borderRadius: BorderRadius.circular(AppTheme.kRadius),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppTheme.kRadius),
        clipBehavior: Clip.hardEdge,
        child: child,
      ),
    );
  }
}
