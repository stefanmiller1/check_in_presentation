import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class DiscoverySectionObject {
  final String sectionTitle;
  final String sectionDescription;
  final IconData sectionIcon;
  final Widget? sectionMoreWidget;
  final String editButtonTitle;
  final bool hasValues;
  bool isLoading;
  final Widget mainSectionWidget;
  final Function()? onEditPressed;

  DiscoverySectionObject({
    required this.hasValues,
    required this.sectionTitle,
    required this.sectionDescription,
    required this.sectionIcon,
    required this.editButtonTitle,
    this.sectionMoreWidget,
    required this.isLoading,
    required this.mainSectionWidget,
    this.onEditPressed,
  });
}


class DiscoverySectionWidget extends StatelessWidget {
  final DashboardModel model;
  final DiscoverySectionObject discoverySectionObject;


  const DiscoverySectionWidget({
    Key? key,
    required this.model,
    required this.discoverySectionObject
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    if (discoverySectionObject.isLoading) {
      return const LoadingDiscoverySectionWidget();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(discoverySectionObject.sectionIcon, color: (discoverySectionObject.hasValues) ? model.paletteColor : model.disabledTextColor, size: 28),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    discoverySectionObject.sectionTitle,
                    style: TextStyle(color: (discoverySectionObject.hasValues) ?  model.paletteColor : model.disabledTextColor, fontWeight: FontWeight.bold, fontSize: model.questionTitleFontSize),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    discoverySectionObject.sectionDescription,
                    style: TextStyle(color: model.disabledTextColor),
                  ),
                ],
              ),
            ),
            Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (discoverySectionObject.sectionMoreWidget != null) discoverySectionObject.sectionMoreWidget!,
                  if (discoverySectionObject.hasValues)
                    InkWell(
                        onTap: discoverySectionObject.onEditPressed,
                        child: Text(discoverySectionObject.editButtonTitle, style: TextStyle(color: model.paletteColor, decoration: TextDecoration.underline, fontSize: model.secondaryQuestionTitleFontSize))
                    ),
                ]
            )
          ],
        ),
        const SizedBox(height: 12),
        if (discoverySectionObject.hasValues) discoverySectionObject.mainSectionWidget,

        const SizedBox(height: 15),
      ],
    );
  }
}


class LoadingDiscoverySectionWidget extends StatefulWidget {

  const LoadingDiscoverySectionWidget({Key? key}) : super(key: key);

  @override
  State<LoadingDiscoverySectionWidget> createState() => _LoadingDiscoverySectionWidgetState();
}

class _LoadingDiscoverySectionWidgetState extends State<LoadingDiscoverySectionWidget> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Shimmer.fromColors(
      baseColor: Colors.grey.shade400,
      highlightColor: Colors.grey.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 18,
                      width: (MediaQuery.of(context).size.width * 0.6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey.withOpacity(0.15),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      height: 14,
                      width: (MediaQuery.of(context).size.width * 0.4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey.withOpacity(0.15),
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {}, // Placeholder action
                child: Container(
                  height: 18,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.grey.withOpacity(0.15),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              height: 360,
              width: 400,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey.withOpacity(0.15),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: 60,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey.withOpacity(0.15),
            ),
          ),
        ],
      ),
    );
  }
}