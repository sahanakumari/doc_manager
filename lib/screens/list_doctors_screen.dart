import 'package:doc_manager/models/networking.dart';
import 'package:doc_manager/providers/doc_provider.dart';
import 'package:doc_manager/utils/app_styles.dart';
import 'package:doc_manager/utils/extensions.dart';
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
      if (provider.isLoading) {
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

      return ListView.separated(
        itemCount: items.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
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
                Text(
                  (items[index].specialization ?? "").toUpperCase(),
                  style: Theme.of(context).textTheme.caption?.copyWith(
                        color: Theme.of(context).primaryColor,
                      ),
                ),
                Text(
                  items[index].description ?? "",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            ),
            leading: SizedBox(
              width: 56,
              height: 56,
              child: Material(
                child: items[index].avatar,
                borderRadius: BorderRadius.circular(AppTheme.kRadius * 1.5),
                clipBehavior: Clip.hardEdge,
              ),
            ),
            trailing: const Icon(Remix.arrow_right_s_line),
          );
        },
        separatorBuilder: (BuildContext context, int index) =>
            const Divider(indent: 70),
      );
    });
  }
}
