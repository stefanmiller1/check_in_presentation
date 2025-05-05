part of check_in_presentation;

class GeneralProfileCreatorEditor extends StatefulWidget {

  final DashboardModel model;
  final UserProfileModel currentUser;
  final Widget? headerWidget;
  final bool? hideCancel;
  final Function() didSaveSuccessfully;
  final Function() didCancel;

  const GeneralProfileCreatorEditor({super.key, required this.model, required this.currentUser, required this.didSaveSuccessfully, required this.didCancel, this.hideCancel, this.headerWidget});

  @override
  State<GeneralProfileCreatorEditor> createState() => _GeneralProfileCreatorEditorState();
}

class _GeneralProfileCreatorEditorState extends State<GeneralProfileCreatorEditor> {

  @override
  void initState() {
    // if (widget.currentUser.profileImage != null) {
    //   _currentNetworkSpaceImage  = Image(image: widget.currentUser.profileImage!.image, fit: BoxFit.cover);
    // }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => getIt<UpdateUserProfileAccountBloc>()..add(UpdateUserProfileAccountEvent.initializedUserProfile(dart.optionOf(widget.currentUser))),
      child: BlocConsumer<UpdateUserProfileAccountBloc, UpdateUserProfileAccountState>(
        listenWhen:(p,c) => p.isSubmitting != c.isSubmitting || p.authFailureOrSuccessOption != c.authFailureOrSuccessOption,
        listener: (context, state) {
          state.authFailureOrSuccessOption.fold(
                  () {},
                  (either) => either.fold(
                      (failure) {
                    final snackBar = SnackBar(
                        backgroundColor: widget.model.webBackgroundColor,
                        content: failure.maybeMap(
                          // cancelledByUser: (_) => Text(AppLocalizations.of(context)!.loginFailuresCancelled, style: TextStyle(color: widget.model.disabledTextColor),),
                          insufficientPermission: (_) => Text(AppLocalizations.of(context)!.serverError, style: TextStyle(color: widget.model.disabledTextColor),),
                          serverError: (_) => Text(AppLocalizations.of(context)!.serverError, style: TextStyle(color: widget.model.disabledTextColor),),
                          orElse: () =>  Text(AppLocalizations.of(context)!.serverError, style: TextStyle(color: widget.model.disabledTextColor),),
                        )
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }, (_) {
                final snackBar = SnackBar(
                    elevation: 4,
                    backgroundColor: widget.model.paletteColor,
                    content: Text(AppLocalizations.of(context)!.saved, style: TextStyle(color: widget.model.webBackgroundColor))
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                widget.didSaveSuccessfully();
                didSelectRefresh();
              }
            )
          );
        },
        buildWhen: (p,c) => p.showErrorMessages != c.showErrorMessages || p.profile != c.profile || p.isEditingProfile != c.isEditingProfile || p.isSubmitting != c.isSubmitting,
        builder: (context, state) {

          return Form(
            autovalidateMode: state.showErrorMessages,
            child: Stack(
              children: [
               SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                ),
                SingleChildScrollView(
                  // physics: const NeverScrollableScrollPhysics(),
                 child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                    if (widget.headerWidget != null) Center(
                      child: widget.headerWidget!
                    ),
                     const SizedBox(height: 18),
                     Center(
                       child: ProfileImageUploadPreview(
                           model: widget.model,
                           title: 'Update or Edit Image',
                           subTitle: 'Add Your Photo',
                           currentNetworkImage: ImageUpload(key: widget.currentUser.photoUri ?? 'photoId', uriPath: widget.currentUser.photoUri),
                           imageToUpLoad: (currentImage) {
                             context.read<UpdateUserProfileAccountBloc>().add(UpdateUserProfileAccountEvent.imageFilePathChanged(currentImage));
                         }
                       ),
                     ),
                
                     /// first name...
                     const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0),
                        child: Text('First Name*',
                          style: TextStyle(
                            fontSize: widget.model.secondaryQuestionTitleFontSize,
                            color: widget.model.paletteColor,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      const SizedBox(height: 10),
                
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: TextFormField(
                                style: TextStyle(color: widget.model.paletteColor),
                                initialValue: widget.currentUser
                                    .legalName
                                    .value
                                    .fold((l) => l.maybeMap(userProfile: (e) => e.f?.maybeMap(invalidLegalName: (i) => i.failedValue, orElse: () => '' ), orElse: () => ''), (r) => r),
                                decoration: InputDecoration(
                                  hintText: 'First Name',
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
                                      color: widget.model.paletteColor,
                                    ),
                                  ),
                                  focusedBorder:  OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide: BorderSide(
                                      color: widget.model.disabledTextColor,
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
                                      color: widget.model.webBackgroundColor,
                                      width: 0,
                                    ),
                                  ),
                                ),
                                autocorrect: false,
                                onChanged: (value) => context.read<UpdateUserProfileAccountBloc>().add(UpdateUserProfileAccountEvent.firstLastLegalNameChanged(value)),
                                validator: (_) => context
                                    .read<UpdateUserProfileAccountBloc>()
                                    .state
                                    .profile
                                    .profileUser
                                    .legalName
                                    .value
                                    .fold(
                                        (f) => f.maybeMap(
                                      userProfile: (u) => u.f?.maybeMap(
                                          empty: (_) => AppLocalizations.of(context)!.signUpDashboardError,
                                          invalidLegalName: (_) => AppLocalizations.of(context)!.signUpDashboardPasswordConfirmError2,
                                          orElse: () => null),
                                      orElse: () => null,
                                    ),
                                        (_) => null
                                )
                            )
                        ),
                      ),
                     /// last name...
                     const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0),
                        child: Text('Last Name*',
                          style: TextStyle(
                            fontSize: widget.model.secondaryQuestionTitleFontSize,
                            color: widget.model.paletteColor,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      const SizedBox(height: 10),
                
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: TextFormField(
                                style: TextStyle(color: widget.model.paletteColor),
                                initialValue: widget.currentUser
                                    .legalSurname
                                    .value
                                    .fold((l) => l.maybeMap(userProfile: (e) => e.f?.maybeMap(invalidLegalName: (i) => i.failedValue, orElse: () => '' ), orElse: () => ''), (r) => r),
                                decoration: InputDecoration(
                                  hintText: 'Last Name',
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
                                      color: widget.model.paletteColor,
                                    ),
                                  ),
                                  focusedBorder:  OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide: BorderSide(
                                      color: widget.model.disabledTextColor,
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
                                      color: widget.model.webBackgroundColor,
                                      width: 0,
                                    ),
                                  ),
                                ),
                                autocorrect: false,
                                onChanged: (value) => context.read<UpdateUserProfileAccountBloc>().add(UpdateUserProfileAccountEvent.lastNameLegalChanged(value)),
                                validator: (_) => context
                                    .read<UpdateUserProfileAccountBloc>()
                                    .state
                                    .profile
                                    .profileUser
                                    .legalSurname
                                    .value
                                    .fold(
                                        (f) => f.maybeMap(
                                      userProfile: (u) => u.f?.maybeMap(
                                          empty: (_) => AppLocalizations.of(context)!.signUpDashboardError,
                                          invalidLegalName: (_) => AppLocalizations.of(context)!.signUpDashboardPasswordConfirmError2,
                                          orElse: () => null),
                                      orElse: () => null,
                                    ),
                                        (_) => null
                                )
                            )
                        ),
                      ),
                      const SizedBox(height: 80),
                     /// birthday ...
                   ],
                 ),
                ),
                Positioned(
                  bottom: 8,
                  right: 0,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: saveCancelFooter(
                          context,
                          widget.model,
                          state.isSubmitting,
                          widget.currentUser != state.profile.profileUser && state.isEditingProfile,
                          isProfileItemValid(state.profile),
                          false,
                          widget.hideCancel,
                          didSelectSave: () {
                            context.read<UpdateUserProfileAccountBloc>()..add(const UpdateUserProfileAccountEvent.finishedUpdatingUserProfile());
                          },
                          didSelectCancel: () {
                            widget.didCancel();
                          },
                          didSelectDelete: () {
              
                        }
                      ),
                    ),
                )
              ],
            ),
          );
        }
      ),
    );
  }
}