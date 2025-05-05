import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:check_in_domain/check_in_domain.dart';
import '../../check_in_presentation.dart';


class ProfileCreatorContainerModel {

  final bool isEditorVisible;
  final IconData profileHeaderIcon;
  final String profileHeaderTitle;
  final String profileHeaderSubTitle;
  final String profileTabTitle;
  final ProfileEditorWidgetModel profileMainEditor;
  final Widget profilesList;
  final ProfileTypeMarker profileType;
  late bool? isHovering;
  late bool? isOwner;
  late bool? showAddIcon;
  late bool? isReloading;
  late Function()? didSelectNew;

  ProfileCreatorContainerModel({
      required this.isEditorVisible,
      required this.profileHeaderIcon,
      required this.profileHeaderTitle,
      required this.profileHeaderSubTitle,
      required this.profileTabTitle,
      required this.profileMainEditor,
      required this.profilesList,
      required this.profileType,
      this.isHovering,
      this.showAddIcon,
      this.isOwner,
      this.isReloading,
      this.didSelectNew
  });
}

class ProfileEditorWidgetModel {

  final double height;
  final Widget editorItem;

  ProfileEditorWidgetModel({
    required this.height,
    required this.editorItem
  });

}


Widget getMainContainerAppbarBottomWidget(BuildContext context, DashboardModel model, TabController? controller, List<String> tabs, {required Function(int) didSelectIndex}) {
  return Theme(
    data: model.systemTheme.copyWith(
        colorScheme: model.systemTheme.colorScheme.copyWith(
            surfaceVariant: Colors.transparent
        )
    ),
    child: (!(kIsWeb)) ? Container(
      height: 40,
      color: model.mobileBackgroundColor,
      width: MediaQuery.of(context).size.width,
      child: TabBar(
        onTap: (index) => didSelectIndex(index),
        indicatorSize: TabBarIndicatorSize.tab,
        controller: controller,
        tabAlignment: TabAlignment.center,
        indicatorColor: model.paletteColor,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
        labelColor: model.paletteColor,
        unselectedLabelColor: model.disabledTextColor,
        isScrollable: true,
        tabs: tabs.map(
          (e) => Tab(
            child: Text(e, overflow: TextOverflow.ellipsis, maxLines: 1,),
          )
        ).toList(),
      ),
    ) : Container(
      color: Colors.transparent,
      height: 80,
      constraints: const BoxConstraints(maxWidth: 700),
      child: Padding(
        padding: const EdgeInsets.only(top: 25.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25.0),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    color: model.accentColor.withOpacity(0.35)
                ),
                child: TabBar(
                onTap: (index) => didSelectIndex(index),
                indicatorColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.tab,
                controller: controller,
                indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                color: model.paletteColor
                ),
                labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                labelColor: model.accentColor,
                unselectedLabelColor: model.paletteColor,
                  tabs: tabs.map(
                          (e) => Tab(
                        child: Text(e, overflow: TextOverflow.ellipsis, maxLines: 1,),
                      )
                  ).toList(),
                ),
              )
            )
          ),
        ),
      )
    ),
  );
}
