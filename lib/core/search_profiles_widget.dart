part of check_in_presentation;

class SearchProfiles extends StatefulWidget {

  final DashboardModel model;
  final Function(UserProfileModel) selectedProfilesToSave;
  final bool showAddProfile;

  const SearchProfiles({Key? key, required this.selectedProfilesToSave, required this.model, required this.showAddProfile}) : super(key: key);

  @override
  State<SearchProfiles> createState() => _SearchProfilesState();
}

class _SearchProfilesState extends State<SearchProfiles> with SingleTickerProviderStateMixin {

  late UserProfileModel? selectedProfile = null;
  late TextEditingController _textController;
  String querySearch = '';
  bool didEditQuery = false;

  late TabController? _tabController;
  late PageController? _pageController;
  late int _currentPageIndex = 0;

  @override
  void initState() {
    _pageController = PageController();
    _tabController = TabController(length: 2, vsync: this);
    _textController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    _tabController?.dispose();
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return  Column(
      children: [
        if (widget.showAddProfile) Column(
          children: [
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 28.0),
                  child: Text('Search Profiles', style: TextStyle(color: widget.model.paletteColor)),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 18.0),
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.cancel_outlined, color: widget.model.paletteColor, size: 40),
                    padding: EdgeInsets.all(1),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
              controller: _textController,
              style: TextStyle(color: widget.model.paletteColor),
              decoration: InputDecoration(
                hintStyle: TextStyle(color: widget.model.disabledTextColor),
                hintText: 'Search a Name or Email',
                errorStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: widget.model.paletteColor,
                ),
                prefixIcon: Icon(Icons.person, color: widget.model.disabledTextColor),
                filled: true,
                fillColor: widget.model.accentColor,
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(
                    width: 2,
                    color: widget.model.paletteColor,
                  ),
                ),
                focusedBorder:  OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(
                    color: widget.model.paletteColor,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: const BorderSide(
                    width: 0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(
                    color: widget.model.disabledTextColor,
                    width: 0,
                  ),
                ),
              ),
              autocorrect: false,
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              minLines: 1,
              onChanged: (query) {
                setState(() {
                  didEditQuery = false;
                  querySearch = query;
                });
                Future.delayed(Duration(seconds: 2), () {
                  setState(() {
                    didEditQuery = true;
                  });
                });
              }
          ),
        ),

        const SizedBox(height: 15),
        TabBar(
          controller: _tabController,
          onTap: (index) {
            setState(() {
              _currentPageIndex = index;
              _pageController?.animateToPage(index, duration: const Duration(milliseconds: 350), curve: Curves.easeInOut);
            });
          },
          indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              color: widget.model.paletteColor
          ),
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          labelColor: widget.model.accentColor,
          unselectedLabelColor: widget.model.disabledTextColor,
          tabs: [
            ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: const Tab(text: 'Everyone')),
            ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Tab(text: 'Close Friends')
            )
          ],
        ),
        const SizedBox(height: 25),
        Divider(color: widget.model.disabledTextColor),
        const SizedBox(height: 15),

        Container(
          height: 250,
          width: 600,
          child: PageView.builder(
              controller: _pageController,
              itemCount: 2,
              scrollDirection: Axis.horizontal,
              allowImplicitScrolling: true,
              onPageChanged: (page) {
                setState(() {
                  _currentPageIndex = page;
                  _tabController?.animateTo(_currentPageIndex);
                });
              },
              itemBuilder: (_, index) {
                // if (index == 0) {
                //
                // } else {
                //
                // }
                if (didEditQuery && index == 0) {
                  return BlocProvider(create: (context) => getIt<UserProfileWatcherBloc>()..add(UserProfileWatcherEvent.watchSearchedProfileStarted(querySearch)),
                    child: BlocBuilder<UserProfileWatcherBloc, UserProfileWatcherState>(
                        builder: (context, authState) {
                          return authState.maybeMap(
                              loadInProgress: (_) => JumpingDots(numberOfDots: 3, color: widget.model.paletteColor),
                              loadSearchProfileFailure: (_) {
                                return Container(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 90,
                                          width: 90,
                                          child: CircleAvatar(backgroundImage: Image.asset('assets/profile-avatar.png').image),
                                        ),
                                        const SizedBox(height: 10),
                                        Text('Has Not Joined Yet!', style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                                        const SizedBox(height: 5),
                                        Text('Sorry, $querySearch can\'nt be found.')
                                      ],
                                    ),
                                  ),
                                );
                              },
                              loadSearchedProfileSuccess: (items) {
                                // final bool isSelected = items.profiles.map((e) => e.)
                                return AnimatedContainer(
                                    curve: Curves.easeInOut,
                                    duration: Duration(milliseconds: 400),
                                    child:  Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ...items.profiles.map(
                                                (user) {

                                              final bool isSelected = user.userId == selectedProfile?.userId;

                                              return Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 4.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(18),
                                                      color: isSelected ? widget.model.paletteColor : widget.model.webBackgroundColor
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                                                    child: ListTile(
                                                      onTap: () {
                                                        setState(() {
                                                          if (isSelected) {
                                                            selectedProfile = null;
                                                          } else {
                                                            selectedProfile = user;
                                                            widget.selectedProfilesToSave(user);
                                                          }
                                                        });
                                                      },
                                                      leading: CircleAvatar(backgroundImage: (user.profileImage != null) ? user.profileImage!.image : Image.asset('assets/profile-avatar.png').image),
                                                      trailing: isSelected ? Container(
                                                        height: 50,
                                                        width: 150,
                                                        child: Row(
                                                          children: [
                                                            Text('Selected Profile', style: TextStyle(color: widget.model.accentColor),),
                                                            const SizedBox(width: 5),
                                                            Icon(Icons.check_circle_outline, color: widget.model.webBackgroundColor,)
                                                          ],
                                                        ),
                                                      ) : Container(
                                                        height: 50,
                                                        width: 150,
                                                        child: Row(
                                                          children: [
                                                            Text('Pick a Profile', style: TextStyle(color: widget.model.disabledTextColor)),
                                                            const SizedBox(width: 5),
                                                            Icon(Icons.circle_outlined, color: widget.model.disabledTextColor,)
                                                          ],
                                                        ),
                                                      ),
                                                      title: Row(
                                                        children: [
                                                          Text(user.legalName.value.fold((l) => '', (r) => r), style: TextStyle(color: (isSelected) ? widget.model.accentColor : widget.model.paletteColor)),
                                                          const SizedBox(width: 5),
                                                          Text(user.legalSurname.value.fold((l) => '', (r) => r), style: TextStyle(color: (isSelected) ? widget.model.accentColor : widget.model.paletteColor)),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                        const SizedBox(height: 15),
                                        Text('Select a profile from above', style: TextStyle(color: widget.model.disabledTextColor))
                                      ],
                                    )
                                );
                                // return querySearchItemsContainer(context, items.profile);
                              },
                              orElse: () {
                                return SizedBox(
                                    height: 220,
                                    child: JumpingDots(numberOfDots: 3, color: widget.model.paletteColor)
                                );
                              }
                          );
                        }
                    ),
                  );
                }
              return Container();
            }
          ),
        ),

        const SizedBox(height: 15),

        if (widget.showAddProfile) InkWell(
          onTap: () {
            if (selectedProfile != null) {
              widget.selectedProfilesToSave(selectedProfile!);
            }
          },
          child: Container(
            width: 675,
            height: 60,
            decoration: BoxDecoration(
              color: (selectedProfile != null) ? widget.model.paletteColor : widget.model.webBackgroundColor,
              borderRadius: const BorderRadius.all(Radius.circular(15)),
            ),
            child: Align(
              child: Text('Add Profile', style: TextStyle(color: (selectedProfile != null) ? widget.model.accentColor : widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
            ),
          ),
        ),
        // selectedProfile

    ],
        );
  }
}