part of check_in_presentation;


// class UserProfileSearchWidget extends StatefulWidget {
//
//   const UserProfileSearchWidget({
//     super.key,
//     required this.model,
//     required this.query,
//     required this.selectedProfile,
//     required this.selectedUsers,
//   });
//
//   final DashboardModel model;
//   final TextEditingController query;
//   final Function(UniqueId) selectedProfile;
//   final List<UniqueId> selectedUsers;
//
//   @override
//   State<UserProfileSearchWidget> createState() => _UserProfileSearchWidgetState();
// }
//
// class _UserProfileSearchWidgetState extends State<UserProfileSearchWidget> {
//
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<List<UserProfileModel>>(
//         stream: searchFirebaseUsersProfile(query: widget.query.text),
//         builder: (context, snapshot) {
//           final data = snapshot.data ?? [];
//           print(data);
//
//           return (snapshot.connectionState == ConnectionState.waiting) ? Container(
//               height: 50,
//               width: MediaQuery.of(context).size.width,
//               child: CircularProgressIndicator()) :
//           ListView.builder(
//               itemCount: data.length,
//               itemBuilder: (context, index) {
//                 final user = data[index];
//
//                 return ListTile(
//                   onTap: () {
//                     setState(() {
//                       widget.selectedProfile(user.userId);
//                     });
//                     // setState(() {
//                     //   if (!(selectedUsers.contains(user.userId))) {
//                     //     selectedUsers.add(user.userId);
//                     //   } else {
//                     //     selectedUsers.remove(user.userId);
//                     //   }
//                     // });
//                   },
//                   leading: CircleAvatar(backgroundImage: (user.profileImage != null) ? user.profileImage!.image : Image.asset('assets/profile-avatar.png').image),
//                   title: Text('${user.legalName.value.fold((l) => '', (r) => r)} ${user.legalSurname.value.fold((l) => '', (r) => r)}', style: TextStyle(color: widget.model.paletteColor)),
//                   trailing: Container(
//                     height: 30,
//                     width: 30,
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(50),
//                         border: Border.all(width: 2, color: widget.model.paletteColor)
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(4.0),
//                       child: Container(
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(50),
//                             color: (widget.selectedUsers.contains(user.userId)) ? widget.model.paletteColor : Colors.transparent
//                         ),
//                       ),
//                     ),
//                   ),
//                   // subtitle: Text('${user.emailAddress.getOrCrash()}', style: TextStyle(color: widget.model.disabledTextColor)),
//                 );
//               }
//           );
//       }
//     );
//   }
// }