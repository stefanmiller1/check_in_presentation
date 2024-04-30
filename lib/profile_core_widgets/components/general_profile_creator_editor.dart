part of check_in_presentation;

class GeneralProfileCreatorEditor extends StatefulWidget {

  final DashboardModel model;
  final UserProfileModel currentUser;
  final Function() didSaveSuccessfully;
  final Function() didCancel;

  const GeneralProfileCreatorEditor({super.key, required this.model, required this.currentUser, required this.didSaveSuccessfully, required this.didCancel});

  @override
  State<GeneralProfileCreatorEditor> createState() => _GeneralProfileCreatorEditorState();
}

class _GeneralProfileCreatorEditorState extends State<GeneralProfileCreatorEditor> {

  final ImagePicker _imagePicker = ImagePicker();
  Image? _currentNetworkSpaceImage;
  Image? _selectedFileSpaceImage;

  @override
  void initState() {
    if (widget.currentUser.profileImage != null) {
      _currentNetworkSpaceImage  = Image(image: widget.currentUser.profileImage!.image, fit: BoxFit.cover);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => getIt<UpdateUserProfileAccountBloc>()..add(UpdateUserProfileAccountEvent.initializedUserProfile(dart.optionOf(widget.currentUser))),
      child: BlocConsumer<UpdateUserProfileAccountBloc, UpdateUserProfileAccountState>(
        listenWhen:(p,c) => p.isSubmitting != c.isSubmitting,
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
              }
            )
          );
        },
        buildWhen: (p,c) => p.showErrorMessages != c.showErrorMessages || p.profile != c.profile || p.isEditingProfile != c.isEditingProfile || p.isSubmitting != c.isSubmitting,
        builder: (context, state) {
          print(isProfileItemValid(state.profile));

          return Form(
            autovalidateMode: state.showErrorMessages,
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
             child: Column(
               children: [

                 profileImageEditor(
                   widget.model,
                   'Update Profile Image',
                   'Add Your Photo',
                   _currentNetworkSpaceImage,
                   _selectedFileSpaceImage,
                   didSelectImage: () {
                     presentSelectPictureOptions(
                         context,
                         widget.model,
                         imageSource: (source) async {
                           try {
                             final image = await _imagePicker.pickImage(source: source);


                             if (image != null) {
                               final imageFile = await image.readAsBytes();

                               _selectedFileSpaceImage = Image.file(File(image.path), height: MediaQuery.of(context).size.width/2, width: MediaQuery.of(context).size.height/2, fit: BoxFit.cover);
                               context.read<UpdateUserProfileAccountBloc>().add(UpdateUserProfileAccountEvent.imageFilePathChanged(ImageUpload(
                                   key: imageFile.toString(),
                                   imageToUpload: imageFile)
                               ));

                             }
                           } catch (e) {
                             final snackBar = SnackBar(
                                 backgroundColor: widget.model.webBackgroundColor,
                                 content: Text(e.toString() ?? 'Sorry, Could not get image', style: TextStyle(color: widget.model.paletteColor))
                             );
                             ScaffoldMessenger.of(context).showSnackBar(snackBar);
                       }
                     });
                   }
                 ),

                 /// first name...
                 /// last name...
                 /// birthday ...

                 const SizedBox(height: 8),
                 saveCancelFooter(
                     widget.model,
                     state.isSubmitting,
                     widget.currentUser != state.profile.profileUser || state.isEditingProfile,
                     isProfileItemValid(state.profile),
                     false,
                     didSelectSave: () {
                       context.read<UpdateUserProfileAccountBloc>()..add(UpdateUserProfileAccountEvent.finishedUpdatingUserProfile());
                     },
                     didSelectCancel: () {
                        widget.didCancel();
                     },
                     didSelectDelete: () {

                   }
                 ),

               ],
             ),
            ),
          );
        }
      ),
    );
  }
}