import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExploreSearchFilterQueryBar extends StatefulWidget implements PreferredSizeWidget {
  final DashboardModel model;
  final TextEditingController searchController;
  final String? initialQuery;
  final Function(String) onSearchQueryChanged;
  final Function(String) onSearchSubmitted;
  final Widget mobileSearchView;
  final Function() didSelectFilter;
  final Widget Function(String? query) webDropdownView;
  final FocusNode focusNode;

  const ExploreSearchFilterQueryBar({
    Key? key,
    this.initialQuery,
    required this.onSearchQueryChanged,
    required this.onSearchSubmitted,
    required this.mobileSearchView,
    required this.webDropdownView,
    required this.didSelectFilter,
    required this.model,
    required this.searchController,
    required this.focusNode, // Add focus node
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  _ExploreSearchFilterQueryBarState createState() => _ExploreSearchFilterQueryBarState();
}

class _ExploreSearchFilterQueryBarState extends State<ExploreSearchFilterQueryBar> {
  
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: (Responsive.isMobile(context)) ? 340 : 460),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: (Responsive.isMobile(context)) ? 30 : 0),
        child: TextField(
          controller: widget.searchController,
          focusNode: widget.focusNode, // Attach the focus node
          onChanged: widget.onSearchQueryChanged,
          onSubmitted: widget.onSearchSubmitted,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search),
            hintText: 'Search...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: widget.model.accentColor,
            suffixIcon: IconButton(
              icon: const Icon(CupertinoIcons.slider_horizontal_3),
              onPressed: widget.didSelectFilter,
            ),
          ),
        ),
      ),
    );
  }
}
