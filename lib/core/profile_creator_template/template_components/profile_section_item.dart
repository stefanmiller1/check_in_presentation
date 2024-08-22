import 'dart:math';

import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProfileSectionObject {
  final String sectionTitle;
  final String sectionDescription;
  final IconData sectionIcon;
  final Widget? sectionMoreWidget;
  final String editButtonTitle;
  final bool hasValues;
  final bool isOwner;
  final Widget? emptyMainSectionWidget;
  bool isLoading;
  final Widget mainSectionWidget;
  final Function()? onEditPressed;

  ProfileSectionObject({
    required this.hasValues,
    required this.sectionTitle,
    required this.sectionDescription,
    required this.sectionIcon,
    required this.editButtonTitle,
    this.sectionMoreWidget,
    required this.isOwner,
    this.emptyMainSectionWidget,
    required this.isLoading,
    required this.mainSectionWidget,
    this.onEditPressed,
  });
}


class ProfileSectionWidget extends StatelessWidget {
  final DashboardModel model;
  final ProfileSectionObject profileSectionObject;


  const ProfileSectionWidget({
    Key? key,
    required this.model,
    required this.profileSectionObject
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (profileSectionObject.isOwner == false && profileSectionObject.emptyMainSectionWidget == null) {
      return Container();
    }
    if (profileSectionObject.isLoading) {
      return LoadingProfileSectionWidget();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(profileSectionObject.sectionIcon, color: (profileSectionObject.hasValues) ? model.paletteColor : model.disabledTextColor, size: 28),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profileSectionObject.sectionTitle,
                    style: TextStyle(color: (profileSectionObject.hasValues) ?  model.paletteColor : model.disabledTextColor, fontWeight: FontWeight.bold, fontSize: model.questionTitleFontSize),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    profileSectionObject.sectionDescription,
                    style: TextStyle(color: model.disabledTextColor),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (profileSectionObject.sectionMoreWidget != null) profileSectionObject.sectionMoreWidget!,
                if (profileSectionObject.hasValues)
                  InkWell(
                      onTap: profileSectionObject.onEditPressed,
                      child: Text(profileSectionObject.editButtonTitle, style: TextStyle(color: model.paletteColor, decoration: TextDecoration.underline, fontSize: model.secondaryQuestionTitleFontSize))
                  ),
              ]
            )
          ],
        ),
        const SizedBox(height: 12),
        if (profileSectionObject.hasValues) profileSectionObject.mainSectionWidget,
        if (profileSectionObject.hasValues == false && profileSectionObject.emptyMainSectionWidget != null) profileSectionObject.emptyMainSectionWidget!,

        const SizedBox(height: 15),
      ],
    );
  }
}


class LoadingProfileSectionWidget extends StatefulWidget {

  const LoadingProfileSectionWidget({Key? key}) : super(key: key);

  @override
  State<LoadingProfileSectionWidget> createState() => _LoadingProfileSectionWidgetState();
}

class _LoadingProfileSectionWidgetState extends State<LoadingProfileSectionWidget> {

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