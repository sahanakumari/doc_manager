import 'package:doc_manager/models/models.dart';
import 'package:doc_manager/models/networking.dart';
import 'package:doc_manager/providers/doc_provider.dart';
import 'package:doc_manager/screens/doctor_details_screen.dart';
import 'package:doc_manager/utils/app_styles.dart';
import 'package:doc_manager/utils/extensions.dart';
import 'package:doc_manager/utils/nav_utils.dart';
import 'package:doc_manager/utils/utils.dart';
import 'package:doc_manager/widgets/s_card.dart';
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
  late PageController _pageController;

  @override
  void initState() {
    _pageController = PageController(viewportFraction: 0.7);
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
                        child: _buildPageView(context, top3),
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
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          onTap: () => _onItemTap(items[index], "lv-$index"),
          title: Text(
            items[index].name,
            textScaleFactor: 1.1,
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  color: Theme.of(context).primaryColor,
                ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      (items[index].specialization ?? "").toUpperCase(),
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.caption?.copyWith(
                            color: Theme.of(context).primaryColor,
                          ),
                    ),
                  ),
                  const Dot(),
                  items[index].ratingWidgetCompact,
                ],
              ),
              Text(
                items[index].description ?? "",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          ),
          leading: Hero(
            tag: "lv-$index",
            child: SizedBox(
              width: 56,
              height: 56,
              child: Material(
                child: items[index].avatar,
                borderRadius: BorderRadius.circular(AppTheme.kRadius * 1.5),
                clipBehavior: Clip.hardEdge,
              ),
            ),
          ),
          trailing: const Icon(Remix.arrow_right_s_line),
        );
      },
      separatorBuilder: (BuildContext context, int index) =>
          const Divider(indent: 70),
      padding: EdgeInsets.symmetric(vertical: 20),
    );
  }

  _buildGridView(BuildContext context, List<Doctor> items) {
    return GridView.builder(
      key: const ValueKey("grid-view"),
      itemCount: items.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return Material(
          borderRadius: BorderRadius.circular(AppTheme.kRadius),
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            onTap: () => _onItemTap(items[index], "gv-$index"),
            child: Stack(
              children: [
                Hero(
                  tag: "gv-$index",
                  child: items[index].avatar,
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.black45, Colors.black12],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                    title: Text(
                      items[index].name,
                      textScaleFactor: 1.1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(
                            color: Colors.white,
                          ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                (items[index].specialization ?? "")
                                    .toUpperCase(),
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    ?.copyWith(
                                      color: Colors.white,
                                    ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          items[index].description ?? "",
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.caption?.copyWith(
                                color: Colors.white70,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  child: items[index].ratingWidgetCompact,
                  right: 5,
                  top: 5,
                ),
              ],
            ),
          ),
        );
      },
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
    );
  }

  _buildPageView(BuildContext context, List<Doctor> top3) {
    return PageView.builder(
      itemCount: top3.length,
      controller: _pageController,
      itemBuilder: (BuildContext context, int index) {
        var color = ColorUtils.randomColor;
        return SCard(
          margin: const EdgeInsets.all(5),
          child: InkWell(
            onTap: () => _onItemTap(top3[index], "pv-$index"),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Hero(
                    tag: "pv-$index",
                    child: SizedBox(
                      width: 120,
                      height: double.maxFinite,
                      child: Material(
                        child: top3[index].avatar,
                        borderRadius: BorderRadius.circular(AppTheme.kRadius),
                        clipBehavior: Clip.hardEdge,
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: [
                    Alignment.bottomLeft,
                    Alignment.topLeft
                  ][index % 2],
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        color,
                        color.withOpacity(0.5),
                        Colors.black12,
                      ],
                    ),
                  ),
                  height: double.maxFinite,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 80),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(10),
                      title: Text(
                        top3[index].name,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            ?.copyWith(color: Colors.white),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            (top3[index].specialization ?? "").toUpperCase(),
                            overflow: TextOverflow.ellipsis,
                            style:
                                Theme.of(context).textTheme.caption?.copyWith(
                                      color: Colors.white,
                                    ),
                          ),
                          RatingBar(rating: top3[index].ratingNum),
                          Text(
                            top3[index].description ?? "",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style:
                                Theme.of(context).textTheme.caption?.copyWith(
                                      color: Colors.white70,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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
