import 'package:doc_manager/utils/app_styles.dart';
import 'package:doc_manager/utils/extensions.dart';
import 'package:doc_manager/widgets/s_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:remixicon/remixicon.dart';

class OTPScreen extends StatefulWidget {
  final String mobileNumber;

  const OTPScreen({Key? key, required this.mobileNumber}) : super(key: key);

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController _otpController = TextEditingController();
  String _otp = "";
  bool _agreedToTerms = false;

  _mobileFieldListener() => setState(() {
        _otp = _otpController.text;
      });

  @override
  void initState() {
    _otpController.addListener(_mobileFieldListener);
    super.initState();
  }

  bool get _canSubmit => _otp.length == 6 && _agreedToTerms;

  @override
  Widget build(BuildContext context) {
    var linkTextStyle = Theme.of(context)
        .textTheme
        .bodyText2!
        .copyWith(color: Theme.of(context).colorScheme.secondary);
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Remix.arrow_left_s_line),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.white,
        ),
      ),
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  "enterVerificationCode".tr(context).toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .headline4!
                      .copyWith(color: Colors.white),
                ),
                SizedBox(height: 20),
                PinPut(
                  controller: _otpController,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(6),
                    FilteringTextInputFormatter.allow(RegExp(r"[0-9]")),
                  ],
                  textStyle: Theme.of(context).textTheme.headline4?.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.go,
                  fieldsCount: 6,
                  inputDecoration: const InputDecoration(
                    enabledBorder: InputBorder.none,
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    counterText: "",
                  ),
                  preFilledWidget: const Text(
                    "-",
                    style: TextStyle(
                      color: Colors.white24,
                    ),
                  ),
                  submittedFieldDecoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(AppTheme.kRadius),
                  ),
                  selectedFieldDecoration: BoxDecoration(
                    color: Colors.black12,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    borderRadius: BorderRadius.circular(AppTheme.kRadius),
                  ),
                  followingFieldDecoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(AppTheme.kRadius),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "enterVerificationCodeDesc"
                      .tr(context, {"mobile": widget.mobileNumber}),
                  textScaleFactor: 1.1,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(color: Colors.white),
                ),
                SizedBox(height: 20),
                CheckboxListTile(
                  value: _agreedToTerms,
                  onChanged: (bool? v) {
                    setState(() {
                      _agreedToTerms = v ?? false;
                    });
                  },
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: RichText(
                    text: TextSpan(
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(color: Colors.white),
                      children: [
                        TextSpan(text: "iAgreeToThe".tr(context)),
                        TextSpan(
                          text: "termsOfUse".tr(context),
                          style: linkTextStyle,
                        ),
                        TextSpan(text: "and".tr(context)),
                        TextSpan(
                          text: "privacyPolicy".tr(context),
                          style: linkTextStyle,
                        ),
                      ],
                    ),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: 1,
                  child: SElevatedButton(
                    onPressed: _canSubmit ? () {} : null,
                    child: Text(
                      "login".tr(context),
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
