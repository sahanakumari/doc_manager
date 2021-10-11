import 'package:doc_manager/networking_n_storage/session.dart';
import 'package:doc_manager/screens/account_dialog.dart';
import 'package:doc_manager/screens/list_doctors_screen.dart';
import 'package:doc_manager/screens/login_screen.dart';
import 'package:doc_manager/screens/settings_screen.dart';
import 'package:doc_manager/utils/app_styles.dart';
import 'package:doc_manager/utils/extensions.dart';
import 'package:doc_manager/utils/nav_utils.dart';
import 'package:doc_manager/widgets/s_drawer_item.dart';
import 'package:doc_manager/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:remixicon/remixicon.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  void _onItemTap(int index) {
    setState(() {
      _index = index;
    });
    _toggle();
  }

  Widget get _page {
    return _drawerItems[_index]["p"] ??
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppIcon(),
              Text(
                "appName".tr(context),
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (_index != 0) {
          setState(() {
            _index = 0;
          });
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: InnerDrawer(
        key: _innerDrawerKey,
        onTapClose: true,
        swipe: true,
        boxShadow: [],
        colorTransitionScaffold: Colors.black12,
        offset: const IDOffset.only(bottom: 0.05),
        swipeChild: true,
        backgroundDecoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
        ),
        borderRadius: AppTheme.kRadius,
        leftAnimationType: InnerDrawerAnimation.quadratic,
        leftChild: _buildDrawer(context),
        scaffold: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: _toggle,
              icon: const Icon(Remix.menu_4_fill),
            ),
            title: Text("appName".tr(context)),
            actions: [
              IconButton(
                onPressed: () {
                  NavUtils.animateTo(context, const AccountDialog())
                      .then((value) {
                    if (value ?? false) {
                      Session.sessionUser = null;
                      NavUtils.scaleTo(context, const LoginScreen(), true);
                    }
                  });
                },
                icon: CircleAvatar(
                  child: const Icon(
                    Remix.user_3_fill,
                    size: 18,
                  ),
                  foregroundColor: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
          body: _page,
        ),
      ),
    );
  }

  final List<Map<String, dynamic>> _drawerItems = [
    {"i": Remix.home_6_fill, "t": "home", "p": const ListDoctorsScreen()},
    {"i": Remix.settings_5_fill, "t": "settings", "p": const SettingsScreen()},
    {"i": Remix.information_fill, "t": "about"},
  ];

  _buildDrawer(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(10.0),
                child: AppIcon(
                  backgroundColor: Colors.white70,
                  foregroundColor: Theme.of(context).primaryColor,
                ),
              ),
              const Divider(),
              ..._drawerItems
                  .map(
                    (e) => SDrawerItem(
                      label: e["t"],
                      icon: e["i"],
                      isSelected: _drawerItems.indexOf(e) == _index,
                      onTap: () => _onItemTap(_drawerItems.indexOf(e)),
                    ),
                  )
                  .toList(),
            ],
          ),
        ),
      ),
    );
  }

  final GlobalKey<InnerDrawerState> _innerDrawerKey =
      GlobalKey<InnerDrawerState>();

  void _toggle() {
    _innerDrawerKey.currentState?.toggle(direction: InnerDrawerDirection.start);
  }
}
