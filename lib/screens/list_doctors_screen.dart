import 'package:doc_manager/models/models.dart';
import 'package:doc_manager/models/networking.dart';
import 'package:doc_manager/providers/doc_provider.dart';
import 'package:doc_manager/screens/doctor_details_screen.dart';
import 'package:doc_manager/utils/extensions.dart';
import 'package:doc_manager/utils/nav_utils.dart';
import 'package:doc_manager/widgets/section_title.dart';
import 'package:doc_manager/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:remixicon/remixicon.dart';

class ListDoctorsScreen extends StatefulWidget {
  const ListDoctorsScreen({Key? key}) : super(key: key);

  @override
  _ListDoctorsScreenState createState() => _ListDoctorsScreenState();
}

class _ListDoctorsScreenState extends State<ListDoctorsScreen> {
  late DocProvider _provider;

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _provider.getDocs();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (BuildContext context, DocProvider provider, Widget? child) {
      _provider = provider;
      var items = provider.doctors;
      if (provider.isLoading && items.isEmpty) {
        return const Align(
          alignment: Alignment.topCenter,
          child: RefreshProgressIndicator(),
        );
      }
      if (provider.error != null) {
        return ErrorContainer(
          title: "${provider.error}",
          subtitle: (provider.error is ErrorResponse)
              ? "${provider.error?.errorMessage}"
              : "${provider.error}",
          buttonText: "Re-load",
          buttonIcon: Remix.error_warning_fill,
          onRetryTap: () {
            provider.getDocs();
          },
        );
      }

      if (items.isEmpty) {
        return ErrorContainer(
          icon: const Icon(
            Remix.emotion_normal_line,
            size: 64,
          ),
          title: "itsLonely".tr(context),
          subtitle: "noDoctors".tr(context),
        );
      }

      return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: provider.toggleView,
          child: Icon(
            provider.isGridView ? Remix.list_check_2 : Remix.function_line,
          ),
        ),
        body: NestedScrollView(
          body: RefreshIndicator(
            onRefresh: provider.getDocs,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return ScaleTransition(
                  scale: animation,
                  child: child,
                );
              },
              child: provider.isGridView
                  ? _buildGridView(context, items)
                  : _buildListView(context, items),
            ),
          ),
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            var top3 = provider.top3Doctors;
            return [
              SliverAppBar(
                expandedHeight: 200,
                automaticallyImplyLeading: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionTitle("top3Doctors".tr(context)),
                      Expanded(
                        child: _buildPageView(context, provider),
                      ),
                    ],
                  ),
                ),
              ),
            ];
          },
        ),
      );
    });
  }

  _buildListView(BuildContext context, List<Doctor> items) {
    return ListView.separated(
      itemCount: items.length,
      key: const ValueKey("list-view"),
      physics: const BouncingScrollPhysics(),
      itemBuilder: (BuildContext context, int index) => DoctorListTile(
        heroTag: "lv-$index",
        onTap: () => _onItemTap(items[index], "lv-$index"),
        item: items[index],
      ),
      separatorBuilder: (BuildContext context, int index) =>
          const Divider(indent: 70),
      padding: const EdgeInsets.symmetric(vertical: 20),
    );
  }

  _buildGridView(BuildContext context, List<Doctor> items) {
    return GridView.builder(
      key: const ValueKey("grid-view"),
      itemCount: items.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (BuildContext context, int index) => DoctorListTile(
        heroTag: "gv-$index",
        item: items[index],
        onTap: () => _onItemTap(items[index], "gv-$index"),
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
    );
  }

  _buildPageView(BuildContext context, DocProvider provider) {
    return DocCarousel(provider: provider, onItemTap: _onItemTap);
  }

  _onItemTap(Doctor item, String tag) {
    NavUtils.animateTo(context, DoctorDetailsScreen(doctor: item, tag: tag))
        .then((value) {
      if (value == true) {
        _provider.syncData();
      }
    });
  }
}
