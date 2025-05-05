part of check_in_presentation;

class SendNewChatContainer extends StatefulWidget {

  final NewMessageTypes messageType;
  final bool showHeader;
  final UserProfileModel userProfile;
  final ReservationItem? reservation;
  final EventMerchantVendorProfile? eventMerchantVendorProfile;
  final DashboardModel model;

  const SendNewChatContainer({super.key, required this.messageType, required this.model, required this.showHeader, this.reservation, this.eventMerchantVendorProfile, required this.userProfile});

  @override
  State<SendNewChatContainer> createState() => _SendNewChatContainerState();
}

class _SendNewChatContainerState extends State<SendNewChatContainer> {
  
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFieldFocusNode = FocusNode();
  bool _isMessageSent = false;
  bool _isSending = false;
  String? roomId = null;

  void _sendMessage(SendNewChatMessage chat, UserProfileModel currentUser) async {
    setState(() => _isSending = true);

    try {

        final room = await facade.FirebaseChatCore.instance.createDirectRoom(
          widget.userProfile.userId.getOrCrash(),
          'Chat',
          null
        );
        roomId = room.id;

        if (chat.systemMessage != null) {
           facade.FirebaseChatCore.instance.sendMessage(
            chat.systemMessage,
            null,
            room.id,
          );
        }

        facade.FirebaseChatCore.instance.sendMessage(
          types.PartialText(text: _textController.text.trim()),
          null,
          room.id,
        );

        final Map<String, dynamic> metada = {
          'status': 'done',
          'link': chatWithIdRoute(room.id)
        };

        facade.FirebaseChatCore.instance.sendDirectNotifications(
          [widget.userProfile.userId.getOrCrash()],
           currentUser.legalName.getOrCrash(),
           types.PartialText(text: _textController.text.trim()),
           chatWithIdRoute(room.id),
           metada
        );
      

    } catch (e) {
      setState(() => _isSending = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send message'), backgroundColor: Colors.red),
      );
    }

    // On successful sending:
    setState(() {
      _isSending = false;
      _isMessageSent = true;
    });
  }

 void _openChat(UserProfileModel currentUser) {
  if (roomId != null) {
    Navigator.of(context).pop(); // Close the dialog first
    didSelectOpRoom(context, widget.model, currentUser,  roomId!);
  }
 }

  @override
  void initState() {  
    super.initState();
    // if (!kIsWeb) {
      _textFieldFocusNode.addListener(() {
        print('Focus changed: ${_textFieldFocusNode.hasFocus}');
        if (_textFieldFocusNode.hasFocus) {
            Future.delayed(const Duration(milliseconds: 300), () {
              if (_scrollController.hasClients) {
                _scrollController.animateTo(
                  _scrollController.position.maxScrollExtent + 150, // extra padding
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            });
          }
      });
    // }
  }

  void dispose() {
    _scrollController.dispose();
    _textFieldFocusNode.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: (kIsWeb) ? Colors.transparent : null,
      appBar: (widget.showHeader == true) ? AppBar(
          backgroundColor: (widget.model.systemTheme.brightness != Brightness.dark) ? widget.model.paletteColor : widget.model.mobileBackgroundColor,
          elevation: 0,
          automaticallyImplyLeading: true,
          centerTitle: true,
          toolbarHeight: 80,
          title: Text('New Message'),
          leading: IconButton(onPressed: () => Navigator.of(context).pop(), icon: Icon(Icons.cancel, size: 40, color:  (widget.model.systemTheme.brightness != Brightness.dark) ? widget.model.accentColor : widget.model.paletteColor), padding: EdgeInsets.zero),
          titleTextStyle: TextStyle(color: (widget.model.systemTheme.brightness != Brightness.dark) ? widget.model.accentColor : widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold),
        ) : null,
        body: BlocProvider(create: (_) => getIt<UserProfileWatcherBloc>()..add(const UserProfileWatcherEvent.watchUserProfileStarted()),
          child: BlocBuilder<UserProfileWatcherBloc, UserProfileWatcherState>(
            builder: (context, authState) {
              return authState.maybeMap(
                  loadInProgress: (_) => JumpingDots(color: widget.model.paletteColor, numberOfDots: 3),
                  loadProfileFailure: (_) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GetLoginSignUpWidget(showFullScreen: true, model: widget.model, didLoginSuccess: () {  },),
                  ),
                  loadUserProfileSuccess: (item) {
                    if (_isMessageSent) {
                      if (_isSending) {
                          _sendingView();
                      } else {
                        _buildComposeMessageView(item.profile);
                      }
                      return _messageSentView(item.profile);
                    }
                    return  _buildComposeMessageView(item.profile);
                  },
                  orElse: () {
                    return JumpingDots(color: widget.model.paletteColor, numberOfDots: 3);
              }
            );
          },
        )
      )
    );
  }

  // _isMessageSent
  //           ? _messageSentView()
  //           : _isSending
  //               ? _sendingView()
  //               : _buildComposeMessageView(preset),

  Widget _messageSentView(UserProfileModel currentUser) {
      return Center(
        key: ValueKey('sent'),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline, size: 100, color: Colors.green),
            SizedBox(height: 20),
            Text('Message Sent!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: widget.model.paletteColor)),
            SizedBox(height: 20),
            Container(
              height: 50,
              child: HoverButton(
                onpressed: () => _openChat(currentUser),
                color: widget.model.accentColor,
                animationDuration: Duration.zero,
                hoverColor: widget.model.disabledTextColor.withOpacity(0.2),
                hoverElevation: 0,
                highlightElevation: 0,
                hoverShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
                ),
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                hoverPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0), // Same as default padding
                elevation: 0,
                child: Text('Open Chat', style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize)),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: 50,
              child: HoverButton(
                onpressed: () {
                  Navigator.of(context).pop();
                },
                color: widget.model.accentColor,
                animationDuration: Duration.zero,
                hoverColor: widget.model.disabledTextColor.withOpacity(0.2),
                hoverElevation: 0,
                highlightElevation: 0,
                hoverShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
                ),
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                hoverPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0), // Same as default padding
                elevation: 0,
                child: Text('Close', style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize)),
              ),
            ),
          ],
        ),
      );
    }


  Widget _sendingView() {
    return Center(
      key: ValueKey('sending'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          JumpingDots(color: widget.model.paletteColor, numberOfDots: 3),
          SizedBox(height: 10),
          Text('Sending...', style: TextStyle(color: widget.model.paletteColor, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildComposeMessageView(UserProfileModel currentUser) {
    final preset = getPresetMessages(
      reservation: widget.reservation,
      eventMerchantVendorProfile: widget.eventMerchantVendorProfile, 
      currentUserName: currentUser.legalName.getOrCrash(),
    ).firstWhere((p) => p.messageType == widget.messageType, orElse: () => getPresetMessages(
      reservation: widget.reservation,
      eventMerchantVendorProfile: widget.eventMerchantVendorProfile, 
      currentUserName: currentUser.legalName.getOrCrash()).first);
    
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SingleChildScrollView(
            controller: _scrollController,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      if (widget.eventMerchantVendorProfile == null ) profileHeaderContainer(
                        widget.userProfile,
                        widget.model,
                        false,
                        null,
                        null,
                        widget.userProfile.userId.getOrCrash(),
                        editProfile: () {},
                        didSelectShare: () {},
                      ),
                      if (widget.eventMerchantVendorProfile != null) getVendorMerchProfileHeader(
                        widget.model, 
                        false,
                        widget.eventMerchantVendorProfile!,
                        null,
                        didSelectShare: () {},
                        didSelectAddPartners: () {},
                        didSelectEdit: () {},
                      ),
                  
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Divider(),
                      ),
                      Text("What others ask:", style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                      Text("Select from one of the questions below then press Send Message", style: TextStyle(color: widget.model.disabledTextColor)),
                      const SizedBox(height: 12),
                        ...preset.sampleQuestions.asMap().entries.map((entry) {
                            final index = entry.key;
                            final question = entry.value;
                      
                            return Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                height: 40,
                                margin: const EdgeInsets.symmetric(vertical: 2),
                                child: HoverButton(
                                  onpressed: () {
                                    setState(() {
                                      _textController.text = question;
                                    });
                                  },
                                  animationDuration: Duration.zero,
                                  color: widget.model.paletteColor,
                                  hoverColor: widget.model.disabledTextColor.withOpacity(0.2),
                                  hoverElevation: 0,
                                  highlightElevation: 0,
                                  hoverShape: RoundedRectangleBorder(
                                    borderRadius: getBorderRadiusForIndex(index, preset.sampleQuestions.length),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: getBorderRadiusForIndex(index, preset.sampleQuestions.length),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                  hoverPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                  elevation: 0,
                                  child: Text(
                                    question,
                                    style: TextStyle(color: widget.model.accentColor),
                                  ),
                                ),
                              ),
                            );
                        }),
                      if (preset.possibleAnswers != null) ...[
                        const SizedBox(height: 12),
                        Text("Possible Answers:", style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
                        ...preset.possibleAnswers!.map((a) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 1),
                              child: Text("- $a", style: TextStyle(color: widget.model.disabledTextColor)),
                          )),
                      ],
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Divider(),
                      ),
                      const SizedBox(height: 16),
                      Text('Still have a Question?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize, color: widget.model.paletteColor)),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _textController,
                        focusNode: _textFieldFocusNode,
                        maxLines: 3,
                        style: TextStyle(color: widget.model.paletteColor),
                        decoration: InputDecoration(
                          hintText: preset.hintText,
                          filled: true,
                          fillColor: widget.model.accentColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {});
                        } 
                      ),
                      const SizedBox(height: 60),
                      
                ],
              ),
            ),
          ),
      
          // if (_textFieldFocusNode.hasFocus == false) Container(
          //   height: 60,
          //   width: MediaQuery.of(context).size.width,
          //   color: widget.model.webBackgroundColor,
          // ),
      
          if (_textFieldFocusNode.hasFocus == false && !kIsWeb) Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
            child: Container(
              height: 60,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  if (_textController.text.trim().isEmpty) Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: widget.model.accentColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text('Send Message', textAlign: TextAlign.center, style: TextStyle(color: widget.model.paletteColor)),
                            ),
                          ),
                        ),
                        if (_textController.text.trim().isNotEmpty) Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            child: HoverButton(
                              onpressed: () {
                                if (_textController.text.trim().isEmpty) {
                                  return;
                                }
                                _sendMessage(preset, currentUser);
                              },
                              animationDuration: Duration.zero,
                              color: widget.model.paletteColor,
                              hoverColor: widget.model.disabledTextColor.withOpacity(0.7),
                              hoverElevation: 0,
                              highlightElevation: 0,
                              hoverShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                              hoverPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0), // Same as default padding
                              elevation: 0,
                              child: Text('Send Message', textAlign: TextAlign.center, style: TextStyle(color: widget.model.accentColor))
                      )
                    ),
                ]
              ),
            ),
          )
        ],
      ),
    );
  }
}