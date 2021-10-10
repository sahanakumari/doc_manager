import 'package:doc_manager/utils/page_routes.dart';
import 'package:flutter/material.dart';

class NavUtils {
  static Future animateTo(BuildContext context, Widget page) => Navigator.push(
        context,
        HeroDialogRoute(builder: (_) => page),
      );

  static Future enterTo(BuildContext context, Widget from, Widget to) =>
      Navigator.push(context, EnterExitRoute(from, to));

  static Future scaleTo(BuildContext context, Widget page) =>
      Navigator.push(context, ScaleRoute(page));
}
