part of check_in_presentation;

class VendorProfileCreatorEditor extends StatefulWidget {

  final DashboardModel model;
  final Function() didSaveSuccessfully;
  final Function() didCancel;
  final EventMerchantVendorProfile? selectedVendorProfile;

  const VendorProfileCreatorEditor({super.key, required this.model, required this.selectedVendorProfile, required this.didSaveSuccessfully, required this.didCancel});

  @override
  State<VendorProfileCreatorEditor> createState() => _VendorProfileCreatorEditorState();
}

class _VendorProfileCreatorEditorState extends State<VendorProfileCreatorEditor> {

  final EventMerchantVendorProfile newVendorProfile = EventMerchantVendorProfile.empty();
  final ImagePicker _imagePicker = ImagePicker();
  Image? _currentNetworkImage;
  Image? _selectedFileImage;

  @override
  void initState() {
    if (widget.selectedVendorProfile != null && widget.selectedVendorProfile!.uriImage?.uriPath != null) {
      _currentNetworkImage = Image.network(widget.selectedVendorProfile!.uriImage!.uriPath!, fit: BoxFit.cover, width: 500, height: 500);
    }
    super.initState();
  }


  String getTypeTitle(List<MerchantVendorTypes> types) {
    return 'Type';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => getIt<UpdateVendorMerchProfileBloc>()..add(UpdateVendorMerchProfileEvent.initializedVendorMerchantProfile(dart.optionOf(widget.selectedVendorProfile ?? newVendorProfile))),
      child: BlocConsumer<UpdateVendorMerchProfileBloc, UpdateVendorMerchProfileState>(
        listenWhen: (p, c) => p.isSubmitting != c.isSubmitting,
        listener: (context, state) {
          state.authFailureOrSuccessOption.fold(
                  () => {},
                  (either) => either.fold(
                          (failure) {
                            final snackBar = SnackBar(
                                backgroundColor: widget.model.webBackgroundColor,
                                content: failure.maybeMap(
                                  profileServerError: (e) => Text(e.serverResponse ?? AppLocalizations.of(context)!.serverError, style: TextStyle(color: widget.model.disabledTextColor),),
                                  orElse: () =>  Text(AppLocalizations.of(context)!.serverError, style: TextStyle(color: widget.model.disabledTextColor),),
                                )
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          },
                          (_) {
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
        buildWhen: (p, c) => p.showErrorMessages != c.showErrorMessages || p.isEditingProfile != c.isEditingProfile || p.profile != c.profile || p.isSubmitting != c.isSubmitting,
        builder: (context, state) {
          return Form(
            autovalidateMode: state.showErrorMessages,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        // color: widget.model.accentColor,
                        borderRadius: BorderRadius.circular(18)
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// logo
                        profileImageEditor(
                            widget.model,
                            'Update or Edit Logo',
                            'Add Your Brands Latest Logo',
                            _currentNetworkImage,
                            _selectedFileImage,
                            didSelectImage: () {
                              presentSelectPictureOptions(
                              context,
                              widget.model,
                              imageSource: (source) async {
                                try {
                                  final image = await _imagePicker.pickImage(source: source);

                                  if (image != null) {
                                    _selectedFileImage = Image.file(File(image.path), height: MediaQuery.of(context).size.width/2, width: MediaQuery.of(context).size.height/2, fit: BoxFit.cover);
                                    final imageFile = await image.readAsBytes();
                                    context.read<UpdateVendorMerchProfileBloc>().add(UpdateVendorMerchProfileEvent.profileImageChanged(
                                        ImageUpload(
                                            key: imageFile.toString(),
                                            imageToUpload: imageFile)
                                      )
                                    );
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
                        /// profile name
                        ListTile(
                          leading: Text('Brand Name*', style: TextStyle(color: widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                          title: Container(
                            width: MediaQuery.of(context).size.width,
                            child: TextFormField(
                              initialValue: widget.selectedVendorProfile?.brandName.value
                                  .fold((l) => l.maybeMap(textInputTitleOrDetails: (i) => i.f?.maybeWhen(invalidFacilityName: (e) => e, orElse: () => ''), orElse: () => ''), (r) => r),
                              style: TextStyle(color: widget.model.paletteColor),
                              decoration: InputDecoration(
                                hintText: 'My Brand',
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(60.0),
                                  borderSide: BorderSide(
                                    color: widget.model.disabledTextColor,
                                  ),
                                ),
                                errorStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: widget.model.paletteColor,
                                ),
                                filled: true,
                                fillColor: widget.model.accentColor,
                                focusedBorder:  OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(60.0),
                                  borderSide: BorderSide(
                                    color: widget.model.disabledTextColor,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(60.0),
                                  borderSide: const BorderSide(
                                    width: 0,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(60.0),
                                  borderSide: BorderSide(
                                    color: widget.model.webBackgroundColor,
                                    width: 0,
                                  ),
                                ),
                              ),
                              autocorrect: false,
                              onChanged: (value) {
                                context.read<UpdateVendorMerchProfileBloc>().add(UpdateVendorMerchProfileEvent.brandNameDidChange(FirstLastName(value)));
                              },
                              validator: (_) => state.profile.brandName.value
                                .fold((l) => l.maybeMap(textInputTitleOrDetails: (i) => i.f?.maybeWhen(invalidFacilityName: (e) => AppLocalizations.of(context)!.signUpDashboardPasswordConfirmError2, orElse: () => null), orElse: () => null), (r) => r),
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text('Brand Description*', style: TextStyle(color: widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                          subtitle: Container(
                            width: MediaQuery.of(context).size.width,
                            child: TextFormField(
                              maxLines: 3,
                              maxLength: state.profile.backgroundInfo.maxLength,
                              initialValue: widget.selectedVendorProfile?.backgroundInfo.value
                                  .fold((l) => l.maybeMap(textInputTitleOrDetails: (i) => i.f?.maybeWhen(invalidFacilityName: (e) => e, orElse: () => ''), orElse: () => ''), (r) => r),
                              style: TextStyle(color: widget.model.paletteColor),
                              decoration: InputDecoration(
                                hintText: 'Tell Them About Your Vision...',
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  borderSide: BorderSide(
                                    color: widget.model.disabledTextColor,
                                  ),
                                ),
                                errorStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: widget.model.paletteColor,
                                ),
                                filled: true,
                                fillColor: widget.model.accentColor,
                                focusedBorder:  OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  borderSide: BorderSide(
                                    color: widget.model.disabledTextColor,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  borderSide: const BorderSide(
                                    width: 0,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  borderSide: BorderSide(
                                    color: widget.model.webBackgroundColor,
                                    width: 0,
                                  ),
                                ),
                              ),
                              autocorrect: false,
                              onChanged: (value) {
                                context.read<UpdateVendorMerchProfileBloc>().add(UpdateVendorMerchProfileEvent.descriptionDidChange(BackgroundInfoDescription(value)));
                              },
                              validator: (_) =>
                                   state
                                  .profile.backgroundInfo.value
                                  .fold((l) => l.maybeMap(textInputTitleOrDetails: (i) => i.f?.maybeWhen(invalidFacilityName: (e) => AppLocalizations.of(context)!.signUpDashboardPasswordConfirmError2, orElse: () => null), orElse: () => null), (r) => r),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            runSpacing: 6,
                            spacing: 8,
                            children: MerchantVendorTypes.values.map(
                              (e) => InkWell(
                                onTap: () {

                                  List<MerchantVendorTypes> types = [];
                                  types.addAll(state.profile.type ?? []);

                                  if (types.contains(e) == true) {
                                    types.remove(e);
                                  } else {
                                    types.add(e);
                                  }


                                  context.read<UpdateVendorMerchProfileBloc>().add(UpdateVendorMerchProfileEvent.typesDidChange(types));
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                      color: (state.profile.type?.contains(e) ?? false) ? widget.model.paletteColor : widget.model.accentColor,
                                        borderRadius: BorderRadius.circular(18)
                                    ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(getVendorMerchTitle(e), style: TextStyle(color: (state.profile.type?.contains(e) ?? false) ? widget.model.accentColor : widget.model.disabledTextColor)),
                                  )
                                ),
                              )
                            ).toList(),
                          ),
                        ),
                        ListTile(
                          title: Text('Instagram', style: TextStyle(color: widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                          subtitle: Container(
                            width: MediaQuery.of(context).size.width,
                            child: TextFormField(
                              initialValue: widget.selectedVendorProfile?.instagramLink,
                              style: TextStyle(color: widget.model.paletteColor),
                              decoration: InputDecoration(
                                prefixIcon: Icon(CupertinoIcons.photo_camera, color: widget.model.disabledTextColor),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(60.0),
                                  borderSide: BorderSide(
                                    color: widget.model.disabledTextColor,
                                  ),
                                ),
                                prefixStyle: TextStyle(
                                  fontSize: 16,
                                  color: widget.model.disabledTextColor,
                                ),
                                prefixText: 'instagram.com/',
                                errorStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: widget.model.paletteColor,
                                ),
                                filled: true,
                                fillColor: widget.model.accentColor,
                                focusedBorder:  OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(60.0),
                                  borderSide: BorderSide(
                                    color: widget.model.disabledTextColor,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(60.0),
                                  borderSide: const BorderSide(
                                    width: 0,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(60.0),
                                  borderSide: BorderSide(
                                    color: widget.model.webBackgroundColor,
                                    width: 0,
                                  ),
                                ),
                              ),
                              autocorrect: false,
                              onChanged: (value) {
                                context.read<UpdateVendorMerchProfileBloc>().add(UpdateVendorMerchProfileEvent.instagramContactChanged(value));
                              },
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text('Website', style: TextStyle(color: widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                          subtitle: Container(
                            width: MediaQuery.of(context).size.width,
                            child: TextFormField(
                              initialValue: widget.selectedVendorProfile?.websiteLink,
                              style: TextStyle(color: widget.model.paletteColor),
                              decoration: InputDecoration(
                                prefixIcon: Icon(CupertinoIcons.globe, color: widget.model.disabledTextColor),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(60.0),
                                  borderSide: BorderSide(
                                    color: widget.model.disabledTextColor,
                                  ),
                                ),
                                prefixStyle: TextStyle(
                                  fontSize: 16,
                                  color: widget.model.disabledTextColor,
                                ),
                                prefixText: 'https://www.',
                                errorStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: widget.model.paletteColor,
                                ),
                                filled: true,
                                fillColor: widget.model.accentColor,
                                focusedBorder:  OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(60.0),
                                  borderSide: BorderSide(
                                    color: widget.model.disabledTextColor,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(60.0),
                                  borderSide: const BorderSide(
                                    width: 0,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(60.0),
                                  borderSide: BorderSide(
                                    color: widget.model.webBackgroundColor,
                                    width: 0,
                                  ),
                                ),
                              ),
                              autocorrect: false,
                              onChanged: (value) {
                                context.read<UpdateVendorMerchProfileBloc>().add(UpdateVendorMerchProfileEvent.websiteURLChanged(value));
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  saveCancelFooter(
                    widget.model,
                    state.isSubmitting,
                    (widget.selectedVendorProfile != null) ? widget.selectedVendorProfile != state.profile : newVendorProfile != state.profile,
                    vendorProfileIsValid(state.profile),
                    widget.selectedVendorProfile != null,
                    didSelectSave: () {
                      context.read<UpdateVendorMerchProfileBloc>().add(UpdateVendorMerchProfileEvent.isSubmitting(true));
                      context.read<UpdateVendorMerchProfileBloc>().add(UpdateVendorMerchProfileEvent.saveVendorProfileFinished());
                    },
                    didSelectCancel: () {
                      widget.didCancel();
                    },
                    didSelectDelete: () {

                      presentALertDialogMobile(
                        context,
                        'Delete Profile?',
                        'Are you sure you want to delete this profile?',
                        'Delete',
                        didSelectDone: () {
                          context.read<UpdateVendorMerchProfileBloc>().add(UpdateVendorMerchProfileEvent.deleteVendorProfileFinished());
                        }
                      );


                    }
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}