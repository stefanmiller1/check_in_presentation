import 'package:flutter/material.dart';
import 'package:check_in_domain/check_in_domain.dart';
import '../../../core/profile_creator_template/profile_creator_template_helper.dart';
import 'package:check_in_domain/domain/misc/explore_services/value_objects.dart';


class ExploreContainerModel {
  final ExploreContainerType containerType;
  final Widget mainContainerWidget;
  final Widget? bottomAppBarWidget;
  final String containerTitle;
  final bool? isLoading;

  ExploreContainerModel({
    required this.containerType, 
    required this.mainContainerWidget, 
    required this.containerTitle, 
    this.bottomAppBarWidget,
    this.isLoading
    }); 
}


class ExploreSearchContainerModel {
  final ExploreBrowseType searchType;
  final Widget filterBarWidget;
  final Widget exploreSearchWidget;
  final Widget headerWidget;
  final String searchTypeTitle;
  final bool? isLoading;

  ExploreSearchContainerModel({
    required this.searchType,
    required this.filterBarWidget,
    required this.exploreSearchWidget,
    required this.headerWidget,
    required this.searchTypeTitle,
    this.isLoading,
  });
}

class ExploreSearchQueryObject {

final ExploreContainerType exploreType;
final ProfileTypeMarker? userProfileType;
final UniqueId? profileId;
final String? profileImage;
final String? profileFirstName;
final String? profileLastName;
final String? profileSubName;


  ExploreSearchQueryObject({
     required this.exploreType,
     this.userProfileType, 
     this.profileId, 
     this.profileImage, 
     this.profileFirstName, 
     this.profileLastName,
     this.profileSubName
     });

     

}