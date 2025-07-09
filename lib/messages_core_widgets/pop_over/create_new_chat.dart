part of check_in_presentation;


/// A standardized tile for both suggested rooms and search results.
class ChatUserTile extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String? brandName;
  final String? imageUrl;
  final bool selected;
  final bool showCheckbox;
  final VoidCallback? onTap;
  final ValueChanged<bool?>? onCheckboxChanged;
  final Color paletteColor;
  final Color disabledTextColor;

  const ChatUserTile({
    Key? key,
    required this.firstName,
    required this.lastName,
    this.brandName,
    this.imageUrl,
    this.selected = false,
    this.showCheckbox = false,
    this.onTap,
    this.onCheckboxChanged,
    required this.paletteColor,
    required this.disabledTextColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final avatar = CircleAvatar(
      backgroundImage: imageUrl != null
          ? NetworkImage(imageUrl!)
          : const AssetImage('assets/profile-avatar.png')
              as ImageProvider,
    );

    if (showCheckbox) {
      return ListTile(
        leading: avatar,
        title: Text('$firstName $lastName'),
        subtitle: brandName != null
            ? Text(brandName!, style: TextStyle(color: disabledTextColor))
            : null,
        onTap: onCheckboxChanged != null
            ? () => onCheckboxChanged!(!selected)
            : null,
        trailing: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: paletteColor, width: 2),
          ),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? paletteColor : Colors.transparent,
              ),
            ),
          ),
        ),
      );
    } else {
      return ListTile(
        leading: avatar,
        title: Text('$firstName $lastName'),
        subtitle: brandName != null
            ? Text(brandName!, style: TextStyle(color: disabledTextColor))
            : null,
        selected: selected,
        selectedTileColor: paletteColor.withOpacity(0.1),
        onTap: onTap,
      );
    }
  }
}


/// Combines a user with an optional brand name.
class _UserWithBrand {
  final UserProfileModel user;
  final String? brandName;
  _UserWithBrand({required this.user, this.brandName});
}


enum ChatCreationStep { direct, circle, loading, complete }

class CreateNewChatContainer extends StatefulWidget {
  final DashboardModel model;
  const CreateNewChatContainer({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  _CreateNewChatContainerState createState() => _CreateNewChatContainerState();
}

class _CreateNewChatContainerState extends State<CreateNewChatContainer> {
  ChatCreationStep _step = ChatCreationStep.direct;

  // Direct chat
  final TextEditingController _directSearchController = TextEditingController();
  List<types.Room> _suggestedRooms = [];

  // Circle chat
  final TextEditingController _circleNameController = TextEditingController();
  final TextEditingController _userSearchController = TextEditingController();
  List<UserProfileModel> _userSearchResults = [];
  List<EventMerchantVendorProfile> _vendorSearchResults = [];
  final Map<String, String> _selectedUsersMap = {};

  Timer? _directDebounce;
  Timer? _circleDebounce;

  String? _selectedDirectUserId;

  bool _isLoading = false;

  String? _createdRoomId;

  @override
  void initState() {
    super.initState();
    _loadSuggestedRooms();
  }

  /// Returns true when at least one user has been selected for a direct chat.
  bool _isDirectActive() => _selectedDirectUserId != null;

  /// Returns true when more than two users have been selected for a group chat.
  bool _isGroupActive() => _selectedUsersMap.length > 1;

  Future<void> _loadSuggestedRooms() async {
    setState(() => _isLoading = true);
    // start with an empty list
    setState(() => _suggestedRooms = []);
    // stream direct rooms, dedupe and limit to 10
    facade.FirebaseChatCore.instance
        .limitedRooms(
          isArchived: false,
          roomType: types.RoomType.direct,
          limit: 10,
        )
        .listen((rooms) {
      if (!mounted) return;
      // Only consider rooms that have a directKey in their metadata
      final seenKeys = <String>{};
      final uniqueRooms = <types.Room>[];
      for (final room in rooms) {
        // collect and sort user IDs to form a dedupe key
        final ids = (room.users ?? [])
            .map((u) => u.id)
            .whereType<String>()
            .toList()
          ..sort();
        final key = ids.join(',');
        if (seenKeys.add(key)) {
          uniqueRooms.add(room);
        }
      }
      _isLoading = false;
      setState(() {
        _suggestedRooms = uniqueRooms;
      });
    });
  }

  
  /// Handles direct chat search with debounce and submit support.
  void _onDirectTextChanged(String text, {bool isSubmitted = false}) {
    // Cancel any existing debounce
    if (text.isEmpty) {
      return;
    }
    setState(() => _isLoading = true);
    if (_directDebounce?.isActive ?? false) _directDebounce!.cancel();

    if (isSubmitted) {
      // Immediate search on submit (Enter)
      _onUserSearchChanged(text);
    } else {
      // Debounce by 1 second
      _directDebounce = Timer(const Duration(seconds: 1), () {
        _onUserSearchChanged(text);
      });
    }
  }

  Future<void> _onUserSearchChanged(String query) async {
    final parts = query.trim().split(' ');
    final firstName = parts.isNotEmpty
        ? parts[0][0].toUpperCase() + parts[0].substring(1)
        : '';
    final lastName = parts.length > 1
        ? parts[1][0].toUpperCase() + parts[1].substring(1)
        : '';
    setState(() {
      _isLoading = true;
      _userSearchResults = [];
      _vendorSearchResults = [];
    });
    try {
      final users = await facade.UserProfileFacade.instance
          .queryByUserProfileSearch(firstName: firstName, lastName: lastName, limit: 5);
      final vendors = await facade.MerchVenFacade.instance
          .queryByUserProfileSearch(vendorName: firstName, limit: 5);
      setState(() {
        _userSearchResults = users.toList();
        _vendorSearchResults = vendors.toList();
        _isLoading = false;
      });
    } catch (_) {
      setState(() {
        _userSearchResults = [];
        _vendorSearchResults = [];
        _isLoading = false;
      });
    }
  }

  /// Handles circle/user search with debounce and submit support.
  void _onCircleTextChanged(String text, {bool isSubmitted = false}) {
    if (text.isEmpty) {
      return;
    }
    setState(() {
      _isLoading = true;
      _userSearchResults = [];
      _vendorSearchResults = [];
    });
    // Cancel any existing debounce
    if (_circleDebounce?.isActive ?? false) _circleDebounce!.cancel();

    if (isSubmitted) {
      // Immediate search on submit
      _onUserSearchChanged(text);
    } else {
      // Debounce by 1 second
      _circleDebounce = Timer(const Duration(seconds: 1), () {
        _onUserSearchChanged(text);
      });
    }
  }

  Future<void> _createDirectChat() async {
    setState(() => _step = ChatCreationStep.loading);
    if (_selectedDirectUserId != null) {
      try {
        final room = await facade.FirebaseChatCore.instance.createDirectRoom(
          _selectedDirectUserId!,
          '', // optional room name
          null,
        );
        _createdRoomId = room.id;
      } catch (e) {
        // handle error (optional)
      }
    }
    setState(() => _step = ChatCreationStep.complete);
  }

  Future<void> _createCircle(UserProfileModel profile) async {

    setState(() => _step = ChatCreationStep.loading);
    final name = _circleNameController.text.trim();
    // build list of chat-type users
    final users = _selectedUsersMap.keys
      .map((id) => types.User(id: id))
      .toList();
    try {
      final room = await facade.FirebaseChatCore.instance.createGroupRoom(
        name: name.isNotEmpty ? name : 'New Group',
        users: users,
      );
      _createdRoomId = room.id;

      // Send a system message announcing the new group and its members
      final creatorName = '${profile.legalName.value.fold((l) => '', (r) => r)} ${profile.legalSurname.value.fold((l) => '', (r) => r)}';
      final memberNames = _selectedUsersMap.values.join(', ');
      final systemText = '$creatorName created the group "${room.name}" with $memberNames.';
      
      facade.FirebaseChatCore.instance.sendMessage(
        types.SystemMessage(id: UniqueId().getOrCrash(), text: systemText),
        null,
        room.id,
      );

    final Map<String, dynamic> metada = {
        'status': 'done',
        'link': chatWithIdRoute(room.id)
      };
      // Notify each participant that they’ve been added to the group
      
      final notificationText =
          'You have been added to the group "${room.name}".';
       facade.FirebaseChatCore.instance.sendDirectNotifications(
        _selectedUsersMap.keys.toList(),
        creatorName,
        types.PartialText(text: notificationText),
        chatWithIdRoute(room.id), // route can be added here
        metada, // metadata if needed
      );
    } catch (e) {
      // handle error (optional)
    }
    setState(() => _step = ChatCreationStep.complete);
  }

  @override
  void dispose() {
    _directSearchController.dispose();
    _circleNameController.dispose();
    _userSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.model.webBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        automaticallyImplyLeading: (_step != ChatCreationStep.loading),
        title: Text('New Chat', style: TextStyle(color: widget.model.paletteColor)),
      ),
     body: BlocProvider(create: (_) => getIt<UserProfileWatcherBloc>()..add(const UserProfileWatcherEvent.watchUserProfileStarted()),
      child: BlocBuilder<UserProfileWatcherBloc, UserProfileWatcherState>(
        builder: (context, authState) {
          return authState.maybeMap(
            loadInProgress: (_) => Center(
              child: JumpingDots(
                numberOfDots: 3,
                color: widget.model.paletteColor,
              ),
            ),
            loadProfileFailure: (_) => Center(
              child: Text(
                'Please log in to start a chat',
                style: TextStyle(color: widget.model.paletteColor),
              ),
            ),
            loadUserProfileSuccess: (item) => Padding(
              padding: const EdgeInsets.all(16.0),
              child: Builder(builder: (_) {
                switch (_step) {
                  case ChatCreationStep.direct:
                    return _buildDirectChatView();
                  case ChatCreationStep.circle:
                    return _buildCircleChatView(item.profile);
                  case ChatCreationStep.loading:
                    return Center(
                      child: JumpingDots(
                        numberOfDots: 3,
                        color: widget.model.paletteColor,
                      ),
                    );
                  case ChatCreationStep.complete:
                    return _buildCompleteView(item.profile);
                }
              }),
            ),
            orElse: () => JumpingDots(color: widget.model.paletteColor, numberOfDots: 3)
          );
        },
      ),
    ),
    );
  }

  Widget _buildCompleteView(UserProfileModel profile) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_outline, size: 100, color: widget.model.paletteColor),
          const SizedBox(height: 20),
          Text(
            'Chat created!',
            style: TextStyle(
              fontSize: widget.model.secondaryQuestionTitleFontSize,
              fontWeight: FontWeight.bold,
              color: widget.model.paletteColor,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: HoverButton(
              onpressed: ()  {
                if (_createdRoomId != null) {
                  Navigator.of(context).pop(); 
                  didSelectOpRoom(context, widget.model, profile, _createdRoomId!);
                }
              },
              animationDuration: Duration.zero,
              color: _createdRoomId != null
                  ? widget.model.paletteColor
                  : widget.model.disabledTextColor.withOpacity(0.1),
              hoverColor: widget.model.disabledTextColor.withOpacity(0.2),
              hoverElevation: 0,
              highlightElevation: 0,
              hoverShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
              padding: const EdgeInsets.symmetric(vertical: 12),
              hoverPadding: const EdgeInsets.symmetric(vertical: 12),
              elevation: 0,
              child: Center(
                child: Text(
                  'Open Chat',
                  style: TextStyle(
                    fontSize: widget.model.secondaryQuestionTitleFontSize,
                    color: _createdRoomId != null
                        ? widget.model.accentColor
                        : widget.model.disabledTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: HoverButton(
              onpressed: () => Navigator.of(context).pop(),
              animationDuration: Duration.zero,
              color: widget.model.paletteColor,
              hoverColor: widget.model.disabledTextColor.withOpacity(0.2),
              hoverElevation: 0,
              highlightElevation: 0,
              hoverShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
              padding: const EdgeInsets.symmetric(vertical: 12),
              hoverPadding: const EdgeInsets.symmetric(vertical: 12),
              elevation: 0,
              child: Center(
                child: Text(
                  'Close',
                  style: TextStyle(
                    fontSize: widget.model.secondaryQuestionTitleFontSize,
                    color: widget.model.accentColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDirectChatView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Toggle buttons styled like HoverButton
        Row(
          children: [
            SizedBox(
              height: 40,
              child: HoverButton(
                onpressed: () => setState(() => _step = ChatCreationStep.direct),
                animationDuration: Duration.zero,
                color: _step == ChatCreationStep.direct
                    ? widget.model.paletteColor
                    : widget.model.webBackgroundColor,
                hoverColor: widget.model.disabledTextColor.withOpacity(0.2),
                hoverElevation: 0,
                highlightElevation: 0,
                hoverShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                hoverPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                elevation: 0,
                child: Text(
                  'Direct',
                  style: TextStyle(
                    color: _step == ChatCreationStep.direct
                        ? widget.model.accentColor
                        : widget.model.paletteColor,
                    fontSize: widget.model.secondaryQuestionTitleFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              height: 40,
              child: HoverButton(
                onpressed: () => setState(() => _step = ChatCreationStep.circle),
                animationDuration: Duration.zero,
                color: _step == ChatCreationStep.circle
                    ? widget.model.paletteColor
                    : widget.model.webBackgroundColor,
                hoverColor: widget.model.disabledTextColor.withOpacity(0.2),
                hoverElevation: 0,
                highlightElevation: 0,
                hoverShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                hoverPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                elevation: 0,
                child: Text(
                  ' A CIRCLE ',
                  style: TextStyle(
                    color: _step == ChatCreationStep.circle
                        ? widget.model.accentColor
                        : widget.model.paletteColor,
                    fontSize: widget.model.secondaryQuestionTitleFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            'Direct is a one-on-one private chat between you and someone else.',
            style: TextStyle(color: widget.model.disabledTextColor),
          ),
        ),
        // Search field
        TextField(
          controller: _directSearchController,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search),
            hintText: 'Search chats',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: widget.model.accentColor,
          ),
          onChanged: (val) => _onDirectTextChanged(val),
          onSubmitted: (val) => _onDirectTextChanged(val, isSubmitted: true),
          inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
        ),
        const SizedBox(height: 16),
        if (_isLoading)
          Expanded(
            child: Center(
              child: JumpingDots(
                numberOfDots: 3,
                color: widget.model.paletteColor,
              ),
            ),
          )
        else if (_directSearchController.text.isEmpty) ...[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Suggestions header
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Suggestions',
                    style: TextStyle(
                      fontSize: widget.model.secondaryQuestionTitleFontSize,
                      fontWeight: FontWeight.bold,
                      color: widget.model.paletteColor,
                    ),
                  ),
                ),
                // Show the live, streaming suggested rooms list
                Expanded(
                  child: ListView.builder(
                    itemCount: _suggestedRooms.length,
                    itemBuilder: (_, i) {
                      final room = _suggestedRooms[i];
                      // Find the "other" user in the direct room (should only be 2 users).
                      final others = (room.users ?? []).where((u) => u.id != null).toList();
                      types.User? other;
                      if (others.length == 2) {
                        // Find the user that's not the current user, fallback to first.
                        other = others.first;
                      } else if (others.length == 1) {
                        other = others.first;
                      }
                        final isSelected = _selectedDirectUserId == other?.id;

                      return ChatUserTile(
                        firstName: other?.firstName ?? '',
                        lastName: other?.lastName ?? '',
                        imageUrl: other?.imageUrl,
                        selected: isSelected,
                        showCheckbox: false,
                        onTap: () {
                        setState(() {
                          _selectedDirectUserId = other?.id;
                        });
                        },
                        paletteColor: widget.model.paletteColor,
                        disabledTextColor: widget.model.disabledTextColor,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ]
        else if (_directSearchController.text.isNotEmpty) ...[
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 8.0),
              children: [
                // User profiles section
                if (_userSearchResults.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Profile',
                      style: TextStyle(
                        fontSize: widget.model.secondaryQuestionTitleFontSize,
                        fontWeight: FontWeight.bold,
                        color: widget.model.paletteColor,
                      ),
                    ),
                  ),
                  ..._userSearchResults.map((user) {
                    final userId = user.userId.getOrCrash();
                    final isSelected = _selectedDirectUserId == userId;
                    return ChatUserTile(
                      firstName: user.legalName.value.fold((l) => '', (r) => r),
                      lastName: user.legalSurname.value.fold((l) => '', (r) => r),
                      brandName: null,
                      imageUrl: user.photoUri,
                      selected: isSelected,
                      showCheckbox: false,
                      onTap: () {
                        setState(() {
                          _selectedDirectUserId = userId;
                        });
                      },
                      paletteColor: widget.model.paletteColor,
                      disabledTextColor: widget.model.disabledTextColor,
                    );
                  }).toList(),
                ],
                // Vendor profiles section
                if (_vendorSearchResults.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Vendors & Brands',
                      style: TextStyle(
                        fontSize: widget.model.secondaryQuestionTitleFontSize,
                        fontWeight: FontWeight.bold,
                        color: widget.model.paletteColor,
                      ),
                    ),
                  ),
                  ..._vendorSearchResults.map((profile) {
                    final ownerId = profile.profileOwner.getOrCrash();
                    final isSelected = _selectedDirectUserId == ownerId;
                    return ChatUserTile(
                      firstName: profile.brandName.value.fold((l) => '', (r) => r),
                      lastName: '',
                      brandName: null,
                      imageUrl: profile.uriImage?.uriPath,
                      selected: isSelected,
                      showCheckbox: false,
                      onTap: () {
                        setState(() {
                          _selectedDirectUserId = ownerId;
                        });
                      },
                      paletteColor: widget.model.paletteColor,
                      disabledTextColor: widget.model.disabledTextColor,
                    );
                  }).toList(),
                ],
                // No results placeholder
                if (_userSearchResults.isEmpty && _vendorSearchResults.isEmpty)
                  Center(
                    child: Text(
                      'No Results Found',
                      style: TextStyle(color: widget.model.disabledTextColor),
                    ),
                  ),
              ],
            ),
          ),
        ]
        else ...[
          Center(
            child: Text(
              _directSearchController.text.isEmpty
                  ? 'Search Above to Find Someone to start a chat with'
                  : 'No Results Found',
              style: TextStyle(color: widget.model.disabledTextColor),
            ),
          ),
        ],
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: HoverButton(
            onpressed: () {
              if (_isDirectActive()) {
                _createDirectChat();
              }
            },
            animationDuration: Duration.zero,
            color: _isDirectActive()
                ? widget.model.paletteColor
                : widget.model.disabledTextColor.withOpacity(0.1),
            hoverColor: widget.model.disabledTextColor.withOpacity(0.2),
            hoverElevation: 0,
            highlightElevation: 0,
            hoverShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(35),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(35),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
            hoverPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
            elevation: 0,
            child: Center(
              child: Text(
                'Create Direct Message',
                style: TextStyle(
                  fontSize: widget.model.secondaryQuestionTitleFontSize,
                  color: _isDirectActive()
                      ? widget.model.accentColor
                      : widget.model.disabledTextColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCircleChatView(UserProfileModel profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Toggle buttons styled like HoverButton
        Row(
          children: [
            SizedBox(
              height: 40,
              child: HoverButton(
                onpressed: () => setState(() => _step = ChatCreationStep.direct),
                animationDuration: Duration.zero,
                color: _step == ChatCreationStep.direct
                    ? widget.model.paletteColor
                    : widget.model.webBackgroundColor,
                hoverColor: widget.model.disabledTextColor.withOpacity(0.2),
                hoverElevation: 0,
                highlightElevation: 0,
                hoverShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                hoverPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                elevation: 0,
                child: Text(
                  'Direct',
                  style: TextStyle(
                    color: _step == ChatCreationStep.direct
                        ? widget.model.accentColor
                        : widget.model.paletteColor,
                    fontSize: widget.model.secondaryQuestionTitleFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              height: 40,
              child: HoverButton(
                onpressed: () => setState(() => _step = ChatCreationStep.circle),
                animationDuration: Duration.zero,
                color: _step == ChatCreationStep.circle
                    ? widget.model.paletteColor
                    : widget.model.webBackgroundColor,
                hoverColor: widget.model.disabledTextColor.withOpacity(0.2),
                hoverElevation: 0,
                highlightElevation: 0,
                hoverShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                hoverPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                elevation: 0,
                child: Text(
                  ' A CIRCLE ',
                  style: TextStyle(
                    color: _step == ChatCreationStep.circle
                        ? widget.model.accentColor
                        : widget.model.paletteColor,
                    fontSize: widget.model.secondaryQuestionTitleFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            'A Circle chat is a group chat allowing multiple participants.',
            style: TextStyle(color: widget.model.disabledTextColor),
          ),
        ),
        TextField(
          controller: _circleNameController,
          decoration: InputDecoration(
            hintText: 'Circle name',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: widget.model.accentColor,
          ),
          inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _userSearchController,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search),
            hintText: 'Search Profiles',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: widget.model.accentColor,
          ),
          onChanged: (val) => _onCircleTextChanged(val),
          onSubmitted: (val) => _onCircleTextChanged(val, isSubmitted: true),
          inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
        ),
        const SizedBox(height: 16),
        // BEGIN: Selected user chips block
        if (_selectedUsersMap.isNotEmpty)
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: _selectedUsersMap.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Chip(
                    side: BorderSide.none,
                    labelPadding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 3.0),
                    shape: const StadiumBorder(),
                    backgroundColor: widget.model.accentColor,
                    label: Text(entry.value, style: TextStyle(color: widget.model.paletteColor)),
                    deleteIcon: Icon(Icons.close, color: widget.model.paletteColor),
                    onDeleted: () {
                      setState(() {
                        _selectedUsersMap.remove(entry.key);
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        // END: Selected user chips block
        // Selected count indicator
        if (_selectedUsersMap.isNotEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0, top: 4.0),
              child: Text(
                '${_selectedUsersMap.length} ${_selectedUsersMap.length == 1 ? "person" : "people"} will be in this circle',
                style: TextStyle(
                  color: widget.model.paletteColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        if (_isLoading)
          Expanded(
            child: Center(
              child: JumpingDots(
                numberOfDots: 3,
                color: widget.model.paletteColor,
              ),
            ),
          )
        else if (_userSearchController.text.isNotEmpty) ...[
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 8.0),
              children: [
                // User profiles section
                if (_userSearchResults.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text('Profiles',
                        style: TextStyle(
                            fontSize: widget.model.secondaryQuestionTitleFontSize,
                            fontWeight: FontWeight.bold,
                            color: widget.model.paletteColor)),
                  ),
                  ..._userSearchResults.map((user) {
                    final userId = user.userId.getOrCrash();
                    final isSelected = _selectedUsersMap.containsKey(userId);
                    return ChatUserTile(
                      firstName: user.legalName.value.fold((l) => '', (r) => r),
                      lastName: user.legalSurname.value.fold((l) => '', (r) => r),
                      brandName: null,
                      imageUrl: user.photoUri,
                      selected: isSelected,
                      showCheckbox: true,
                      onCheckboxChanged: (_) {
                        setState(() {
                          if (isSelected) {
                            _selectedUsersMap.remove(userId);
                          } else {
                            _selectedUsersMap[userId] =
                              '${user.legalName.value.fold((l) => '', (r) => r)} '
                              '${user.legalSurname.value.fold((l) => '', (r) => r)}';
                          }
                        });
                      },
                      paletteColor: widget.model.paletteColor,
                      disabledTextColor: widget.model.disabledTextColor,
                    );
                  }).toList(),
                ],
                // Vendor profiles section
                if (_vendorSearchResults.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text('Vendors & Brands',
                        style: TextStyle(
                            fontSize: widget.model.secondaryQuestionTitleFontSize,
                            fontWeight: FontWeight.bold,
                            color: widget.model.paletteColor)),
                  ),
                  ..._vendorSearchResults.map((profile) {
                    final ownerId = profile.profileOwner.getOrCrash();
                    final isSelected = _selectedUsersMap.containsKey(ownerId);
                    return ChatUserTile(
                      firstName: profile.brandName.value.fold((l) => '', (r) => r),
                      lastName: '',
                      brandName: null,
                      imageUrl:  profile.uriImage?.uriPath,
                      selected: isSelected,
                      showCheckbox: true,
                      onCheckboxChanged: (_) {
                        setState(() {
                          if (isSelected) {
                            _selectedUsersMap.remove(ownerId);
                          } else {
                            _selectedUsersMap[ownerId] =
                              profile.brandName.value.fold((l) => '', (r) => r);
                          }
                        });
                      },
                      paletteColor: widget.model.paletteColor,
                      disabledTextColor: widget.model.disabledTextColor,
                    );
                  }).toList(),
                ],
                // No results placeholder
                if (_userSearchResults.isEmpty && _vendorSearchResults.isEmpty)
                  Center(
                    child: Text(
                      'No Results Found',
                      style: TextStyle(color: widget.model.disabledTextColor),
                    ),
                  ),
              ],
            ),
          ),
        ]
        else ...[
          Center(
            child: Text(
              _userSearchController.text.isEmpty
                  ? 'Search Above to Find Someone to start a chat with'
                  : 'No Results Found',
              style: TextStyle(color: widget.model.disabledTextColor),
            ),
          ),
        ],
        if ((_userSearchResults.isEmpty && _vendorSearchResults.isEmpty) || _userSearchController.text.isEmpty) const Spacer(),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: HoverButton(
            onpressed: () {
              if (_isGroupActive()) {
                _createCircle(profile);
              }
            },
            animationDuration: Duration.zero,
            color: _isGroupActive()
                ? widget.model.paletteColor
                : widget.model.disabledTextColor.withOpacity(0.1),
            hoverColor: widget.model.disabledTextColor.withOpacity(0.2),
            hoverElevation: 0,
            highlightElevation: 0,
            hoverShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(35),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(35),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
            hoverPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
            elevation: 0,
            child: Text(
              'Create Group',
              style: TextStyle(
                color: _isGroupActive()
                    ? widget.model.accentColor
                    : widget.model.disabledTextColor,
                fontSize: widget.model.secondaryQuestionTitleFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}