import 'dart:async';
import 'package:beamer/beamer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:check_in_presentation/explore_core_widgets/components/template_components/explore_search_query_app_bar.dart';
import '../../../core/profile_creator_template/profile_creator_template_helper.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'explore_search_shell.dart';
import 'package:check_in_domain/domain/misc/explore_services/value_objects.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_facade/check_in_facade.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'dart:ui' as UI;


class ExploreSearchhMainLayout extends StatefulWidget {
  final DashboardModel model;
  final ExploreContainerType? initialContainerType;
  final String? initialQuery;
  final List<ExploreContainerModel> exploreMainContainer;
  final Function(ExploreSearchQueryObject) didUpdateQueryObject;

  const ExploreSearchhMainLayout({
    super.key,
    required this.model,
    this.initialContainerType,
    this.initialQuery,
    required this.exploreMainContainer,
    required this.didUpdateQueryObject,
  });

  @override
  _ExploreSearchhMainLayoutState createState() =>
      _ExploreSearchhMainLayoutState();
}

class _ExploreSearchhMainLayoutState extends State<ExploreSearchhMainLayout> {
  late ExploreContainerType currentContainerType;
  late String? currentQuery;
  final ScrollController _scrollController = ScrollController();
  late List<String> _searchQueryHistory = [];
  final FocusNode _dropdownFocusNode = FocusNode(); 
  final FocusNode _searchFocusNode = FocusNode(); // Add a focus node for search bar
  bool _isDropdownVisible = false; // Track dropdown visibility
  Timer? _debounce;
  bool? isLoading; 
  List<UserProfileModel> userProfiles = [];
  List<EventMerchantVendorProfile> vendorProfiles = [];

  List<ExploreSearchQueryObject> currentprofileQueryList = [];
  late TextEditingController _searchController;


  void initState() {
    super.initState();
    currentQuery = widget.initialQuery;
    
    currentContainerType = widget.initialContainerType ?? ExploreContainerType.browse;
    _searchController = TextEditingController(text: widget.initialQuery); 
    if (widget.initialQuery != null) {
      _performSearch(widget.initialQuery!.trim(), false);
    }
    // Listen for focus changes on the search bar
    _searchFocusNode.addListener(_updateDropdownVisibility);

    // Listen for focus changes on the dropdown
    _dropdownFocusNode.addListener(_updateDropdownVisibility);

    // Listen for scroll events to hide the dropdown
    // _scrollController.addListener(() {
    //   if (_isDropdownVisible) {
    //     setState(() {
    //       _isDropdownVisible = false;
    //     });
    //   }
    // });
  }

  void _updateDropdownVisibility() {
    setState(() {
      // Dropdown should be visible if either the search bar or the dropdown itself is focused
      if (_searchFocusNode.hasFocus) {
        _isDropdownVisible = true;
      } else if (_dropdownFocusNode.hasFocus) {
        _isDropdownVisible = true;
      } 
    });
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    _dropdownFocusNode.dispose();
    _scrollController.dispose();
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  double getPaddingForMainContainer() {
    switch (currentContainerType) {
      case ExploreContainerType.browse:
        return (Responsive.isMobile(context)) ? 38 : 0;
      case ExploreContainerType.queryProfile:
        return 100;
      case ExploreContainerType.userProfile:
        return (Responsive.isMobile(context)) ? 38 : 100;
      default:
        return 0;
    }
  }

  Widget? getBottomAppBarFromSearchType(ExploreContainerType mainContainer) {
    final container = widget.exploreMainContainer.firstWhereOrNull(
      (container) => container.containerType == mainContainer,
    );
    return container?.bottomAppBarWidget;
  }


  Widget getMainContainerFromSearchType(ExploreContainerType mainContainer) {
    final container = widget.exploreMainContainer.firstWhere(
      (container) => container.containerType == mainContainer,
      orElse: () => ExploreContainerModel(
        containerType: mainContainer,
        mainContainerWidget: const Center(
          child: Text('No content available'),
        ),
        containerTitle: 'Unavailable',
      ),
    );
    return container.mainContainerWidget;
  }

  bool getLoadingState(ExploreContainerType mainContainer) {
    final container = widget.exploreMainContainer.firstWhere(
      (container) => container.containerType == mainContainer,
      orElse: () => ExploreContainerModel(
        containerType: mainContainer,
        mainContainerWidget: const Center(
          child: Text('No content available'),
        ),
        containerTitle: 'Unavailable',
      ),
    );

    return container.isLoading ?? false;
  }

  Widget? getAppBarLeadingButtonWidget() {
    switch (currentContainerType) {
      case ExploreContainerType.browse:
        return null;
      case ExploreContainerType.queryProfile:
        return IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              currentContainerType = ExploreContainerType.browse;
            });
          },
        );
      case ExploreContainerType.userProfile:
      /// button for returning back to browse container
      
        return Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                setState(() {
                  currentContainerType = ExploreContainerType.browse;
                  if (Beamer.of(context).canBeamBack) {
                    Beamer.of(context).beamBack();
                  } else {
                    Beamer.of(context).update(
                      configuration: RouteInformation(
                        uri: Uri.parse(searchExploreRoute()),
                      ),
                      rebuild: false
                    );
                  }
                });
              },
            ),
          SizedBox(width: 8),
            /// button for inviting to a circle
        Container(
          height: 50,
          // width: 200,
          decoration: BoxDecoration(
            color: widget.model.paletteColor,
            borderRadius: BorderRadius.circular(40),
          ),
          child: InkWell(
            onTap: () {
              
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: (Responsive.isMobile(context)) ? 
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.add, color: widget.model.accentColor),
                      ) : Row(
                      children: [
                      Text('Start a', style: TextStyle(color: widget.model.accentColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                      const SizedBox(width: 8),
                      Icon(Icons.circle_outlined, color: widget.model.accentColor),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      default:
        return null;
    }
  }

void _onTextChanged(String text, {bool isSubmitted = false}) {
  setState(() {
    isLoading = true;
    currentQuery = text;
  });
  // Cancel any ongoing debounce if it exists
  if (_debounce?.isActive ?? false) _debounce!.cancel();

  // If triggered via submit, bypass the debounce and run the query immediately
  if (isSubmitted) {
    _performSearch(text.trim(), true);
    return;
  }

  // Otherwise, debounce the query by 3 seconds
  _debounce = Timer(const Duration(seconds: 1), () async {
    final query = text.trim();
    if (query.isEmpty) {
      setState(() {
        _isDropdownVisible = true;
        isLoading = false;
      });
      return;
    }
    await _performSearch(query, true);
  });
}


  Future<void> _performSearch(String query, bool showDropDown) async {
    try {
      
      final queryParts = query.split(' ');
      final firstName = queryParts.isNotEmpty ? queryParts[0].substring(0, 1).toUpperCase() + queryParts[0].substring(1) : '';
      final lastName = queryParts.length > 1 ? queryParts[1].substring(0, 1).toUpperCase() + queryParts[1].substring(1) : '';

      final userProfileResults = await UserProfileFacade.instance.queryByUserProfileSearch(firstName: firstName, lastName: lastName, limit: 4);
      final vendorProfileResults = await MerchVenFacade.instance.queryByUserProfileSearch(vendorName: firstName, limit: 4);

      // final circleResults = await FirebaseFirestore.instance
      //     .collection('circles')
      //     .where('circleName', isGreaterThanOrEqualTo: query)
      //     .where('circleName', isLessThanOrEqualTo: query + '\uf8ff')
      //     .limit(4) 
      //     .get();

      setState(() {
        userProfiles.clear();
        vendorProfiles.clear();
        userProfiles = userProfileResults.toList();
        vendorProfiles = vendorProfileResults.toList();
      //   circles = circleResults.docs.map((doc) => doc.data()).toList();

      // Add the current query to searchHistory if it's not already present
      if (!_searchQueryHistory.contains(query)) {
        _searchQueryHistory.add(query);
      }

        _isDropdownVisible = true && showDropDown; 
        isLoading = false;
      });
    } catch (e) {
      isLoading = false;
      print("Error performing search: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_isDropdownVisible) {
          setState(() {
            _isDropdownVisible = false;
          });
        }
      },
      child: Scaffold(
        backgroundColor: widget.model.webBackgroundColor,
        appBar: Responsive.isMobile(context)
            ? AppBar(
              backgroundColor: widget.model.mobileBackgroundColor,
              elevation: 0,
              scrolledUnderElevation: 0,
              automaticallyImplyLeading: false,
              centerTitle: true,
              toolbarHeight: 100,
              title: Center(
                child: ExploreSearchFilterQueryBar(
                  searchController: _searchController,
                  initialQuery: currentQuery,
                  onSearchQueryChanged: (query) => _onTextChanged(query),
                  onSearchSubmitted: (query) => _onTextChanged(query, isSubmitted: true),
                  mobileSearchView: Container(color: Colors.red),
                  didSelectFilter: () {},
                  webDropdownView: (query) => Container(color: Colors.blue),
                  model: widget.model,
                  focusNode: _searchFocusNode,
                ),
              ),
              bottom: (getBottomAppBarFromSearchType(currentContainerType) != null) ? PreferredSize(
                preferredSize: const Size.fromHeight(64),
                child: Center(child: getBottomAppBarFromSearchType(currentContainerType)!)
              ) : null,
            )
          : null,
        body: LayoutBuilder(
          builder: (context, constraints) {

            return Stack(
              alignment: Alignment.topCenter,
              children: [
                
                if (getLoadingState(currentContainerType) == true) Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: JumpingDots(numberOfDots: 3, color: widget.model.paletteColor)
                  )
                ),
                if (getLoadingState(currentContainerType) == false) SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                      children: [
                        SizedBox(height: getPaddingForMainContainer()),
                        getMainContainerFromSearchType(currentContainerType),
                    ],
                  ),
                ),
                
            
                BackdropFilter(
                  filter: (_isDropdownVisible) ? UI.ImageFilter.blur(sigmaX: 10, sigmaY: 10) : UI.ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      if (!Responsive.isMobile(context)) Positioned(
                          top: 25,
                          child: ExploreSearchFilterQueryBar(
                            searchController: _searchController,
                            initialQuery: currentQuery,
                            onSearchQueryChanged: (query) => _onTextChanged(query),
                            onSearchSubmitted: (query) => _onTextChanged(query, isSubmitted: true),
                            mobileSearchView: Container(color: Colors.red),
                            didSelectFilter: () {},
                            webDropdownView: (query) => Container(color: Colors.blue),
                            model: widget.model,
                            focusNode: _searchFocusNode,
                          ),
                        ),
                                    
                      if (getBottomAppBarFromSearchType(currentContainerType) != null && Responsive.isMobile(context) == false) Positioned(
                          top: 85,
                          child: Column(
                            children: [
                              getBottomAppBarFromSearchType(currentContainerType)!,
                              Divider(color: widget.model.disabledTextColor),
                              const SizedBox(height: 25),
                          ],
                        )
                      ),
                  
                      if (!Responsive.isMobile(context) && getAppBarLeadingButtonWidget() != null) Positioned(
                          top: 25,
                          left: 0,
                          child: getAppBarLeadingButtonWidget()!
                      ),
                        
                      if (_isDropdownVisible) Positioned(
                          top: (Responsive.isMobile(context)) ? 20 : 110,
                          child: Focus(
                            focusNode: _dropdownFocusNode,
                            child: SlideInTransitionWidget(
                              transitionWidget: Padding(
                                padding: (Responsive.isMobile(context)) ? EdgeInsets.all(8.0) : EdgeInsets.zero,
                                child: Container(
                                    width: (Responsive.isMobile(context)) ? MediaQuery.of(context).size.width - 20 : 800,
                                    margin: const EdgeInsets.only(top: 8.0),
                                    // height: 400,
                                    constraints: const BoxConstraints(maxWidth: 800),
                                    decoration: BoxDecoration(
                                      color: widget.model.accentColor,
                                      borderRadius: BorderRadius.circular(25.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: widget.model.disabledTextColor.withOpacity(0.35),
                                          blurRadius: 4.0,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: _buildDropdownContent(currentprofileQueryList),
                                  ), 
                                ),
                              ),
                              durationTime: 240,
                              offset: const Offset(0, -0.05),
                          ),
                        ),
                      ),
                    ]
                  ),
                ),
            
                
              ],
            );
          },
        ),
      ),
    );
  }



  Widget _buildDropdownContent(List<ExploreSearchQueryObject> currentQueryResults) {      

      if (currentQuery == null || (currentQuery ?? '').isEmpty) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// overview explaining what to search or top/trending/suggested search items 
                const SizedBox(height: 8),
                Text('Trending & Suggested Search Items', style: TextStyle(fontSize: widget.model.questionTitleFontSize, color: widget.model.paletteColor)),
                  ListTile(
                    title: Text('How to create a profile', style: TextStyle(fontSize: widget.model.secondaryQuestionTitleFontSize, color: widget.model.disabledTextColor)),
                    subtitle: Text('Learn how to set up your profile step-by-step and make the most out of your presence.', style: TextStyle(color: widget.model.disabledTextColor)),
                    leading: Icon(Icons.person_add, color: widget.model.disabledTextColor),
                    onTap: () {
                    // Handle tap
                    },
                  ),
                  ListTile(
                    title: Text('How to be an organizer', style: TextStyle(fontSize: widget.model.secondaryQuestionTitleFontSize, color: widget.model.disabledTextColor)),
                    subtitle: Text('Find out how to organize and manage events effectively to ensure success.', style: TextStyle(color: widget.model.disabledTextColor)),
                    leading: Icon(Icons.event, color: widget.model.disabledTextColor),
                    onTap: () {
                    // Handle tap
                    },
                  ),
                  ListTile(
                    title: Text('Add your brand', style: TextStyle(fontSize: widget.model.secondaryQuestionTitleFontSize, color: widget.model.disabledTextColor)),
                    subtitle: Text('Steps to add and promote your brand to reach a wider audience.', style: TextStyle(color: widget.model.disabledTextColor)),
                    leading: Icon(Icons.branding_watermark, color: widget.model.disabledTextColor),
                    onTap: () {
                    // Handle tap
                    },
                  ),
                  ListTile(
                    title: Text('Brands to look out for', style: TextStyle(fontSize: widget.model.secondaryQuestionTitleFontSize, color: widget.model.disabledTextColor)),
                    subtitle: Text('Discover trending and popular brands that are making waves.', style: TextStyle(color: widget.model.disabledTextColor)),
                    leading: Icon(Icons.star, color: widget.model.disabledTextColor),
                    onTap: () {
                    // Handle tap
                    },
                  ),
                  ListTile(
                    title: Text('Change your status', style: TextStyle(fontSize: widget.model.secondaryQuestionTitleFontSize, color: widget.model.disabledTextColor)),
                    subtitle: Text('Update your current status easily to keep your followers informed.', style: TextStyle(color: widget.model.disabledTextColor)),
                    leading: Icon(Icons.update, color: widget.model.disabledTextColor),
                    onTap: () {
                    // Handle tap
                    },
                  ),
                  ListTile(
                    title: Text('Update your calendar', style: TextStyle(fontSize: widget.model.secondaryQuestionTitleFontSize, color: widget.model.disabledTextColor)),
                    subtitle: Text('Keep your calendar up-to-date to manage your schedule efficiently.', style: TextStyle(color: widget.model.disabledTextColor)),
                    leading: Icon(Icons.calendar_today, color: widget.model.disabledTextColor),
                    onTap: () {
                  // Handle tap
                  },
                ),
              ]
            ),
            
            if (_searchQueryHistory.isNotEmpty) Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Divider(color: widget.model.disabledTextColor),
                const SizedBox(height: 8),
                Text('Search History', style: TextStyle(fontSize: widget.model.questionTitleFontSize, color: widget.model.paletteColor)),
                ..._searchQueryHistory.reversed.take(7).map((history) => ListTile(
                  onTap: () {
                    setState(() {
                    _onTextChanged(history, isSubmitted: true);
                    _searchController.text = history;
                    });
                  },
                  title: Text(history, style: TextStyle(fontSize: widget.model.secondaryQuestionTitleFontSize, color: widget.model.disabledTextColor)), 
                  leading: Icon(Icons.search_rounded, color: widget.model.disabledTextColor),
                  ),
                ),
              ]
            ),
          ],
        );
      }


      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (userProfiles.isNotEmpty)
            Text('Profiles', style: TextStyle(fontSize: widget.model.questionTitleFontSize, fontWeight: FontWeight.bold, color: widget.model.paletteColor)),
            ...userProfiles.map((user) => ListTile(
              onTap: () {
                setState(() {
                  /// should update url & 
                  currentContainerType = ExploreContainerType.userProfile;
                  _searchController.text = user.legalName.value.fold((l) => '', (r) => r) + ' ' + user.legalSurname.value.fold((l) => '', (r) => r);  
                  widget.didUpdateQueryObject(
                    ExploreSearchQueryObject(
                      exploreType: ExploreContainerType.userProfile,
                      userProfileType: ProfileTypeMarker.generalProfile,
                      profileId: user.userId,
                    )
                  );

                    Beamer.of(context).update(
                      configuration: RouteInformation(
                        uri: Uri.parse(searchExploreByProfileRoute(user.userId.getOrCrash(), ProfileTypeMarker.generalProfile.name, _searchController.text)),
                      ),
                      rebuild: false
                    );
                  });
                /// run search and switch main content to type queryBrowse
              },
              leading: SizedBox(
                height: 50,
                width: 50,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: CachedNetworkImage(
                      imageUrl: user.photoUri ?? '',
                      imageBuilder: (context, imageProvider) => CircleAvatar(backgroundImage: imageProvider),
                      errorWidget: (context, url, error) => CircleAvatar(backgroundImage: Image.asset('assets/profile-avatar.png').image)
                    ),
                ),
              ),
              title: Text(user.legalName.value.fold((l) => '', (r) => r) + ' ' + user.legalSurname.value.fold((l) => '', (r) => r), style: TextStyle(color: widget.model.paletteColor),)
                ),
              ),

              if (vendorProfiles.isNotEmpty) Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                const SizedBox(height: 8),
                if (userProfiles.isNotEmpty) Divider(color: widget.model.disabledTextColor),
                Text('Vendors & Brands', style: TextStyle(fontSize: widget.model.questionTitleFontSize, fontWeight: FontWeight.bold, color: widget.model.paletteColor)),
                ...vendorProfiles.map((vendor) => ListTile(
                    onTap: () {
                      setState(() {
                        /// should update url & 
                        currentContainerType = ExploreContainerType.userProfile;
                        _searchController.text = vendor.brandName.value.fold((l) => '', (r) => r);  
                        widget.didUpdateQueryObject(
                            ExploreSearchQueryObject(
                              exploreType: ExploreContainerType.userProfile,
                              userProfileType: ProfileTypeMarker.vendorProfile,
                              profileId: vendor.profileOwner,
                            )
                          );
                          
                           Beamer.of(context).update(
                              configuration: RouteInformation(
                              uri: Uri.parse(searchExploreByProfileRoute(vendor.profileOwner.getOrCrash(), ProfileTypeMarker.vendorProfile.name, vendor.brandName.value.fold((l) => 'profile', (r) => r))),
                              ),
                              rebuild: false
                            );
                          
                      });
                      /// run search and switch main content to type queryBrowse
                    },
                    leading: SizedBox(
                      height: 50,
                      width: 50,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: CachedNetworkImage(
                            imageUrl: vendor.uriImage?.uriPath ?? '',
                            imageBuilder: (context, imageProvider) => CircleAvatar(backgroundImage: imageProvider),
                            errorWidget: (context, url, error) => CircleAvatar(backgroundImage: Image.asset('assets/profile-avatar.png').image)
                        ),
                      ),
                    ),
                    title: Text(vendor.brandName.value.fold((l) => '', (r) => r))
                    ),
                  ),
                ],
              ),
            // if (vendorProfiles.isNotEmpty)
            //   const Text('Vendor Profiles'),
            // ...vendorProfiles.map((vendor) => ListTile(title: Text(vendor['vendorName'] ?? ''))),
            // if (circles.isNotEmpty)
            //   const Text('Circles'),
            // ...circles.map((circle) => ListTile(title: Text(circle['circleName'] ?? ''))),
            if (isLoading == true) Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: List.generate(4, (index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: loadingRoomItem(context),
                )),
              ),
            ),
            
            if (currentQueryResults.isEmpty && isLoading == false && currentQuery != null && currentQuery!.isNotEmpty && userProfiles.isEmpty && vendorProfiles.isEmpty) Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                      const SizedBox(height: 16),
                      Center(child: Text('No Results Found for', style: TextStyle(color: widget.model.disabledTextColor, fontSize: widget.model.questionTitleFontSize))),
                      Center(child: Text(currentQuery!, style: TextStyle(color: widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize))),
                  ],
                ),
              ),
            ),
            // const SizedBox(height: 8),
            // Divider(color: widget.model.disabledTextColor),
            // const SizedBox(height: 8),
            // if (currentQuery != null && currentQuery!.isNotEmpty) ListTile(
            //       onTap: () {
            //         setState(() {
            //           /// should update url & 
            //           // currentContainerType = ExploreContainerType.queryProfile;
            //           // _searchController.text = vendor.brandName.value.fold((l) => '', (r) => r);  
            //           _onTextChanged(currentQuery!, isSubmitted: true);
            //         });
            //         /// run search and switch main content to type queryBrowse
                    
            //       },
            //       title: Text('Tap to Search: ${currentQuery!}', style: TextStyle(fontSize: widget.model.secondaryQuestionTitleFontSize, color: widget.model.paletteColor)), 
            //       leading: Icon(Icons.search_rounded, color: widget.model.disabledTextColor,
            //     )
            //   ),
              // const SizedBox(height: 12),
          ],
        ),
      );
    }

}





//   Widget getMainContainerFromSearchType(ExploreContainerType mainContainer) {
//     final container = widget.exploreMainContainer.firstWhere(
//       (container) => container.containerType == mainContainer,
//       orElse: () => ExploreContainerModel(
//         containerType: mainContainer,
//         mainContainerWidget: const Center(
//           child: Text('No content available'),
//         ),
//         containerTitle: 'Unavailable',
//       ),
//     );
//     return container.mainContainerWidget;
//   }

// void _onTextChanged(String text, {bool isSubmitted = false}) {
//   setState(() {
//     isLoading = true;
//     currentQuery = text;
//   });
//   // Cancel any ongoing debounce if it exists
//   if (_debounce?.isActive ?? false) _debounce!.cancel();

//   // If triggered via submit, bypass the debounce and run the query immediately
//   if (isSubmitted) {
//     _performSearch(text.trim());
//     return;
//   }

//   // Otherwise, debounce the query by 3 seconds
//   _debounce = Timer(const Duration(seconds: 3), () async {
//     final query = text.trim();
//     if (query.isEmpty) {
//       setState(() {
//         _isDropdownVisible = true;
//         isLoading = false;
//       });
//       return;
//     }
//     await _performSearch(query);
//   });
// }


//   Future<void> _performSearch(String query) async {
//     try {
      
//       // final userResults = await FirebaseFirestore.instance
//       //     .collection('userProfiles')
//       //     .where('name', isGreaterThanOrEqualTo: query)
//       //     .where('name', isLessThanOrEqualTo: query + '\uf8ff')
//       //     .limit(4)
//       //     .get();

//       // final vendorResults = await FirebaseFirestore.instance
//       //     .collection('vendorProfiles')
//       //     .where('vendorName', isGreaterThanOrEqualTo: query)
//       //     .where('vendorName', isLessThanOrEqualTo: query + '\uf8ff')
//       //     .limit(4)
//       //     .get();

//       // final circleResults = await FirebaseFirestore.instance
//       //     .collection('circles')
//       //     .where('circleName', isGreaterThanOrEqualTo: query)
//       //     .where('circleName', isLessThanOrEqualTo: query + '\uf8ff')
//       //     .limit(4)
//       //     .get();

//       setState(() {
//       //   userProfiles = userResults.docs.map((doc) => doc.data()).toList();
//       //   vendorProfiles = vendorResults.docs.map((doc) => doc.data()).toList();
//       //   circles = circleResults.docs.map((doc) => doc.data()).toList();

//       // Add the current query to searchHistory if it's not already present
//       if (!_searchQueryHistory.contains(query)) {
//         _searchQueryHistory.add(query);
//       }

//         _isDropdownVisible = true; 
//         isLoading = false;
//       });
//     } catch (e) {
//       isLoading = false;
//       print("Error performing search: $e");
//     }
//   }


//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         if (_isDropdownVisible) {
//           setState(() {
//             _isDropdownVisible = false;
//           });
//         }
//       },
//       child: Scaffold(
//         backgroundColor: widget.model.webBackgroundColor,
//         appBar: Responsive.isMobile(context)
//             ? AppBar(
//                 backgroundColor: Colors.transparent,
//                 elevation: 0,
//                 scrolledUnderElevation: 0,
//                 automaticallyImplyLeading: false,
//                 centerTitle: true,
//                 toolbarHeight: 100,
//                 title: ExploreSearchFilterQueryBar(
//                   scrollController: _scrollController,
//                   initialQuery: currentQuery,
//                   onSearchQueryChanged: (query) => _onTextChanged(query),
//                   onSearchSubmitted: (query) => _onTextChanged(query, isSubmitted: true),
//                   mobileSearchView: Container(color: Colors.red),
//                   didSelectFilter: () {},
//                   webDropdownView: (query) => Container(color: Colors.blue),
//                   model: widget.model,
//                   focusNode: _searchFocusNode,
//                 ),
//               )
//             : null,
//         body: LayoutBuilder(
//           builder: (context, constraints) {
//             return Stack(
//               alignment: Alignment.topCenter,
//               children: [
//                 SingleChildScrollView(
//                   controller: _scrollController,
//                   child: getMainContainerFromSearchType(currentContainerType),
//                 ),
//                 if (!Responsive.isMobile(context)) Positioned(
//                     top: 25,
//                     child: ExploreSearchFilterQueryBar(
//                       scrollController: _scrollController,
//                       initialQuery: currentQuery,
//                       onSearchQueryChanged: (query) => _onTextChanged(query),
//                       onSearchSubmitted: (query) => _onTextChanged(query, isSubmitted: true),
//                       mobileSearchView: Container(color: Colors.red),
//                       didSelectFilter: () {},
//                       webDropdownView: (query) => Container(color: Colors.blue),
//                       model: widget.model,
//                       focusNode: _searchFocusNode,
//                     ),
//                   ),
      
//                 if (_isDropdownVisible) Positioned(
//                     top: 90,
//                     child: Focus(
//                       focusNode: _dropdownFocusNode,
//                       child: SlideInTransitionWidget(
//                         transitionWidget: Padding(
//                           padding: (Responsive.isMobile(context)) ? EdgeInsets.zero : EdgeInsets.all(8.0),
//                           child: Container(
//                               width: 800,
//                               margin: const EdgeInsets.only(top: 8.0),
//                               // height: 400,
//                               constraints: const BoxConstraints(maxWidth: 800),
//                               decoration: BoxDecoration(
//                                 color: widget.model.accentColor,
//                                 borderRadius: BorderRadius.circular(25.0),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: widget.model.disabledTextColor.withOpacity(0.35),
//                                     blurRadius: 4.0,
//                                     offset: const Offset(0, 2),
//                                   ),
//                                 ],
//                               ),
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                               child: _buildDropdownContent(currentprofileQueryList),
//                             ), 
//                           ),
//                         ),
//                         durationTime: 240,
//                         offset: const Offset(0, -0.05),
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }



//   Widget _buildDropdownContent(List<ExploreSearchQueryObject> currentQueryResults) {      

//       if (currentQuery == null || (currentQuery ?? '').isEmpty) {
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 /// overview explaining what to search or top/trending/suggested search items 
//                 const SizedBox(height: 8),
//                 Text('Trending & Suggested Search Items', style: TextStyle(fontSize: widget.model.questionTitleFontSize, color: widget.model.paletteColor)),
//               ]
//             ),
            
//             if (_searchQueryHistory.isNotEmpty) Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 8),
//                 Divider(color: widget.model.disabledTextColor),
//                 const SizedBox(height: 8),
//                 Text('Search History', style: TextStyle(fontSize: widget.model.questionTitleFontSize, color: widget.model.paletteColor)),
//                 ..._searchQueryHistory.take(7).map((history) => ListTile(
//                   onTap: () {
//                     setState(() {
//                         print(history);
//                     });
//                   },
//                   title: Text(history, style: TextStyle(fontSize: widget.model.secondaryQuestionTitleFontSize, color: widget.model.disabledTextColor)), 
//                   leading: Icon(Icons.search_rounded, color: widget.model.disabledTextColor
//                     )
//                   )
//                 ),
//               ]
//             ),
//           ],
//         );
//       }


//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // if (userProfiles.isNotEmpty)
//           //   const Text('User Profiles'),
//           // ...userProfiles.map((user) => ListTile(title: Text(user['name'] ?? ''))),
//           // if (vendorProfiles.isNotEmpty)
//           //   const Text('Vendor Profiles'),
//           // ...vendorProfiles.map((vendor) => ListTile(title: Text(vendor['vendorName'] ?? ''))),
//           // if (circles.isNotEmpty)
//           //   const Text('Circles'),
//           // ...circles.map((circle) => ListTile(title: Text(circle['circleName'] ?? ''))),
//           if (isLoading == true) Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               children: List.generate(4, (index) => Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 5.0),
//                 child: loadingRoomItem(context),
//               )),
//             ),
//           ),
          
//           if (currentQueryResults.isEmpty && isLoading == false && currentQuery != null && currentQuery!.isNotEmpty) Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Container(
//               height: 300,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                     const SizedBox(height: 16),
//                     Center(child: Text('No Results Found for', style: TextStyle(color: widget.model.disabledTextColor, fontSize: widget.model.questionTitleFontSize))),
//                     Center(child: Text(currentQuery!, style: TextStyle(color: widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize))),
//                 ],
//               ),
//             ),
//           ),
//           const SizedBox(height: 8),
//           Divider(color: widget.model.disabledTextColor),
//           const SizedBox(height: 8),
//           if (currentQuery != null && currentQuery!.isNotEmpty) ListTile(
//                 onTap: () {
//                   setState(() {
//                     /// should update url & 
//                     currentContainerType = ExploreContainerType.queryProfile;
//                   });
//                   /// run search and switch main content to type queryBrowse
                  
//                 },
//                 title: Text('Tap to Search: ${currentQuery!}', style: TextStyle(fontSize: widget.model.secondaryQuestionTitleFontSize, color: widget.model.paletteColor)), 
//                 leading: Icon(Icons.search_rounded, color: widget.model.disabledTextColor,
//               )
//             ),
//             const SizedBox(height: 12),
//         ],
//       );
//     }

// }
