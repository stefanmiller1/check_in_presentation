part of check_in_presentation;

class GeneralProfileWidget extends StatefulWidget {

  final UserProfileModel currentUser;
  final bool isOwner;
  final DashboardModel model;
  final List<ListingManagerForm> facilities;
  final List<ReservationItem> reservations;
  final List<AttendeeItem> attending;

  const GeneralProfileWidget({super.key,
    required this.currentUser,
    required this.isOwner,
    required this.model,
    required this.reservations,
    required this.facilities,
    required this.attending,
  });

  @override
  State<GeneralProfileWidget> createState() => _GeneralProfileWidgetState();
}

class _GeneralProfileWidgetState extends State<GeneralProfileWidget> {

  @override
  Widget build(BuildContext context) {
    return getMainReviewProfile(context, widget.model, widget.facilities, widget.reservations);
  }

  /// show joined, hosted & posted
  /// (for empty post container) if you want to be able to post - join the beta as an organizer & help us


  /// show all joined
  Widget getAllCircleCommunities() {
    return Container();
  }

  Widget getMainReviewProfile(BuildContext context, DashboardModel model, List<ListingManagerForm> listings, List<ReservationItem> reservations) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: 750,
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: widget.model.accentColor,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: profileHeaderContainer(
                                    widget.currentUser,
                                    model,
                                    widget.currentUser.userId.getOrCrash() == facade.FirebaseChatCore.instance.firebaseUser?.uid,
                                    listings.length,
                                    reservations.length,
                                    attendeesOnlyList(widget.attending).length,
                                    editProfile: () {

                                  }
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Divider(color: model.disabledTextColor),
                          const SizedBox(height: 18),
                          verificationsAndConfirmations(model, widget.currentUser),
                          const SizedBox(height: 18),
                          Divider(color: model.disabledTextColor),
                          const SizedBox(height: 18),
                          // VendorProfileSection(
                          //     model: model,
                          //     vendorProfile: [],
                          // ),
                          // Container(
                          //     decoration: BoxDecoration(
                          //       borderRadius: BorderRadius.circular(20),
                          //       color: widget.model.mobileBackgroundColor.withOpacity(0.35),
                          //     ),
                          //     child: Padding(
                          //       padding: const EdgeInsets.all(15.0),
                          //       child: getHostingListings(context, widget.currentUser, listings, model),
                          //   )
                          // ),
                          // const SizedBox(height: 18),
                          // Divider(color: model.disabledTextColor),
                          // const SizedBox(height: 18),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: widget.model.webBackgroundColor,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: getUpComingReservations(context,
                                  widget.currentUser,
                                  null,
                                  reservations,
                                  model,
                                  didSelectResDetail: (model, listing, reservation, isResOwner, isFromChat, currentUser) {

                                  },
                                  didSelectReservation: (listing, reservation) {

                                }
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),

              const SizedBox(height: 32),


            ],
          ),
        ),
      ),
    );
  }
}