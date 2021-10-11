import 'package:doc_manager/utils/app_styles.dart';
import 'package:doc_manager/utils/extensions.dart';
import 'package:doc_manager/widgets/s_buttons.dart';
import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

class ErrorContainer extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final VoidCallback? onRetryTap;
  final Widget? icon;
  final String? buttonText;
  final IconData? buttonIcon;
  final Alignment alignment;

  const ErrorContainer(
      {Key? key,
      this.title,
      this.subtitle,
      this.onRetryTap,
      this.icon,
      this.buttonText = "tryAgain",
      this.buttonIcon,
      this.alignment = Alignment.center})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          icon ?? SizedBox.shrink(),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
            child: Text(
              title ?? "somethingNotRight".toUpperCase(),
              textScaleFactor: 1.5,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.color
                    ?.withOpacity(0.8),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
            child: Text(
              subtitle ?? "pleaseTryReload",
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.color
                    ?.withOpacity(0.5),
              ),
            ),
          ),
          onRetryTap == null
              ? const SizedBox.shrink()
              : Center(
                  child: SElevatedButton(
                    onPressed: onRetryTap,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(width: 10),
                        Icon(
                          buttonIcon ?? Icons.refresh,
                          size: 20,
                        ),
                        SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            "$buttonText".tr(context).toUpperCase(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ),
                )
        ],
      ),
    );
  }
}

class RatingBar extends StatelessWidget {
  final num rating;
  final double size;
  final Color color;

  const RatingBar({
    Key? key,
    required this.rating,
    this.size = 16.0,
    this.color = Colors.orange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var stars = <Widget>[];
    for (int i = 0; i < rating.toInt(); i++) {
      stars.add(
        Icon(
          Remix.star_fill,
          size: size,
          color: color,
        ),
      );
    }
    if (rating / rating.toInt() > 1.0) {
      stars.add(
        Icon(
          Remix.star_half_fill,
          size: size,
          color: color,
        ),
      );
    }
    var rem = 5 - stars.length;
    for (int i = 0; i < rem; i++) {
      stars.add(
        Icon(
          Remix.star_line,
          size: size,
          color: color,
        ),
      );
    }
    return Row(
      children: stars,
      mainAxisSize: MainAxisSize.min,
    );
  }
}

class Dot extends StatelessWidget {
  final Color? color;
  final double? size;

  const Dot({Key? key, this.color, this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      width: size ?? 5.0,
      height: size ?? 5.0,
      decoration: BoxDecoration(
        color: Theme.of(context).dividerColor,
        borderRadius: BorderRadius.circular(AppTheme.kRadius),
      ),
    );
  }
}
