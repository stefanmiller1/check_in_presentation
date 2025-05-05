part of check_in_presentation;

enum MessengerContainerMarker {messages, support, archive}


  // return Container(
  //   height: 90,
  //   width: MediaQuery.of(context).size.width,
  //   child: Shimmer.fromColors(
  //     baseColor: Colors.grey.shade400,
  //     highlightColor: Colors.grey.shade100,
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.start,
  //       children: [
  //         Container(
  //           height: 45,
  //           width: 45,
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(30),
  //             color: Colors.grey.withOpacity(0.15),
  //           ),
  //         ),
  //         const SizedBox(width: 15),
  //         Container(
  //           height: 60,
  //           width: MediaQuery.of(context).size.width,
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(20),
  //             color: Colors.grey.withOpacity(0.15),
  //             ),
  //           )
  //       ],
  //     ),
  //   )
  // );
// }

/// setup avatar for one member
Widget retrieveSystemMessageBuilder(types.SystemMessage message, BuildContext context, DashboardModel model) {
  print('message.text: ${message.text}');
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: Text(message.text, style: TextStyle(color: model.disabledTextColor)),
            
  );
}

/// setup avatar for member with multiple guests or multiple co-owners

/// retrieve reservation details

