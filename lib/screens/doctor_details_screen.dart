import 'package:doc_manager/models/models.dart';
import 'package:doc_manager/utils/app_styles.dart';
import 'package:doc_manager/utils/extensions.dart';
import 'package:doc_manager/widgets/s_buttons.dart';
import 'package:doc_manager/widgets/s_card.dart';
import 'package:doc_manager/widgets/s_inputs.dart';
import 'package:doc_manager/widgets/section_title.dart';
import 'package:doc_manager/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:remixicon/remixicon.dart';

class DoctorDetailsScreen extends StatefulWidget {
  final Doctor doctor;
  final String? tag;

  DoctorDetailsScreen({Key? key, required this.doctor, this.tag})
      : super(key: key);

  @override
  _DoctorDetailsScreenState createState() => _DoctorDetailsScreenState();
}

class _DoctorDetailsScreenState extends State<DoctorDetailsScreen> {
  late Doctor _doctor;
  bool _isEditMode = false;
  bool _almostCollapsed = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _doctor = widget.doctor;
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _fillDetails(_doctor);
    });
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  final TextEditingController _firstNameCtrl = TextEditingController();
  final TextEditingController _lastNameCtrl = TextEditingController();
  final TextEditingController _dobCtrl = TextEditingController();
  final TextEditingController _mobileCtrl = TextEditingController();
  final TextEditingController _genderCtrl = TextEditingController();
  final TextEditingController _bloodGroupCtrl = TextEditingController();
  final TextEditingController _heightCtrl = TextEditingController();
  final TextEditingController _weightCtrl = TextEditingController();

  _fillDetails(Doctor doctor) {
    _firstNameCtrl.text = _doctor.firstName ?? "";
    _lastNameCtrl.text = _doctor.lastName ?? "";
    _genderCtrl.text = "unknownExt".tr(context);
    _dobCtrl.text = "unknownExt".tr(context);
    _mobileCtrl.text = _doctor.primaryContactNo ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, provider, child) {
      var _avatarSize = MediaQuery.of(context).size.width / 2.5;
      var _linearFactor = 0.5;
      return Scaffold(
        body: NestedScrollView(
          controller: _scrollController,
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    _doctor.name,
                    style: Theme.of(context).textTheme.headline5?.copyWith(
                          color: Theme.of(context).primaryColor,
                        ),
                  ),
                ),
                Center(
                  child: Text(
                    _doctor.specialization ?? 'n/a',
                    style: Theme.of(context).textTheme.caption?.copyWith(
                          color: Theme.of(context).primaryColor,
                        ),
                  ),
                ),
                Center(child: RatingBar(rating: _doctor.ratingNum, size: 20)),
                if (!_isEditMode)
                  Center(
                    child: SElevatedButton(
                      child: Text("editProfile".tr(context)),
                      onPressed: () {
                        setState(() {
                          _isEditMode = true;
                        });
                      },
                    ),
                  ),
                SectionTitle("personalDetails".tr(context)),
                SFormInput(
                  hint: "enterFirstName".tr(context),
                  label: "firstName".tr(context),
                  controller: _firstNameCtrl,
                  enabled: _isEditMode,
                  suffixIcon: Icon(Remix.user_3_line),
                ),
                SFormInput(
                  hint: "enterLastName".tr(context),
                  label: "lastName".tr(context),
                  enabled: _isEditMode,
                  controller: _lastNameCtrl,
                  suffixIcon: Icon(Remix.user_3_line),
                ),
                if (_isEditMode) ...[
                  SizedBox(height: 10),
                  Text(
                    "gender".tr(context),
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(
                          color: Theme.of(context).hintColor,
                        ),
                  ),
                  Wrap(
                    children: ["male", "female"]
                        .map(
                          (e) => Padding(
                            padding: const EdgeInsets.only(right: 7.5),
                            child: ChoiceChip(
                              label: Text(e.tr(context)),
                              selected: false,
                              onSelected: (v) {},
                            ),
                          ),
                        )
                        .toList(),
                  )
                ] else
                  SFormInput(
                    hint: "selectGender".tr(context),
                    label: "gender".tr(context),
                    enabled: _isEditMode,
                    suffixIcon: Icon(Remix.men_line),
                    controller: _genderCtrl,
                  ),
                SFormInput(
                  hint: "enterMobileNumber".tr(context),
                  label: "mobileNumber".tr(context),
                  controller: _mobileCtrl,
                  enabled: false,
                  suffixIcon: const Icon(Remix.smartphone_line),
                ),
                InkWell(
                  onTap: _isEditMode ? _selectDate : null,
                  child: SFormInput(
                    hint: "enterDateOfBirth".tr(context),
                    label: "dateOfBirth".tr(context),
                    controller: _dobCtrl,
                    enabled: false,
                    forcedBorder: _isEditMode,
                    suffixIcon: const Icon(Remix.calendar_2_line),
                  ),
                ),
                Wrap(
                  children: [
                    FractionallySizedBox(
                      widthFactor: _linearFactor,
                      child: SFormSelect(
                        hint: "selectBloodGroup".tr(context),
                        label: "bloodGroup".tr(context),
                        enabled: _isEditMode,
                        onChanged: (v) {},
                        suffixIcon: const Icon(Remix.arrow_down_s_line),
                        items: [
                          "A+ve",
                          "A-ve",
                          "AB+ve",
                          "AB-ve",
                          "B+ve",
                          "B-ve",
                          "O+ve",
                          "O-ve",
                        ]
                            .map((e) =>
                                DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: _linearFactor,
                      child: SFormInput(
                        hint: "enterHeight".tr(context),
                        label: "height".tr(context),
                        controller: _heightCtrl,
                        enabled: _isEditMode,
                        suffixIcon: const Icon(Remix.ruler_line),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: _linearFactor,
                      child: SFormInput(
                        hint: "enterWeight".tr(context),
                        label: "weight".tr(context),
                        controller: _weightCtrl,
                        enabled: _isEditMode,
                        suffixIcon: const Icon(Remix.scales_3_line),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                pinned: true,
                backgroundColor:
                    _almostCollapsed ? Theme.of(context).canvasColor : null,
                title: _almostCollapsed ? Text(_doctor.name) : null,
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Remix.arrow_left_s_line,
                    color: _almostCollapsed ? null : Colors.white,
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: [
                      Container(
                        color: Theme.of(context).primaryColor,
                        width: double.maxFinite,
                        height: double.maxFinite,
                        margin: EdgeInsets.only(bottom: _avatarSize / 3),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Hero(
                          tag: widget.tag ?? "avatar",
                          child: SizedBox(
                            width: _avatarSize,
                            height: _avatarSize,
                            child: SCard(child: _doctor.avatar),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                expandedHeight: _avatarSize * 1.5,
              )
            ];
          },
        ),
        bottomNavigationBar: _isEditMode
            ? Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: SElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isEditMode = false;
                          });
                        },
                        isSecondary: true,
                        child: Text(
                          "cancel".tr(context),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: SElevatedButton(
                        onPressed: () {},
                        child: Text(
                          "save".tr(context),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : null,
      );
    });
  }

  _selectDate() {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppTheme.kRadius),
          ),
        ),
        builder: (_) {
          return SizedBox(
            height: 240,
            child: CupertinoTheme(
              data: CupertinoThemeData(
                textTheme: CupertinoTextThemeData(
                  dateTimePickerTextStyle:
                      Theme.of(context).textTheme.bodyText1,
                ),
              ),
              child: CupertinoDatePicker(
                onDateTimeChanged: (date) {},
                initialDateTime: DateTime.now().add(
                  const Duration(days: -(18 * 365)),
                ),
                minimumDate: DateTime.now().add(
                  const Duration(days: -(100 * 365)),
                ),
                maximumDate: DateTime.now().add(
                  const Duration(days: -(18 * 365)),
                ),
                mode: CupertinoDatePickerMode.date,
              ),
            ),
          );
        });
  }

  void _scrollListener() {
    var position = _scrollController.offset;
    setState(() {
      if (position >= 160) {
        _almostCollapsed = true;
      } else {
        _almostCollapsed = false;
      }
    });
  }
}
