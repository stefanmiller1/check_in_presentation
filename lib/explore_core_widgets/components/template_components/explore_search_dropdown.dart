
// import 'package:flutter/material.dart';

// class ExploreSearchDropdown extends StatefulWidget {
//   final Widget dropdownContent;
//   final ScrollController scrollController;

//   const ExploreSearchDropdown({
//     Key? key,
//     required this.dropdownContent,
//     required this.scrollController,
//   }) : super(key: key);

//   @override
//   State<ExploreSearchDropdown> createState() => _ExploreSearchDropdownState();
// }

// class _ExploreSearchDropdownState extends State<ExploreSearchDropdown> with SingleTickerProviderStateMixin {
//   bool _isVisible = false;

//   @override
//   void initState() {
//     super.initState();

//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }


//   @override
//   Widget build(BuildContext context) {
//     return Visibility(
//       visible: true,
//           child: GestureDetector(
//             onTap: () {
//               // widget.focusNode.unfocus();
//             },
//             child: widget.dropdownContent
//       ),
//     );
//   }
// }