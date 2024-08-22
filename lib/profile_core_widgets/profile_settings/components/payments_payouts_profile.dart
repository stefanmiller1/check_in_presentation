import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'payments_widget/payment_history_widget.dart';
import 'payments_widget/payout_history_widget.dart';
import 'payments_widget/payout_payment_methods_widget.dart';

class PaymentsPayoutsProfile extends StatefulWidget {

  final DashboardModel model;
  final UserProfileModel profile;
  final bool isActivityVersion;

  const PaymentsPayoutsProfile({super.key, required this.model, required this.profile, required this.isActivityVersion});

  @override
  State<PaymentsPayoutsProfile> createState() => _PaymentsPayoutsProfileState();
}

class _PaymentsPayoutsProfileState extends State<PaymentsPayoutsProfile> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: widget.model.mobileBackgroundColor,
      appBar: (kIsWeb) ? null : AppBar(
        automaticallyImplyLeading: (kIsWeb == false),
        backgroundColor: Colors.transparent,
        titleTextStyle: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold),
        elevation: 0,
        title: Text('Edit Profile'),
        iconTheme: IconThemeData(
            color: widget.model.paletteColor
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 35),
              Text('Reservations', style: TextStyle(color: widget.model.paletteColor,
                  fontSize: widget.model.secondaryQuestionTitleFontSize,
                  fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              ...paymentSettingsList().map(
                  (e) => profilePaymentSettingItemWidget(
                    widget.model,
                    e,
                    didSelectItem: (f) {
                      switch (f) {
                        case ProfilePaymentMarker.paymentMethods:
                          if (kIsWeb) {
                            showGeneralDialog(
                              context: context,
                              barrierDismissible: false,
                              barrierLabel: 'Payment Methods',
                              transitionDuration: Duration(milliseconds: 350),
                              pageBuilder: (BuildContext contexts, anim1, anim2) {
                                return  Align(
                                    alignment: Alignment.center,
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.all(Radius.circular(25)),
                                        child: Container(
                                            decoration: BoxDecoration(
                                                color: widget.model.accentColor,
                                                borderRadius: BorderRadius.all(Radius.circular(17.5))
                                            ),
                                            width: 550,
                                            height: 750,
                                            child: PaymentMethodsWidget(
                                              model: widget.model,
                                              isPushedView: true,
                                              didSelectPaymentMethod: (card) {


                                              }, didSaveSuccess: () {

                                          },
                                      )
                                    )
                                  )
                                );
                              },
                              transitionBuilder: (context, anim1, anim2, child) {
                                return Transform.scale(
                                    scale: anim1.value,
                                    child: Opacity(
                                        opacity: anim1.value,
                                        child: child
                                    )
                                );
                              },
                            );
                          } else {
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) {
                                  return PaymentMethodsWidget(
                                    model: widget.model,
                                    isPushedView: true,
                                    didSelectPaymentMethod: (card) {

                                    },
                                    didSaveSuccess: () {

                                    },
                                  );
                                })
                            );
                          }
                          break;
                        case ProfilePaymentMarker.pastPayments:
                          if (kIsWeb) {
                            showGeneralDialog(
                              context: context,
                              barrierDismissible: false,
                              barrierLabel: 'Payment Methods',
                              transitionDuration: Duration(milliseconds: 350),
                              pageBuilder: (BuildContext contexts, anim1, anim2) {
                                return  Align(
                                    alignment: Alignment.center,
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.all(Radius.circular(25)),
                                        child: Container(
                                            decoration: BoxDecoration(
                                                color: widget.model.accentColor,
                                                borderRadius: BorderRadius.all(Radius.circular(17.5))
                                            ),
                                            width: 550,
                                            height: 750,
                                            child: PaymentHistoryWidget(
                                              model: widget.model,
                                              profile: widget.profile,
                                            )
                                        )
                                    )
                                );
                              },
                              transitionBuilder: (context, anim1, anim2, child) {
                                return Transform.scale(
                                    scale: anim1.value,
                                    child: Opacity(
                                        opacity: anim1.value,
                                        child: child
                                    )
                                );
                              },
                            );
                          } else {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) {
                                  return PaymentHistoryWidget(
                                    model: widget.model,
                                    profile: widget.profile,
                                  );
                                }));
                          }
                          break;
                        default:
                    }
                  }
                )
              ),


              const SizedBox(height: 35),
              Visibility(
                  visible: !widget.isActivityVersion,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hosting', style: TextStyle(color: widget.model.paletteColor,
                          fontSize: widget.model.secondaryQuestionTitleFontSize,
                          fontWeight: FontWeight.bold)),
                      const SizedBox(height: 24),
                      ...payoutSettingsList().map(
                              (e) => profilePaymentSettingItemWidget(
                              widget.model,
                              e,
                              didSelectItem: (f) {
                                switch (f) {
                                  case ProfilePaymentMarker.payouts:
                                    if (kIsWeb) {
                                      showGeneralDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        barrierLabel: 'Payment Methods',
                                        transitionDuration: Duration(milliseconds: 350),
                                        pageBuilder: (BuildContext contexts, anim1, anim2) {
                                          return  Align(
                                              alignment: Alignment.center,
                                              child: ClipRRect(
                                                  borderRadius: BorderRadius.all(Radius.circular(25)),
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                          color: widget.model.accentColor,
                                                          borderRadius: BorderRadius.all(Radius.circular(17.5))
                                                      ),
                                                      width: 550,
                                                      height: 750,
                                                      child: PayoutAccountLink(
                                                      model: widget.model,
                                                )
                                              )
                                            )
                                          );
                                        },
                                        transitionBuilder: (context, anim1, anim2, child) {
                                          return Transform.scale(
                                              scale: anim1.value,
                                              child: Opacity(
                                                  opacity: anim1.value,
                                                  child: child
                                              )
                                          );
                                        },
                                      );
                                    } else {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (_) {
                                            return PayoutAccountLink(
                                              model: widget.model,
                                            );
                                          })
                                      );
                                    }
                                    break;
                                  case ProfilePaymentMarker.taxes:
                                  // TODO: Handle this case.
                                    break;
                                  case ProfilePaymentMarker.transactionHistory:
                                    if (kIsWeb) {

                                    } else {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (_) {
                                            return PayoutHistoryWidget(
                                              model: widget.model,
                                              profile: widget.profile,
                                            );
                                          }));
                                    }
                                    break;
                                  default:
                                }
                              }
                          )
                      ),
                    ],
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}