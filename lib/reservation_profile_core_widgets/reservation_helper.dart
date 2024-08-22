// import 'package:check_in_domain/check_in_domain.dart';
// import 'package:check_in_domain/domain/auth/reservation_manager/post.dart';
// import 'package:check_in_domain/domain/auth/reservation_manager/reservation_post/system_post.dart';
// import 'package:check_in_presentation/check_in_presentation.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:check_in_facade/auth/notification_facade/notification_core_config.dart';
// import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
// import 'package:check_in_facade/check_in_facade.dart';
part of check_in_presentation;


class ReservationCoreHelper {

  static ResOverViewTabs resOverViewTabs = ResOverViewTabs.discussion;
  static late bool showSuggestions = true;
  static late PageController? pageController = null;
  static int currentTabPageIndex = 0;

  static late PagingController<int, ReservationPreviewer>? pagingController = null;
  static const _pageSize = 15;

  static Future<void> fetchByCompleted(BuildContext context, List<ReservationSlotState> statusType, bool? isActivivty, String currentUserId, int pageKey) async {
    try {

      List<ReservationPreviewer> activityItems = [];
      if (facade.ReservationFacade.instance.lastDoc != null) {
        final newItems = await facade.ReservationFacade.instance.getAllReservations(
            statusType: statusType,
            hoursTimeAhead: null,
            hoursTimeBefore: null,
            isActivity: isActivivty,
            isLookingForVendor: null,
            userId: currentUserId,
            limit: _pageSize,
            startAfterDoc: facade.ReservationFacade.instance.lastDoc
        );
        facade.ReservationFacade.instance.lastDoc = newItems.$2;
        activityItems = await getReservationPreviewData(newItems.$1);
      } else {
        final newItems = await facade.ReservationFacade.instance.getAllReservations(
            statusType: statusType,
            hoursTimeAhead: null,
            hoursTimeBefore: null,
            isActivity: isActivivty,
            isLookingForVendor: null,
            userId: currentUserId,
            limit: _pageSize,
            startAfterDoc: null
        );
        facade.ReservationFacade.instance.lastDoc = newItems.$2;
        activityItems = await getReservationPreviewData(newItems.$1);
      }

      if (activityItems.isNotEmpty && (pagingController?.itemList?.map((e) => e.reservation?.reservationId).contains(activityItems.first.reservation?.reservationId) ?? false)) {
          pagingController?.appendLastPage([]);
        return;
      } else {
        final nextPageKey = pageKey + activityItems.length;
         pagingController?.appendPage(activityItems, nextPageKey);
      }

    } catch (error) {
        print('eeerrr ${error}');
        pagingController?.error = error;
    }
  }

  static Future<List<ReservationPreviewer>> getReservationPreviewData(List<ReservationItem> reservations) async {
    late List<ReservationPreviewer> resToPreview = [];

    for (ReservationItem reservationItem in reservations) {

      ReservationPreviewer resPreview = ReservationPreviewer(
          reservation: reservationItem,
          previewWeight: 0,
      );

      try {
        final reservationOwnerProfile = await facade.UserProfileFacade.instance.getCurrentUserProfile(userId: reservationItem.reservationOwnerId.getOrCrash());
        resPreview = resPreview.copyWith(
          reservationOwnerProfile: reservationOwnerProfile
        );

      } catch (e) {
        Future.error(e);
      }

      try {

        final listingManagerForm = await facade.ListingFacade.instance.getListingManagerItem(listingId: reservationItem.instanceId.getOrCrash());
        resPreview = resPreview.copyWith(
          listing: listingManagerForm
        );

      } catch (e) {
        Future.error(e);
      }

      try {
        final activityManagerForm = await facade.ActivitySettingsFacade.instance
            .getActivitySettings(
            reservationId: reservationItem.reservationId.getOrCrash()
        );
        resPreview = resPreview.copyWith(
            activityManagerForm: activityManagerForm
        );

      } catch (e) {
        Future.error(e);
      }


      resToPreview.add(resPreview);
    }

    /// order from highest weight to smallest
    return resToPreview;
  }

  static Future<List<ReservationPreviewer>> getAttendingReservationFeed(List<UniqueId> reservationIds) async {
    List<ReservationPreviewer> resToPreview = [];
    resToPreview.clear();

    for (UniqueId reservationId in reservationIds) {
      try {
        // Fetch reservation details
        final reservationItem = await facade.ReservationFacade.instance.getReservationItem(resId: reservationId.getOrCrash());
        if (reservationItem == null) {
          continue; // Skip to the next reservation if item is null
        }

        // Process reservation details and add to list
        ReservationPreviewer resPreview = ReservationPreviewer(
          reservation: reservationItem,
          previewWeight: 0, // Example weight, modify as needed
        );

        // Additional data fetching and processing
        try {
          final listingManagerForm = await facade.ListingFacade.instance.getListingManagerItem(listingId: reservationItem.instanceId.getOrCrash());
          resPreview = resPreview.copyWith(listing: listingManagerForm);
        } catch (e) {
          print('Error fetching listing: $e');
        }

        try {
          final reservationOwnerProfile = await facade.UserProfileFacade.instance.getCurrentUserProfile(userId: reservationItem.reservationOwnerId.getOrCrash());
          resPreview = resPreview.copyWith(reservationOwnerProfile: reservationOwnerProfile);
        } catch (e) {
          print('Error fetching owner profile: $e');
        }

        try {
          final activityManagerForm = await facade.ActivitySettingsFacade.instance.getActivitySettings(reservationId: reservationItem.reservationId.getOrCrash());
          resPreview = resPreview.copyWith(activityManagerForm: activityManagerForm);
        } catch (e) {
          print('Error fetching activity settings: $e');
        }

        resToPreview.add(resPreview);
      } catch (e) {
        print('Error processing reservation: $e');
      }
    }
    return resToPreview;
  }


}



/// tab items for top tab controller
List<TabBadge> tabItems(List<AccountNotificationItem> notifications) {
  final List<TabBadge> tabs = [];

  for (ResOverViewTabs tab in ResOverViewTabs.values) {
    if (tab == ResOverViewTabs.activity) {
      tabs.add(TabBadge(notifications.where((element) => element.notificationType == AccountNotificationType.activity).isNotEmpty, notifications.where((element) => element.notificationType == AccountNotificationType.activity).length.toString(), tab.name.toString(), tab));
    } else if (tab == ResOverViewTabs.discussion) {
      tabs.add(TabBadge(notifications.where((element) => element.notificationType == AccountNotificationType.activityPost).isNotEmpty, notifications.where((element) => element.notificationType == AccountNotificationType.activityPost).length.toString(), tab.name.toString(), tab));
    } else if (tab == ResOverViewTabs.reservation) {
      tabs.add(TabBadge(notifications.where((element) => element.notificationType == AccountNotificationType.reservation).isNotEmpty, notifications.where((element) => element.notificationType == AccountNotificationType.reservation).length.toString(), tab.name.toString(), tab));
    }
  }
  return tabs;
}

Widget loadReservations(BuildContext context) {
  return Shimmer.fromColors(
      baseColor: Colors.grey.shade400,
      highlightColor: Colors.grey.shade100,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
            ),
            height: 25,
            width: MediaQuery.of(context).size.width,
          ),
          SizedBox(height: 15),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
            ),
            height: 100,
            width: MediaQuery.of(context).size.width,
          ),
          SizedBox(height: 15),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
            ),
            height: 100,
            width: MediaQuery.of(context).size.width,
          ),
          SizedBox(height: 15),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
            ),
            height: 100,
            width: MediaQuery.of(context).size.width,
        ),
      ]
    ),
  );
}



void updateNotifications(BuildContext context, DashboardModel model, ResOverViewTabs tab, List<AccountNotificationItem> notifications) {

  switch (tab) {
    case ResOverViewTabs.activity:
      facade.LocalNotificationCore.updateNotificationToRead(context, notifications.where((e) =>
      e.notificationType == AccountNotificationType.activity).map((e) => e.notificationId).toList(),
          model.paletteColor,
          model.accentColor
      );
      break;
    case ResOverViewTabs.reservation:
      facade.LocalNotificationCore.updateNotificationToRead(context, notifications.where((e) =>
      e.notificationType == AccountNotificationType.reservation).map((e) => e.notificationId).toList(),
          model.paletteColor,
          model.accentColor
      );
      break;
    case ResOverViewTabs.discussion:
      facade.LocalNotificationCore.updateNotificationToRead(context, notifications.where((e) =>
          e.notificationType == AccountNotificationType.activityPost).map((e) => e.notificationId).toList(),
          model.paletteColor,
          model.accentColor
      );
      break;
  }
}



List<Post> retrieveSystemMessages(ReservationItem reservation, UniqueId currentUser) {
  List<Post> systemMessage = [];

    for (ReservationSlotItem resSlot in reservation.reservationSlotItem) {
      for (ReservationTimeFeeSlotItem slot in resSlot.selectedSlots) {
        if (slot.slotRange.start.isBefore(DateTime.now())) {
          systemMessage.add(Post(
              id: slot.slotRange.start.millisecondsSinceEpoch.toString(),
              createdAt: slot.slotRange.start,
              authorId: currentUser,
              systemPost: SystemPost(
                text: 'The ${DateFormat.jm().format(slot.slotRange
                    .start)} Reservation is aAbout to begin, if you have any issues you can contact the owner here.'
              ),
            type: PostType.system
        ));
      }
    }
  }

  return systemMessage;
}