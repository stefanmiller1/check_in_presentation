import 'package:flutter/material.dart';

import '../../check_in_presentation.dart';


class ProfileCreatorContainerModel {

  final bool isEditorVisible;
  final IconData profileHeaderIcon;
  final String profileHeaderTitle;
  final String profileHeaderSubTitle;
  final String profileTabTitle;
  final ProfileEditorWidgetModel profileMainEditor;
  final Widget profilesList;
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
    child: Container(
      height: 40,
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
    ),
  );
}
