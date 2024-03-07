part of check_in_presentation;

// import 'dart:io';
//
// import 'package:check_in_domain/check_in_domain.dart';
// import 'package:check_in_presentation/check_in_presentation.dart';
// import 'package:flutter/material.dart';
// import 'package:add_to_wallet/add_to_wallet.dart';


class AttendeeTicketWidget extends StatefulWidget {

  final DashboardModel model;
  final ReservationItem reservationItem;
  final UserProfileModel currentUser;
  final ActivityManagerForm activityManagerForm;
  final TicketItem ticket;

  const AttendeeTicketWidget({super.key, required this.reservationItem, required this.currentUser, required this.activityManagerForm, required this.ticket, required this.model});

  @override
  State<AttendeeTicketWidget> createState() => _AttendeeTicketWidgetState();
}

class _AttendeeTicketWidgetState extends State<AttendeeTicketWidget> {

  bool _ticketLoaded = false;
  List<int> _ticketData = [];

  @override
  void initState() {

    super.initState();
  }

  void generateWalletPassFromUri(String url) async {
    // final passkit = await Passkit().saveFromUri(id: 'example', url: url);

    try {


      PassFile passFile = await Pass().fetchPreviewFromUrl(url: url);
      final passToFile = passFile.file;

      final passKitFile = await FlutterWalletCard.generateFromFile(id: passFile.id, file: passToFile);
      final card = await FlutterWalletCard.addPasskit(passKitFile);

    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_ticketLoaded) {
      return Scaffold(
        body: JumpingDots(color: widget.model.paletteColor, numberOfDots: 3)
      );
    }
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
      children: [
        Align(alignment: Alignment.topRight,
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.cancel, size: 30, color: widget.model.paletteColor),
          )
        ),
        const SizedBox(height: 8),
        if (kIsWeb) phoneRequiredWidget(),
        const SizedBox(height: 15),
        // if (!(kIsWeb)) AddToWalletButton(
        //     pkPass: [],
        //     width: 200,
        //     height: 60,
        //     onPressed: () async {
        //       setState(() {
        //         generateWalletPassFromUri('gs://cico-8298b.appspot.com/passes/event.pkpass');
        //       });
        //     },
        // ),
        // const SizedBox(height: 25),
        InkWell(
          onTap: () async {

            setState(() {
              _ticketLoaded = true;
            });

              try {
                final bool? generatedPass = await facade.AttendeeAuthCore.instance.generatePKPassForTicket(
                    description: 'description',
                    ticketHolderName: 'Attendee',
                    ticketDate: DateFormat.yMMMd().format(widget.ticket.selectedReservationSlot?.selectedDate ?? DateTime.now()).toString(),
                    ticketFee: completeTotalPriceWithCurrency(widget.ticket.selectedTicketFee.toDouble(), widget.activityManagerForm.rulesService.currency),
                    facilityName: widget.activityManagerForm.profileService.activityBackground.activityTitle.getOrCrash(),
                    activityLocation: '',
                    ticketId: widget.ticket.ticketId.getOrCrash()
                );

                if (generatedPass == true) {
                  final passUrl = await facade.AttendeeAuthCore.instance.kPassUrl('');
                  generateWalletPassFromUri(passUrl);
                  // 'https://github.com/WebEferen/flutter_wallet_card/raw/master/example/passes/example.pkpass'
                  print(passUrl);
                }

                Future.delayed(const Duration(seconds: 1), () {
                  setState(() {
                    _ticketLoaded = false;
                  });
                });

              } catch (e) {

                setState(() {
                  _ticketLoaded = false;
                });
              }


          },
          child: Container(
              width: 220,
              height: 50,
              child: SvgPicture.asset('assets/icons_svg/add_to_wallet/US-UK_Add_to_Apple_Wallet_RGB_101421.svg', fit: BoxFit.fitHeight),
              )
            )
          ],
        )
      )
    );
  }

  Widget phoneRequiredWidget() {
    return Container(
      decoration: BoxDecoration(
          color: widget.model.accentColor,
          borderRadius: const BorderRadius.all(Radius.circular(25)),
          border: Border.all(color: widget.model.paletteColor)
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Icon(Icons.phonelink_ring_rounded),
            const SizedBox(height: 15),
            Text('The Phone Is Your Ticket', style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize)),
            const SizedBox(height: 8),
            Text('Open up and log into CICO on your phone and head to your reservations - my tickets. You should find all your tickets there!', style: TextStyle(color: widget.model.paletteColor))
          ]
        )
      )
    );
  }
}