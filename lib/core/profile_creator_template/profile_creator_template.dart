import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_presentation/core/profile_creator_template/template_components/profile_editor_component.dart';
import 'package:check_in_presentation/profile_core_widgets/profile_settings/profile_settings_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jumping_dot/jumping_dot.dart';

import 'profile_creator_template_helper.dart';

class ProfileMainDashboardMain extends StatefulWidget {

  final DashboardModel model;
  final List<ProfileCreatorContainerModel> profileContainerItem;

  const ProfileMainDashboardMain({super.key,
    required this.model,
    required this.profileContainerItem
  });


  @override
  State<ProfileMainDashboardMain> createState() => _ProfileMainDashboardMainState();
}

class _ProfileMainDashboardMainState extends State<ProfileMainDashboardMain> with TickerProviderStateMixin {

  final _controller = ScrollController();
  late TabController? _tabController;
  late PageController? _pageController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _tabController = TabController(length: widget.profileContainerItem.length, vsync: this);
    _pageController = PageController(initialPage: 0, keepPage: true);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _tabController?.dispose();
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              Expanded(
                child: Container(
                  child: PageView.builder(
                      controller: _pageController,
                      itemCount: widget.profileContainerItem.length,
                      scrollDirection: Axis.horizontal,
                      allowImplicitScrolling: true,
                      onPageChanged: (index) {
                        setState(() {
                          _tabController?.animateTo(index, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                        });
                      },
                      itemBuilder: (_, index) {

                        final ProfileCreatorContainerModel e = widget.profileContainerItem[index];

                        return SingleChildScrollView(
                          controller: _controller,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (e.isOwner == true && e.showAddIcon == true || e.isEditorVisible) Column(
                                children: [
                                  const SizedBox(height: 25),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(40),
                                          color: widget.model.accentColor
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                child: Text(e.profileHeaderTitle, style: TextStyle(fontSize: widget.model.secondaryQuestionTitleFontSize, color: widget.model.disabledTextColor, overflow: TextOverflow.ellipsis), maxLines: 1),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: e.didSelectNew,
                                              child: Chip(
                                                side: BorderSide.none,
                                                backgroundColor: (e.isEditorVisible) ? widget.model.webBackgroundColor : widget.model.paletteColor,
                                                padding: EdgeInsets.zero,
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                                label: Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                  child: Text(e.profileHeaderSubTitle, style: TextStyle(color: (e.isEditorVisible) ? widget.model.paletteColor : widget.model.accentColor, fontSize: widget.model.secondaryQuestionTitleFontSize, overflow: TextOverflow.ellipsis), maxLines: 1),
                                                ),
                                                avatar: Icon(e.profileHeaderIcon, size: 25, color: (e.isEditorVisible) ? widget.model.paletteColor : widget.model.disabledTextColor,),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),

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
                                ProfileEditorComponent(model: widget.model, editorWidget: e.profileMainEditor, isVisible: e.isEditorVisible),

                              SizedBox(height: (e.isEditorVisible) ? 21 : 0),
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
                                    color: widget.model.webBackgroundColor,
                                    child: e.profilesList
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                  ),
                ),
              )
            ],
          ),

          Positioned(
            top: 0,
            child: Container(
              height: 40,
              color: widget.model.mobileBackgroundColor,
              child: getMainContainerAppbarBottomWidget(
                  context,
                  widget.model,
                  _tabController,
                  widget.profileContainerItem.map((e) => e.profileTabTitle).toList(),
                  didSelectIndex: (index) {
                    setState(() {
                      _pageController?.animateToPage(index, duration: Duration(milliseconds: 400), curve: Curves.easeInOut);
                    });
                  }
              ),
            ),
          ),
      ],
    );
  }
}