

import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/material.dart';

class CustomProfileLayout extends StatefulWidget {
  final Widget profileContent;
  final Widget profilePicture;
  final Widget profileFooter;
  final bool isMobileOnly;
  final double stickyStartOffset;

  const CustomProfileLayout({
    Key? key,
    required this.profileContent,
    required this.profilePicture,
    required this.profileFooter,
    required this.isMobileOnly,
    this.stickyStartOffset = 0.0,
  }) : super(key: key);

  @override
  _CustomProfileLayoutState createState() => _CustomProfileLayoutState();
}

class _CustomProfileLayoutState extends State<CustomProfileLayout> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _profileContentKey = GlobalKey();
  final GlobalKey _profilePictureKey = GlobalKey();
  double scrollOffset = 0;
  double endOffset = 900;
  double profilePictureHeight = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        scrollOffset = _scrollController.offset;
        measureContentHeight();
      });
    });
    measureContentHeight();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void measureContentHeight() {
    // setState(() {
      final RenderBox? contentRenderBox = _profileContentKey.currentContext?.findRenderObject() as RenderBox?;
      final RenderBox? pictureRenderBox = _profilePictureKey.currentContext?.findRenderObject() as RenderBox?;
      if (contentRenderBox != null && pictureRenderBox != null) {
        final double contentHeight = contentRenderBox.size.height;
        final double pictureHeight = pictureRenderBox.size.height;
        if (contentHeight > pictureHeight) {
          endOffset = contentHeight;
          profilePictureHeight = pictureHeight;
        }
      }
    // });
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      child: (Responsive.isMobile(context) || widget.isMobileOnly)
          ? Column(
        children: [
          const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: widget.profilePicture,
          ),
          widget.profileContent,
          widget.profileFooter,
          const SizedBox(height: 70),
        ],
      )
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1450),
            child: Column(
              children: [
                const SizedBox(height: 150),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 550,
                      child: Stack(
                        children: [
                          Container(
                            height: endOffset,
                          ),
                          Positioned(
                            top: calculateTopPosition(),
                            child: Container(
                              key: _profilePictureKey,
                              child: widget.profilePicture,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      child: Container(
                        key: _profileContentKey,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 75.0),
                          child: widget.profileContent,
                        ),
                      ),
                    ),
                  ],
                ),
                /// footer container
                widget.profileFooter
              ],
            ),
          ),
        ),
      ),
    );
  }

  double calculateTopPosition() {
    if (scrollOffset > widget.stickyStartOffset) {
      if (scrollOffset < endOffset - profilePictureHeight - widget.stickyStartOffset) {
        return scrollOffset - widget.stickyStartOffset;
      } else {
        return endOffset - profilePictureHeight - (widget.stickyStartOffset * 2);
      }
    } else {
      return widget.stickyStartOffset < 0 ? -widget.stickyStartOffset : 0;
    }
  }
}