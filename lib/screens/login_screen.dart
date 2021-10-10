import 'package:doc_manager/screens/otp_screen.dart';
import 'package:doc_manager/utils/extensions.dart';
import 'package:doc_manager/utils/nav_utils.dart';
import 'package:doc_manager/utils/validators.dart';
import 'package:doc_manager/widgets/s_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:remixicon/remixicon.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _mobileController = TextEditingController();
  String _mobile = "";

  _mobileFieldListener() => setState(() {
        _mobile = _mobileController.text;
      });

  @override
  void initState() {
    _mobileController.addListener(_mobileFieldListener);
    super.initState();
  }

  bool get _isMobileEntered {
    var pattern = RegExp(Validators.kMobileRegex);
    if (pattern.hasMatch(_mobile)) return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  "enterMobile".tr(context).toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .headline4!
                      .copyWith(color: Colors.white),
                ),
                SizedBox(height: 20),
                Theme(
                  data: Theme.of(context).copyWith(
                    hintColor: Colors.white30,
                    iconTheme: IconThemeData(color: Colors.white),
                  ),
                  child: TextField(
                    controller: _mobileController,
                    style: Theme.of(context).textTheme.headline4?.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(16),
                      FilteringTextInputFormatter.allow(RegExp(r"[0-9]")),
                    ],
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.go,
                    decoration: InputDecoration(
                      hintText: "mobileNumber".tr(context),
                      prefixIcon: PopupMenuButton(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                "+91",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .buttonTheme
                                          .colorScheme!
                                          .primary,
                                    ),
                              ),
                            ),
                            Icon(
                              Remix.arrow_down_s_line,
                              size: 32,
                              color: Theme.of(context)
                                  .buttonTheme
                                  .colorScheme!
                                  .primary,
                            ),
                          ],
                        ),
                        itemBuilder: (BuildContext context) {
                          return [
                            const PopupMenuItem(child: Text("India (+91)")),
                          ];
                        },
                      ),
                      suffixIcon: _mobile.isEmpty
                          ? null
                          : IconButton(
                              onPressed: _mobileController.clear,
                              icon: const Icon(Remix.close_circle_line),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "enterMobileDesc".tr(context),
                  textScaleFactor: 1.1,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(color: Colors.white),
                ),
                SizedBox(height: 20),
                FractionallySizedBox(
                  widthFactor: 1,
                  child: SElevatedButton(
                    onPressed: _isMobileEntered
                        ? () {
                            NavUtils.scaleTo(
                              context,
                              OTPScreen(mobileNumber: _mobile),
                            );
                          }
                        : null,
                    child: Text(
                      "sendOtp".tr(context),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
