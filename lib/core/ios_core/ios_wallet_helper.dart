import 'dart:convert';

import 'package:check_in_domain/check_in_domain.dart';
import 'package:flutter_wallet_card/core/passkit.dart';
import 'package:flutter_wallet_card/flutter_wallet_card.dart';



void generateWalletPassFromUri(String url) async {
  final passkit = await Passkit().saveFromUri(id: 'example', url: url);
  await FlutterWalletCard.addPasskit(passkit);
}


// void generateWalletPassFromPath() async {
//   final directory = await getTemporaryDirectory();
//   final file = File('${directory.path}/example.pkpass');
//
//   // final examplePass = await rootBundle.load('passes/example.pkpass');
//   final written = await file.writeAsBytes(examplePass.buffer.asUint8List());
//   final walletPass = walletCardForTicket(
//       description: '',
//       ticketHolderName: '',
//       ticketDate: '',
//       ticketFee: '',
//       facilityName: '',
//       activityLocation: '',
//       ticketId: '');
//
//
//   final passkit = await Passkit().saveFromPath(id: 'example', file: written);
//   await FlutterWalletCard.addPasskit(passkit);
//
//   await file.delete();
// }

// final exampleUrl =
//     'https://github.com/WebEferen/flutter_wallet_card/raw/master/example/passes/example.pkpass';

//
// PasskitPass walletCardForTicket({required String description, required String ticketHolderName, required String ticketDate, required String ticketFee, required String facilityName, required String activityLocation, required String ticketId}) => PasskitPass(
//   description: description,
//   formatVersion: 1,
//   organizationName: 'Check In Check Out',
//   passTypeIdentifier: 'com.cico.checkInWebMobileExplore',
//   serialNumber: '0000001',
//   teamIdentifier: 'R27Y45WKCJ',
//   logoText: "CICO",
//   foregroundColor: Color.fromRGBO(255, 255, 255, 1),
//   backgroundColor: Color.fromRGBO(90, 90, 90, 1),
//   labelColor: Color.fromRGBO(255, 255, 255, 1),
//   expirationDate: ticketDate,
//   barcodes: [
//     PasskitBarcode(
//         format: 'PKBarcodeFormatQR',
//         message: ticketId,
//         messageEncoding: utf8.encode(ticketId).toString()
//     ),
//   ],
//   generic: PasskitStructure(
//     primaryFields: [
//       /// venue title...
//       PasskitField(
//         key: 'holder',
//         label: 'Name',
//         value: ticketHolderName,
//       ),
//     ],
//     secondaryFields: [
//       PasskitField(
//         key: 'venueName',
//         label: facilityName,
//         value: activityLocation,
//       ),
//       /// ticket fee
//       PasskitField(
//         key: 'fee',
//         label: 'Costs',
//         value: ticketHolderName,
//       ),
//     ],
//     headerFields: [
//       PasskitField(
//         key: 'date',
//         value: ticketDate,
//         label: 'Date',
//       )
//     ],
//   ),
// );