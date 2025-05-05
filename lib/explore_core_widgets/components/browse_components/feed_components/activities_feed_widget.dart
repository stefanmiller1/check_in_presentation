import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_facade/check_in_facade.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:check_in_domain/domain/misc/explore_services/filter/explore_filter_item.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ActivitiesFeedWidget extends StatefulWidget {

  final DashboardModel model;
  final UniqueId? currentUserId;
  final ExploreFilterObject? filterModel;
  final List<ReservationPreviewer>? initialItems; 
  final DocumentSnapshot? initialLastDoc; // itial list of items
  final int? initialPageKey; 
  final Function(List<ReservationPreviewer> list, int pageKey, DocumentSnapshot? lastDoc) didRecieveActivityItems;

  const ActivitiesFeedWidget({super.key, required this.model, this.currentUserId, this.filterModel, this.initialItems, this.initialPageKey, required this.didRecieveActivityItems, this.initialLastDoc });

  @override
  _ActivitiesFeedWidgetState createState() => _ActivitiesFeedWidgetState();
}


class _ActivitiesFeedWidgetState extends State<ActivitiesFeedWidget> {


  late int _pageIndex = 1;
  late PagingController<int, ReservationPreviewer>? pagingController;
  late DocumentSnapshot? currentLastDoc;
  late bool? isLoading = false;
  late int pageSize = 10;
  bool isLoadingMore = false;

  Future<void> fetchByFilter(int pageKey) async {
    try {
    List<ReservationPreviewer> activityItems = [];
    int totalFetched = 0; // Track the total items fetched
    const int fetchLimit = 10; // Number of items per page

    // Continue querying until reservations are found or no more data exists
    while (true) {
      final newItems = await ReservationFacade.instance.getAllReservations(
        statusType: widget.filterModel?.activitiesFilter?.filterBySlotType ?? [],
        hoursTimeAhead: widget.filterModel?.activitiesFilter?.filterWithStartDate,
        hoursTimeBefore: widget.filterModel?.activitiesFilter?.filterWithEndDate,
        isActivity: true,
        isPrivate: null,
        reverseOrder: widget.filterModel?.activitiesFilter?.reverseOrder,
        isLookingForVendor: widget.filterModel?.activitiesFilter?.isLookingForVendors,
        limit: fetchLimit,
        startAfterDoc: currentLastDoc, // Pagination cursor
        userId: null,
      );

      currentLastDoc = newItems.$2; // Update pagination cursor
      final reservations = newItems.$1;

      if (reservations.isEmpty) {
        // No more data to fetch
        pagingController?.appendLastPage([]);
        widget.didRecieveActivityItems([], totalFetched, currentLastDoc);
        break;
      }

      final int? startMonth = widget.filterModel?.activitiesFilter?.dateRangeFilter?.start.month ?? 1;
      final int? endMonth = widget.filterModel?.activitiesFilter?.dateRangeFilter?.end.month ?? 12;

      // Filter reservations by month, based on firstSlotTimestamp
      final filteredItems = reservations.where((reservation) {
        if (reservation.reservationSlotItem.isEmpty) return false;
        final firstSlotTimestamp =  retrieveTimeStampForFirstTimeSlot(reservation.reservationSlotItem);
        final reservationMonth = DateTime.fromMillisecondsSinceEpoch(firstSlotTimestamp).month;

        // Check if reservationMonth falls within the date range
        if (startMonth != null && endMonth != null) {
          return reservationMonth >= startMonth && reservationMonth <= endMonth;
        }

        return false; 
      }).toList();

      activityItems.addAll(
        await getActivitiesWithoutWeight(filteredItems),
      );

      totalFetched += filteredItems.length;

      if (activityItems.isNotEmpty) {
        // Matching items found, append and break the loop
        final nextPageKey = pageKey + activityItems.length;
        pagingController?.appendPage(activityItems, nextPageKey);
        widget.didRecieveActivityItems(activityItems, nextPageKey, currentLastDoc);
        break;
      }

      // If no more documents to fetch, mark it as the last page
      if (currentLastDoc == null || reservations.length < fetchLimit || (pagingController?.itemList?.map((e) => e.reservation?.reservationId).contains(activityItems.first.reservation?.reservationId) ?? false)) {
        pagingController?.appendLastPage([]);
        widget.didRecieveActivityItems([], totalFetched, currentLastDoc);
        break;
      }
    }
  } catch (e) {
    print("Error fetching reservations: $e");
    pagingController?.appendLastPage([]);
    pagingController?.error = e;
  }

    
    // try {

    //   List<ReservationPreviewer> activityItems = [];

    //   if (currentLastDoc != null) {
    //       final newItems = await ReservationFacade.instance.getAllReservations(
    //         statusType: widget.filterModel?.activitiesFilter?.filterBySlotType ?? [], 
    //         hoursTimeAhead: widget.filterModel?.activitiesFilter?.filterWithStartDate, 
    //         hoursTimeBefore: widget.filterModel?.activitiesFilter?.filterWithEndDate, 
    //         isActivity: true, 
    //         limit: pageSize, 
    //         isLookingForVendor: widget.filterModel?.activitiesFilter?.isLookingForVendors,
    //          userId: null, 
    //          startAfterDoc: currentLastDoc!
    //       );
    //       currentLastDoc = newItems.$2;

    //       activityItems = await getActivitiesWithoutWeight(newItems.$1);
    //       //  newItems.$1.map((e) => ReservationPreviewer(reservation: e, previewWeight: 0)).toList();

    //   } else {
    //     final newItems = await ReservationFacade.instance.getAllReservations(
    //         statusType: widget.filterModel?.activitiesFilter?.filterBySlotType ?? [],
    //         hoursTimeAhead: widget.filterModel?.activitiesFilter?.filterWithStartDate,
    //         hoursTimeBefore: widget.filterModel?.activitiesFilter?.filterWithEndDate,
    //         isActivity: true,
    //         isLookingForVendor: widget.filterModel?.activitiesFilter?.isLookingForVendors,
    //         limit: pageSize,
    //         startAfterDoc: null,
    //         userId: null
    //     );
    //     currentLastDoc = newItems.$2;
    //     activityItems = await getActivitiesWithoutWeight(newItems.$1);
    //     // newItems.$1.map((e) => ReservationPreviewer(reservation: e, previewWeight: 0)).toList();
    //     //  await getActivitiesInOrderOfWeight(newItems.$1);
    //   }

    //   if (activityItems.isNotEmpty && (pagingController?.itemList?.map((e) => e.reservation?.reservationId).contains(activityItems.first.reservation?.reservationId) ?? false)) {
    //     pagingController?.appendLastPage([]);
    //     widget.didRecieveActivityItems(activityItems, activityItems.length, currentLastDoc);
    //     return;
    //   } else {
    //     final nextPageKey = pageKey + activityItems.length;
    //     pagingController?.appendPage(activityItems, nextPageKey);
    //     widget.didRecieveActivityItems(activityItems, nextPageKey, currentLastDoc);
    //   }

    // } catch (e) {
    //   print(e);
    //   pagingController?.error = e;
    // }
  }



  @override
  void initState() {
    currentLastDoc = widget.initialLastDoc;
    pagingController = PagingController(firstPageKey: widget.initialPageKey ?? widget.initialItems?.length ?? 0);  
    
    if (widget.initialItems != null && widget.initialItems!.isNotEmpty) {
      pagingController?.appendPage(widget.initialItems!, widget.initialPageKey ?? widget.initialItems!.length);
    }
    
    if (mounted) {
      // pagingController?.addStatusListener(listener)
      pagingController?.addPageRequestListener((pageKey) {
          // if (pageKey == 5 && pagingController?.itemList?.isNotEmpty == true) return;
          if (pagingController?.value.status == PagingStatus.loadingFirstPage) {
            fetchByFilter(pageKey);
          } 
      });
      
    }
    super.initState();
  }

  @override
  void dispose() {
    // pagingController?.dispose();
    // pagingController?.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
      if (isLoading == true || pagingController == null) {
        return JumpingDots(color: widget.model.paletteColor, numberOfDots: 3);
      }
    return (MediaQuery.of(context).size.width < 410) ? buildListView(context) : buildGridView(context);
  }


  Widget buildListView(BuildContext context) {
    return Center(
      child: PagedListView<int, ReservationPreviewer>(
        pagingController: pagingController!,
        shrinkWrap: false,
        padding: const EdgeInsets.all(8.0),
        builderDelegate: PagedChildBuilderDelegate<ReservationPreviewer>(
          itemBuilder: (context, item, index) {
            _pageIndex = index;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: AspectRatio(
                aspectRatio: 0.68,
                child: itemBuilder(context, item)),
            );
          },
          firstPageProgressIndicatorBuilder: (context) => emptyLargeListView(context, 10, 500, Axis.vertical, kIsWeb),
          newPageProgressIndicatorBuilder: (context) => JumpingDots(
            color: widget.model.paletteColor,
            numberOfDots: 3,
          ),
          firstPageErrorIndicatorBuilder: (context) => firstPageErrorIndicatorBuilder(),
          newPageErrorIndicatorBuilder: (context) => newPageErrorIndicatorBuilder(),
          noItemsFoundIndicatorBuilder: (context) => noItemsFoundIndicatorBuilder()
        // )
        ),
      )
    );
  }

  Widget buildGridView(BuildContext context) {
    return Center(
          child: PagedGridView<int, ReservationPreviewer>(
            pagingController: pagingController!,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(8.0),
            shrinkWrap: true,
            addAutomaticKeepAlives: true,
            addRepaintBoundaries: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: (Responsive.isMobile(context)) ? 3 : 4, // 3 items per row
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: 0.68, // Adjust based on desired item dimensions
            ),
            // cacheExtent: MediaQuery.of(context).size.height * -20,
            builderDelegate: PagedChildBuilderDelegate<ReservationPreviewer>(
              itemBuilder: (context, item, index) {
              _pageIndex = index;
        
              return Container(
                key: ValueKey(item.reservation?.reservationId.getOrCrash()),
                child: itemBuilder(context, item)
                );
            },
            firstPageProgressIndicatorBuilder: (context) => emptyLargeListView(context, 10, 500, Axis.vertical, kIsWeb),
            newPageProgressIndicatorBuilder: (context) => _buildLoadMoreButton(),
            //  JumpingDots(
            //   color: widget.model.paletteColor,
            //   numberOfDots: 3,
            // ),
            firstPageErrorIndicatorBuilder: (context) => firstPageErrorIndicatorBuilder(),
            newPageErrorIndicatorBuilder: (context) => newPageErrorIndicatorBuilder(),
            noItemsFoundIndicatorBuilder: (context) => noItemsFoundIndicatorBuilder()
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
                            border: Border.all(color: widget.model.paletteColor)
                                  ),
                                ),
                          Positioned(
                            bottom: 0,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: widget.model.paletteColor
                                  ),
                                  // width: 300,
                                  height: 50,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Text('Load More..', textAlign: TextAlign.center, style: TextStyle(color: widget.model.accentColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                                  )
                              ),
                            ),
                          ),
                    ],
                  )
        )
      ),
    );
  }


  Widget itemBuilder(BuildContext context, ReservationPreviewer item) {
    return SizedBox(
            height: 500,
            width: 300,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: CachedNetworkImage(
                fadeInDuration: Duration.zero, // Disable fade-in animation
                fadeOutDuration: Duration.zero,
                imageUrl: item.activityManagerForm?.profileService.activityBackground.activityProfileImages?.first.uriPath ?? '',
                imageBuilder: (context, imageProvider) => Image(image: imageProvider, fit: BoxFit.cover),
                errorWidget: (context, url, error) => getActivityTypeTabOption(
                    context,
                    widget.model,
                    500,
                    false,
                    getActivityOptions().firstWhere((element) => element.activityId == item.reservation?.reservationSlotItem.first.selectedActivityType)
                )
              ),
            )
          );
    // return getReservationMediaFrameFlexible(
    //         context,
    //         widget.model,
    //         500,
    //         500,
    //         item.listing,
    //         item.activityManagerForm,
    //         item.reservation!,
    //         false,
    //         didSelectItem: () {
    //           // widget.didSelectReservation(item);
    //         },
    //       );
      
    //   return baseSearchItemContainer(
    //       width: 500,
    //       height: 500,
    //       model: widget.model,
    //       isSelected: false,
    //       backgroundWidget: getReservationMediaFrameFlexible(
    //         context,
    //         widget.model,
    //         500,
    //         500,
    //         item.listing,
    //         item.activityManagerForm,
    //         item.reservation!,
    //         false,
    //         didSelectItem: () {
    //           // widget.didSelectReservation(item);
    //         },
    //       ),
    //       bottomWidget: getSearchFooterWidget(
    //         context,
    //         widget.model,
    //         widget.currentUserId,
    //         widget.model.paletteColor,
    //         widget.model.disabledTextColor,
    //         widget.model.accentColor,
    //         item,
    //         false,
    //         didSelectItem: () {
    //           // widget.didSelectReservation(item);
    //         },
    //         didSelectInterested: () {
    //           // Handle interested action
    //         },
    //       ),
    //     );

    // return getActivityResultsWidget(
    //       context,
    //       widget.model,
    //       widget.currentUserId,
    //       item,
    //       didSelectItem: () {
    //           if (item.reservation != null) {
    //             Navigator.of(context).push(MaterialPageRoute(
    //                 builder: (_) {
    //                   return ActivityPreviewScreen(
    //                     model: widget.model,
    //                     listing: null,
    //                     reservation: item.reservation,
    //                     currentReservationId: item.reservation!.reservationId,
    //                     currentListingId: item.reservation!.instanceId,
    //                     didSelectBack: () {},
    //               );
    //             }
    //           )
    //         );
    //       }
    //     },
    //     didSelectInterested: () {
    //         if (widget.currentUserId != null) {
    //       setState(() {
    //         // _selectedItem = item.reservation?.reservationId;
    //         // CircleFeedHelperCore.isLoadingInterested = true;
    //         // context.read<CircleActivitiesMainBloc>().add(CircleActivitiesMainEvent.didFinishSelectingInterested(item.reservation!.reservationId.getOrCrash(), widget.currentUserId!.getOrCrash()));


    //         Future.delayed(const Duration(seconds: 3), () {
    //           setState(() {
    //             // CircleFeedHelperCore.isLoadingInterested = false;
    //           });
    //         });
    //       });
    //     } else {

    //     }
    //   }
    // );
  }

  Widget noItemsFoundIndicatorBuilder() {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Sorry, we couldn\'t find any', style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize)),
            const SizedBox(height: 18),
            Text('Add Yours', style: TextStyle(color: widget.model.disabledTextColor)),
            IconButton(
                padding: EdgeInsets.zero,
                onPressed: () async {
                    final Uri params = Uri(
                      scheme: 'mailto',
                      path: 'hello@cincout.ca',
                      query: encodeQueryParameters(<String, String>{
                        'subject':'Looking To Join The Beta! - Circle Activities',
                        'body': 'Hey! - Use my email to add me to the wait-list! - Would love to start posting markets on here.'
                      }),
                    );

                    if (await canLaunchUrl(params)) {
                    launchUrl(params);
                  }
              },
            icon: Icon(CupertinoIcons.plus_circled, color: widget.model.disabledTextColor)
          )
        ],
      )
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
              icon: Icon(CupertinoIcons.refresh, color: widget.model.paletteColor)
            )
          ],
        )
    );
  }
}