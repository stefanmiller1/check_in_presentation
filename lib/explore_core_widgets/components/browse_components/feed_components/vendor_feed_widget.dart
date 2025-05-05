import 'package:beamer/beamer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_presentation/core/profile_creator_template/profile_creator_template_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_domain/domain/misc/explore_services/value_objects.dart';
import 'package:check_in_facade/check_in_facade.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:check_in_domain/domain/misc/explore_services/filter/explore_filter_item.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../template_components/explore_search_shell.dart';
import '../browse_section_widget.dart';

class VendorFeedWidget extends StatefulWidget {
  final DashboardModel model;
  final UniqueId? currentUserId;
  final ExploreFilterObject? filterModel;
  final List<EventMerchVendorPreview>? initialItems;
  final DocumentSnapshot? initialLastDoc;
  final int? initialPageKey;
  final Function(ExploreSearchQueryObject) didUpdateQueryObject;
  final Function(List<EventMerchVendorPreview> list, int pageKey, DocumentSnapshot? lastDoc) didRecieveVendorItems;

  const VendorFeedWidget({
    super.key,
    required this.model,
    this.currentUserId,
    this.filterModel,
    this.initialItems,
    this.initialPageKey,
    required this.didUpdateQueryObject,
    required this.didRecieveVendorItems,
    this.initialLastDoc,
  });

  @override
  _VendorFeedWidgetState createState() => _VendorFeedWidgetState();
}

class _VendorFeedWidgetState extends State<VendorFeedWidget> {
  late int _pageIndex = 1;
  late PagingController<int, EventMerchVendorPreview>? pagingController;
  late DocumentSnapshot? currentLastDoc;
  late bool? isLoading = false;
  late int pageSize = 10;
  bool isLoadingMore = false;

  Future<void> fetchByFilter(int pageKey) async {
    try {
      List<EventMerchVendorPreview> vendorItems = [];
      int totalFetched = 0;
      const int fetchLimit = 10;

      while (true) {
        final newItems = await MerchVenFacade.instance.getMerchVendorProfiles(
          merchType: widget.filterModel?.vendorFilter?.filterByVendorType ?? [],
          isLookingForWork: widget.filterModel?.vendorFilter?.isLookingForWork,
          limit: fetchLimit,
          startAfterDoc: currentLastDoc,
        );

        currentLastDoc = newItems.$2;
        final vendors = newItems.$1;

        if (vendors.isEmpty) {
          pagingController?.appendLastPage([]);
          widget.didRecieveVendorItems([], totalFetched, currentLastDoc);
          break;
        }

        final vendorPreview = await Future.wait(vendors.map((vendor) async {
            int weight = 0;
            try {
              final vendorProfile = await UserProfileFacade.instance.getCurrentUserProfile(userId: vendor.profileOwner.getOrCrash());

              return EventMerchVendorPreview(
                vendorToPreview: vendor,
                vendorOwnerProfile: vendorProfile,
                previewWeight: weight,
              );
            } catch (e) {
              return EventMerchVendorPreview(
                vendorToPreview: vendor,
                previewWeight: weight,
              );
            }
          }).toList()
        );

        vendorPreview.removeWhere((newItem) => pagingController?.itemList?.any((existingItem) => existingItem.vendorToPreview?.profileId == newItem.vendorToPreview?.profileId) ?? false);

        vendorItems.addAll(vendorPreview);

        totalFetched += vendors.length;

        if (vendorItems.isNotEmpty) {
          final nextPageKey = pageKey + vendorItems.length;
          pagingController?.appendPage(vendorItems, nextPageKey);
          widget.didRecieveVendorItems(vendorItems, nextPageKey, currentLastDoc);
          break;
        }

        if (currentLastDoc == null || vendors.length < fetchLimit) {
          pagingController?.appendLastPage([]);
          widget.didRecieveVendorItems([], totalFetched, currentLastDoc);
          break;
        }
      }
    } catch (e) {
      print("Error fetching vendor profiles: $e");
      pagingController?.appendLastPage([]);
      pagingController?.error = e;
    }
  }

  @override
  void initState() {
    currentLastDoc = widget.initialLastDoc;
    pagingController = PagingController(firstPageKey: widget.initialPageKey ?? widget.initialItems?.length ?? 0);

    if (widget.initialItems != null && widget.initialItems!.isNotEmpty) {
      pagingController?.appendPage(widget.initialItems!, widget.initialPageKey ?? widget.initialItems!.length);
    }

    if (mounted) {
      pagingController?.addPageRequestListener((pageKey) {
        if (pagingController?.value.status == PagingStatus.loadingFirstPage) {
          fetchByFilter(pageKey);
        }
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    pagingController?.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // getVendorProfilesMainContainer(),
        if (isLoading == true || pagingController == null) JumpingDots(color: widget.model.paletteColor, numberOfDots: 3)
        else if (MediaQuery.of(context).size.width < 410)
          buildListView(context)
        else
          buildGridView(context)
      ],
    );
    // if (isLoading == true || pagingController == null) {
    //   return JumpingDots(color: widget.model.paletteColor, numberOfDots: 3);
    // }
    // return (MediaQuery.of(context).size.width < 410) ? 
    // buildListView(context) : 
    // buildGridView(context);
  }


  /// retrieve 8 vendor profiles
  Widget getVendorProfilesMainContainer() {
    return BlocProvider(create: (_) => getIt<VendorMerchProfileWatcherBloc>()..add((const VendorMerchProfileWatcherEvent.watchAllEventMerchProfileFiltered(null, null, null, 11))),
      child: BlocBuilder<VendorMerchProfileWatcherBloc, VendorMerchProfileWatcherState>(
        builder: (context, state) {
          return state.maybeMap(
            loadAllMerchVendorFilteredListSuccess: (e) {
                      return buildGoodVendors(e.items);
            },
            orElse: () => buildGoodVendors([])
          );
        }
      )
    );
  }

  Widget buildGoodVendors(List<EventMerchantVendorProfile> vendorItems) {
    if (vendorItems.isEmpty) {
      return Container();
    }
    return BrowseSectionWidget(
        model: widget.model, 
        discoverySectionObject: BrowseSectionObject(
          hasValues: true,
          sectionTitle: 'The best Vendors in Town',
          sectionDescription: 'Preview our favourite vendors to work with',
          sectionIcon: Icons.store,
          editButtonTitle: 'Preview More Profiles',
          isLoading: isLoading ?? false,
          mainSectionWidget: Center(
            child: Container(
                height: 410,
                child: BrowseVendorMainWidget(
                    model: widget.model,
                    widgetWidth: 400,
                    widthConstraint: MediaQuery.of(context).size.width,
                    profiles: vendorItems
              )
            ),
          ),
          onEditPressed: () {}
      ),
    );
  }

  Widget buildListView(BuildContext context) {
    return Center(
      child: PagedListView<int, EventMerchVendorPreview>(
        pagingController: pagingController!,
        shrinkWrap: false,
        padding: const EdgeInsets.all(8.0),
        builderDelegate: PagedChildBuilderDelegate<EventMerchVendorPreview>(
          itemBuilder: (context, item, index) {
            _pageIndex = index;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: AspectRatio(
                aspectRatio: 0.68,
                child: itemBuilder(context, item),
              ),
            );
          },
          firstPageProgressIndicatorBuilder: (context) => emptyLargeListView(context, 10, 500, Axis.vertical, kIsWeb),
          newPageProgressIndicatorBuilder: (context) => JumpingDots(
            color: widget.model.paletteColor,
            numberOfDots: 3,
          ),
          firstPageErrorIndicatorBuilder: (context) => firstPageErrorIndicatorBuilder(),
          newPageErrorIndicatorBuilder: (context) => newPageErrorIndicatorBuilder(),
          noItemsFoundIndicatorBuilder: (context) => noItemsFoundIndicatorBuilder(),
        ),
      ),
    );
  }

  Widget buildGridView(BuildContext context) {
    return Center(
      child: PagedGridView<int, EventMerchVendorPreview>(
        pagingController: pagingController!,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(8.0),
        shrinkWrap: true,
        addAutomaticKeepAlives: true,
        addRepaintBoundaries: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: (Responsive.isMobile(context)) ? 3 : 4,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 0.68,
        ),
        builderDelegate: PagedChildBuilderDelegate<EventMerchVendorPreview>(
          itemBuilder: (context, item, index) {
            _pageIndex = index;
            return Container(
              key: ValueKey(item.vendorToPreview?.profileId.getOrCrash()),
              child: itemBuilder(context, item),
            );
          },
          firstPageProgressIndicatorBuilder: (context) => emptyLargeListView(context, 10, 500, Axis.vertical, kIsWeb),
          newPageProgressIndicatorBuilder: (context) => _buildLoadMoreButton(),
          firstPageErrorIndicatorBuilder: (context) => firstPageErrorIndicatorBuilder(),
          newPageErrorIndicatorBuilder: (context) => newPageErrorIndicatorBuilder(),
          noItemsFoundIndicatorBuilder: (context) => noItemsFoundIndicatorBuilder(),
        ),
      ),
    );
  }

  Widget _buildLoadMoreButton() {
    return Center(
      child: InkWell(
        onTap: isLoadingMore
            ? null
            : () async {
                setState(() {
                  isLoadingMore = true;
                });
                await fetchByFilter(pagingController?.nextPageKey ?? 0);
                setState(() {
                  isLoadingMore = false;
                });
              },
        child: isLoadingMore
            ? emptyLargeListView(context, 1, 500, Axis.horizontal, kIsWeb)
            : AspectRatio(
                aspectRatio: 0.68,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 500,
                      width: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: widget.model.paletteColor),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: widget.model.paletteColor,
                          ),
                          height: 50,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              'Load More..',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: widget.model.accentColor,
                                fontWeight: FontWeight.bold,
                                fontSize: widget.model.secondaryQuestionTitleFontSize,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget itemBuilder(BuildContext context, EventMerchVendorPreview item) {
    return SizedBox(
      height: 500,
      width: 300,
      child: InkWell(
        onTap: () {

          widget.didUpdateQueryObject(
            ExploreSearchQueryObject(
              exploreType: ExploreContainerType.userProfile,
              userProfileType: ProfileTypeMarker.vendorProfile,
              profileId: item.vendorToPreview?.profileOwner
            )
          );

          if (item.vendorToPreview?.profileOwner == null) return;

          Beamer.of(context).update(
            configuration: RouteInformation(
            uri: Uri.parse(searchExploreByProfileRoute(item.vendorToPreview!.profileOwner.getOrCrash(), ProfileTypeMarker.vendorProfile.name, item.vendorToPreview!.brandName.value.fold((l) => 'profile', (r) => r))),
            ),
            rebuild: false
          );
        },
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
      
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: CachedNetworkImage(
                    fadeInDuration: Duration.zero, // Disable fade-in animation
                    fadeOutDuration: Duration.zero,
                    imageUrl: (item.vendorToPreview?.uriImage?.uriPath != null) ? item.vendorToPreview!.uriImage!.uriPath! : '',
                    imageBuilder: (context, imageProvider) => Image(image: imageProvider, fit: BoxFit.cover),
                    errorWidget: (context, url, error) => Container(
                      // height: 325,
                      width: 300,
                  ),
                ),
              ),
            ),
      
            Container(
              width: MediaQuery.of(context).size.width,
              child: bottomFooterVendorDetails(
                  context,
                  widget.model,
                  item,
                Colors.grey.shade200,
                Colors.grey.shade200.withOpacity(0.75),
                Colors.black,
              )
            ),
      
          ],
        ),
      )
    );
  }

  Widget noItemsFoundIndicatorBuilder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Sorry, we couldn\'t find any',
            style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize),
          ),
          const SizedBox(height: 18),
          Text('Add Yours', style: TextStyle(color: widget.model.disabledTextColor)),
          IconButton(
            padding: EdgeInsets.zero,
            onPressed: () async {
              final Uri params = Uri(
                scheme: 'mailto',
                path: 'hello@cincout.ca',
                query: encodeQueryParameters(<String, String>{
                  'subject': 'Looking To Join The Beta! - Circle Activities',
                  'body': 'Hey! - Use my email to add me to the wait-list! - Would love to start posting markets on here.',
                }),
              );

              if (await canLaunchUrl(params)) {
                launchUrl(params);
              }
            },
            icon: Icon(CupertinoIcons.plus_circled, color: widget.model.disabledTextColor),
          ),
        ],
      ),
    );
  }

  Widget firstPageErrorIndicatorBuilder() {
    return Column(
      children: [
        Icon(Icons.keyboard_arrow_up_rounded, color: widget.model.paletteColor),
        const SizedBox(height: 8),
        Text('Oops', style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize)),
        Text('Please Select a Filter from the list above', style: TextStyle(color: widget.model.disabledTextColor)),
      ],
    );
  }

  Widget newPageErrorIndicatorBuilder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Oopps, Something Went Wrong', style: TextStyle(color: widget.model.disabledTextColor)),
          IconButton(
            onPressed: () {
              setState(() {
                pagingController?.refresh();
              });
            },
            icon: Icon(CupertinoIcons.refresh, color: widget.model.paletteColor),
          ),
        ],
      ),
    );
  }
}