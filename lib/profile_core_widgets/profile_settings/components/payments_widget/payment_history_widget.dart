import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_application/misc/watcher_services/stripe_watcher_services/stripe_payment_watcher_bloc.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:check_in_domain/domain/misc/stripe/receipt_services/receipt/receipt_pdf_generator.dart';
import 'package:check_in_facade/check_in_facade.dart';
// import 'package:webview_flutter/webview_flutter.dart';

import 'helpers.dart';

class PaymentHistoryWidget extends StatefulWidget {

  final UserProfileModel profile;
  final DashboardModel model;

  const PaymentHistoryWidget({
    super.key,
    required this.profile,
    required this.model,
  });

  @override
  State<PaymentHistoryWidget> createState() => _PaymentHistoryWidgetState();
}

class _PaymentHistoryWidgetState extends State<PaymentHistoryWidget> {

  late bool isReservationsSelected = true;
  late bool isAttendingSelected = true;

  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        titleTextStyle: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold),
        elevation: 0,
        title: Text('Payment History'),
        iconTheme: IconThemeData(
            color: widget.model.paletteColor
        ),
      ),
      body: getAllPayments(context),
      // body: BlocProvider(create: (_) => getIt<ReservationManagerWatcherBloc>()..add(ReservationManagerWatcherEvent.watchCurrentUsersReservations([ReservationSlotState.confirmed, ReservationSlotState.completed, ReservationSlotState.current], widget.profile, false, null, null)),
      //     child: BlocBuilder<ReservationManagerWatcherBloc, ReservationManagerWatcherState>(
      //       builder: (context, state) {
      //         return state.maybeMap(
      //             resLoadInProgress: (_) => JumpingDots(numberOfDots: 3, color: widget.model.paletteColor),
      //             loadCurrentUserReservationsSuccess: (e) => getAllPayments(context, e.item),
      //             loadCurrentUserReservationsFailure: (_) => getAllPayments(context, []),
      //             ///TODO: add failure of type empty
      //             /// if network call cant be made you should not be allowed to make any new reservation
      //             orElse: () => getAllPayments(context, [])
      //       );
      //     },
      //   )
      // )
    );
  }




  Widget getAllPayments(BuildContext context) {
    return BlocProvider(create: (_) => getIt<StripePaymentWatcherBloc>()..add(StripePaymentWatcherEvent.watchAllPaymentIntentHistory(widget.profile.stripeCustomerId ?? '')),
      child: BlocBuilder<StripePaymentWatcherBloc, StripePaymentWatcherState>(
        builder: (context, state) {
          return state.maybeMap(
              loadInProgress: (_) => JumpingDots(numberOfDots: 3, color: widget.model.paletteColor),
              loadAllPaymentIntentsFailure: (_) => noItemsFound(
                  widget.model,
                  Icons.calendar_today_outlined,
                  'No Reservations Yet!',
                  'Start a Pop-Up Shop in your backyard or Rent out a basement for your next underground Rave.',
                  'Start or Join a Booking',
                  didTapStartButton: () {
                }
              ),
              loadAllPaymentIntentsSuccess: (items) {
                return retrievePaymentHistory(context, items.paymentIntent);
              },
              orElse: () => noItemsFound(
                  widget.model,
                  Icons.calendar_today_outlined,
                  'No Reservations Yet!',
                  'Start a Pop-Up Shop in your backyard or Rent out a basement for your next underground Rave.',
                  'Start or Join a Booking',
                  didTapStartButton: () {

              }
            )
          );
        },
      ),
    );
  }

  Widget retrievePaymentHistory(BuildContext context, List<PaymentIntent> paymentHistory) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          children: [
            Wrap(
              spacing: 6.0,
              runSpacing: 3.0,
              children: [
                if (paymentHistory.any((payment) => payment.metaData?['activityId'] != null)) _buildToggleableContainer(
                  'Attended',
                  isAttendingSelected, () {
                    setState(() {
                      isAttendingSelected = !isAttendingSelected;
                      isReservationsSelected = false;
                    });
                   }
                 ),
                if (paymentHistory.map((e) => e.metaData?.keys).contains('listingId')) _buildToggleableContainer(
                    'Reservation',
                    isReservationsSelected, () {
                     setState(() {
                       isReservationsSelected = !isReservationsSelected;
                       isAttendingSelected = false;
                    });
                  }
                ),
              ],
            ),
            SingleChildScrollView(
              child: Column(
              children: [

                const SizedBox(height: 12),
                if (paymentHistory.isNotEmpty) Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...paymentHistory.map(
                            (p) {
                    //         if (reservations.isNotEmpty && reservations.map((e) => e.reservationId.getOrCrash()).contains(p.metaData?['activityId'])) {
                    //           // if (listing.isNotEmpty && listing.map((e) => e.listingServiceId.getOrCrash()).contains(p.metaData?['listingId'])) {
                    //             return getPaymentHistoryItemWidget(
                    //               context,
                    //               widget.model,
                    //               p,
                    //               listing.firstWhere((element) => element.listingServiceId.getOrCrash() == p.metaData?['listingId']),
                    //               reservations.firstWhere((element) => element.reservationId.getOrCrash() == p.metaData?['activityId']),
                    //               didSelectPayment: (payment) {
                    //
                    //                 if (payment.receipt_url != null) {
                    //                   Navigator.of(context).push(
                    //                       MaterialPageRoute(builder: (_) {
                    //                         return WebViewWidgetComponent(
                    //                           urlString: payment.receipt_url!,
                    //                           model: widget.model,
                    //                       );
                    //                     })
                    //                   );
                    //                 }
                    //               }
                    //             );
                    //           // }
                    //         } else {
                    //           return getPaymentHistoryOnly(
                    //               context,
                    //               widget.model,
                    //               p,
                    //               didSelectPayment: (payment) {
                    //
                    //             }
                    //           );
                    //         }
                          return getPaymentHistoryOnly(
                              context,
                              widget.model,
                              p,
                              didSelectPayment: (payment) async {

                                // get activity form

                                try {

                                  final activityForm = await ActivitySettingsFacade.instance.getActivitySettings(reservationId: p.metaData!['activityId']);
                                  final reservationForm = await ReservationFacade.instance.getReservationItem(resId: p.metaData!['activityId']);
                                  // get activity owner profile
                                  final activityOwner = await UserProfileFacade.instance.getCurrentUserProfile(userId: reservationForm.reservationOwnerId.getOrCrash());
                                  // get attendee profile
                                  final attendee = await AttendeeFacade.instance.getAttendeeItemForActivity(activityId: p.metaData!['activityId'], userId: widget.profile.userId.getOrCrash());
                                  // get vendor profile_from_attendee_id
                                  if (attendee.eventMerchantVendorProfile != null && activityOwner != null) {
                                    final vendorProfile = await MerchVenFacade.instance.getMerchVendorProfile(profileId: attendee.eventMerchantVendorProfile!.getOrCrash());

                                    if (vendorProfile != null) {
                                      // final invoiceNumber = await AttendeeFacade.instance.getNumberOfAttending(attendeeOwnerId: attendee.attendeeOwnerId.getOrCrash(), status: ContactStatus.joined, attendingType: AttendeeType.vendor, isInterested: null) ?? 1;
                                      final receiptPdf = await generateReceiptPdf(activityForm, activityOwner, widget.profile, vendorProfile, attendee, 0);

                                      final receiptDoc = [
                                        DocumentFormOption(
                                            documentForm: ImageUpload(
                                                key: '',
                                                imageToUpload: receiptPdf
                                            )
                                        )
                                      ];

                                      showSelectedDocumentButton(
                                          context,
                                          widget.model,
                                          receiptDoc
                                      );

                                    }
                                  } else {
                                    final snackBar = SnackBar(
                                        backgroundColor: widget.model.webBackgroundColor,
                                        content: Text('sorry, something went wrong', style: TextStyle(color: widget.model.disabledTextColor))
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  }

                                } catch (e) {

                                }


                          }
                        );
                      }
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildToggleableContainer(String text, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(35),
            border: isSelected
                ? Border.all(color: widget.model.paletteColor, width: 2) // Black border when selected
                : null,
          ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            decoration: BoxDecoration(
              color: widget.model.accentColor,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Text(
              text,
              style: TextStyle(
                color: (isSelected) ? widget.model.paletteColor : widget.model.disabledTextColor, // Text color
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}