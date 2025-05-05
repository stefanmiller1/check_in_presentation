import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_presentation/core/profile_creator_template/template_components/profile_editor_component.dart';
import 'package:check_in_presentation/profile_core_widgets/profile_settings/profile_settings_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:check_in_domain/check_in_domain.dart';

import 'profile_creator_template_helper.dart';

class ProfileMainDashboardMain extends StatefulWidget {

  final DashboardModel model;
  final bool isMobileOnly;
  final ProfileTypeMarker? initialTab;
  final List<ProfileCreatorContainerModel> profileContainerItem;

  const ProfileMainDashboardMain({super.key,
    required this.model,
    this.initialTab,
    required this.profileContainerItem,
    required this.isMobileOnly
  });


  @override
  State<ProfileMainDashboardMain> createState() => _ProfileMainDashboardMainState();
}

class _ProfileMainDashboardMainState extends State<ProfileMainDashboardMain> with TickerProviderStateMixin {

  final _controller = ScrollController();
  final _controller2 = ScrollController();
  late TabController? _tabController;
  late PageController? _pageController;
  double scrollOffset = 0;

  double startPositioned = 670;
  double heightForRightContainer = 240;
  double locationToHoldPosition = 290;


  @override
  void initState() {
    _tabController = TabController(initialIndex: widget.profileContainerItem.indexWhere((e) => e.profileType == (widget.initialTab ?? ProfileTypeMarker.generalProfile)), length: widget.profileContainerItem.length, vsync: this);
    _pageController = PageController(initialPage: widget.profileContainerItem.indexWhere((e) => e.profileType == (widget.initialTab ?? ProfileTypeMarker.generalProfile)), keepPage: true);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _controller2.dispose();
    _tabController?.dispose();
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = widget.isMobileOnly == true || Responsive.isMobile(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
            ),
            Container(
              height: constraints.maxHeight,
              width: constraints.maxWidth,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: widget.model.mobileBackgroundColor
              ),
              child: Padding(
                padding: EdgeInsets.only(top: (isMobile == false) ? 40.0 : 6.0, left: 8, right: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: widget.profileContainerItem.length,
                    scrollDirection: Axis.horizontal,
                    allowImplicitScrolling: true,
                    physics: isMobile == false ? const NeverScrollableScrollPhysics() : null,
                    onPageChanged: (index) {
                      setState(() {
                        _tabController?.animateTo(index, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                      });
                    },
                    itemBuilder: (_, index) {
                      final ProfileCreatorContainerModel e = widget.profileContainerItem[index];
                  
                      if (index == 0) {
                        if (isMobile == false) {
                          return e.profilesList;
                        }
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10.0, top: 10.0),
                          child: SingleChildScrollView(
                            controller: _controller,
                            physics: (e.isEditorVisible) ? const NeverScrollableScrollPhysics() : null,
                            child: mainContainerForDashboard(e, constraints),
                          ),
                        );
                      }
                  
                      if (index == 1) {
                        if (isMobile == false) {
                          return e.profilesList;
                        }
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10.0, top: 10.0),
                          child: SingleChildScrollView(
                            controller: _controller2,
                            physics: (e.isEditorVisible) ? const NeverScrollableScrollPhysics() : null,
                            child: mainContainerForDashboard(e, constraints),
                          ),
                        );
                      }
                  
                      return Container(); // Handle other indices if needed
                    },
                  ),
                ),
              ),
            ),
            getMainContainerAppbarBottomWidget(
              context,
              widget.model,
              _tabController,
              widget.profileContainerItem.map((e) => e.profileTabTitle).toList(),
              didSelectIndex: (index) {
                setState(() {
                  if (kIsWeb) {
                    _pageController?.jumpToPage(index);
                    _tabController?.animateTo(index, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                  } else {
                    _pageController?.animateToPage(index, duration: Duration(milliseconds: 400), curve: Curves.easeInOut);
                  }
                });
              },
            ),
          ],
        );
      },
    );
  }


  Widget mainContainerForDashboard(ProfileCreatorContainerModel e, BoxConstraints contstraint) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (e.isReloading == true)
          Column(
            children: [
              const SizedBox(height: 8),
              AnimatedOpacity(
                  opacity: (e.isReloading == true) ? 1 : 0,
                  duration: Duration(milliseconds: 500),
                  child: JumpingDots(color: widget.model.paletteColor, numberOfDots: 3)),
            ],
          )
        else
          Padding(
            padding: EdgeInsets.only(top: (e.isEditorVisible) ? 25.0 : 0.0),
            child: ProfileEditorComponent(model: widget.model, editorWidget: e.profileMainEditor, isVisible: e.isEditorVisible),
          ),

        const SizedBox(height: 21),
        AnimatedOpacity(
          opacity: (e.isEditorVisible) ? 1 : 0,
          duration: Duration(milliseconds: 500),
          child: Column(
            children: [
              Text('Edit Your Profile Above', style: TextStyle(color: widget.model.disabledTextColor)),
              const SizedBox(height: 4),
              Divider(thickness: 1, color: widget.model.disabledTextColor, height: 1,),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Container(
              height: contstraint.maxHeight,
              width: contstraint.maxWidth,
              color: widget.model.webBackgroundColor,
              child: e.profilesList
          ),
        ),
      ],
    );
  }
}