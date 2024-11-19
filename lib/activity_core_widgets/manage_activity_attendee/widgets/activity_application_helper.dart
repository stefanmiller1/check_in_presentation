part of check_in_presentation;

enum VendorApplicationBoothOptions {
  selectAll,
  previewPdf,
  previewReceipt,
  previewRefund,
  previewStatus,
}

extension VendorActionExtension on VendorApplicationBoothOptions {
  String get displayName {
    switch (this) {
      case VendorApplicationBoothOptions.selectAll:
        return 'Select All';
      case VendorApplicationBoothOptions.previewPdf:
        return 'Preview PDF';
      case VendorApplicationBoothOptions.previewReceipt:
        return 'Preview Receipt';
      case VendorApplicationBoothOptions.previewRefund:
        return 'Preview Refund';
      case VendorApplicationBoothOptions.previewStatus:
        return 'Change Status';
    }
  }


  bool isAvailable(AttendeeItem currentAttendee, bool editing) {
    final hasConfirmed = currentAttendee.vendorForm?.boothPaymentOptions?.map((e) => e.status).contains(AvailabilityStatus.confirmed) == true;
    final hasRefunded = currentAttendee.vendorForm?.boothPaymentOptions?.map((e) => e.status).contains(AvailabilityStatus.refunded) == true;
    final hasDocuments = (currentAttendee.vendorForm != null) ? isDocumentsOptionValid(currentAttendee.vendorForm!) : false;

    switch (this) {
      case VendorApplicationBoothOptions.selectAll:
        return editing;
      case VendorApplicationBoothOptions.previewPdf:
        return hasDocuments;
      case VendorApplicationBoothOptions.previewReceipt:
        return hasConfirmed;
      case VendorApplicationBoothOptions.previewRefund:
        return hasRefunded;
      case VendorApplicationBoothOptions.previewStatus:
        return true;
    }
  }
}



bool vendorCanEditForm(List<VendorContactDetail> attending) => attending.map((e) => e.boothItem.status).contains(AvailabilityStatus.requested);

Widget getRowForBoothOption(BuildContext context, DashboardModel model, bool isOwner, String currency, VendorContactDetail vendorDetail, int index, MCCustomAvailability? availability, bool? isSelected, bool showEdit, {required Function() didSelectEdit}) {
  return Container(
    height: 40,
    // width: 530,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (Responsive.isMobile(context)) Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: rowItems(context, model, isOwner, currency, vendorDetail, index, availability)
          ),
        ),

        if (Responsive.isMobile(context) == false) Expanded(
          child: rowItems(context, model, isOwner, currency, vendorDetail, index, availability)
        ),

        Row(
          children: [
            boothStatusButton(
              model,
              vendorDetail.boothItem.status,
            ),
            const SizedBox(width: 8),
            Visibility(
                visible: showEdit,
                child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(width: 2, color: model.paletteColor)
                  ),
                  child: InkWell(
                    onTap: () {
                      didSelectEdit();

                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: (isSelected == true) ? model.paletteColor : Colors.transparent,
                      ),
                    ),
                  ),
                ),
              )
            )
          ],
        )
      ],
    )
  );
}


Widget rowItems(BuildContext context, DashboardModel model, bool isOwner, String currency, VendorContactDetail vendorDetail, int index, MCCustomAvailability? availability) {
  final bool hasDiscount = vendorDetail.boothItem.stripePaymentIntent?.discountCode != null;
  final taxPercentage = null;
  final totalFeeDiscount = (((vendorDetail.boothItem.fee?.toDouble() ?? 0) * (1 - ((vendorDetail.boothItem.stripePaymentIntent?.discountCode?.discountAmount ?? 1) / 100)))).toInt();
  final totalTaxAmountDiscount = totalFeeDiscount * (taxPercentage ?? CICOTaxesFee);
  final sellerFeeDiscount = totalFeeDiscount * CICOSellerPercentageFee;
  final sellerTaxAmountDiscount = sellerFeeDiscount * (taxPercentage ?? CICOTaxesFee);
  final buyerFeeDiscount = totalFeeDiscount * CICOBuyerPercentageFee;
  final totalBuyerTaxAmountDiscount = buyerFeeDiscount * (taxPercentage ?? CICOTaxesFee);

  final totalFee = vendorDetail.boothItem.fee?.toDouble() ?? 0;
  final totalTaxAmount = totalFee * (taxPercentage ?? CICOTaxesFee);
  final sellerFee = totalFee * CICOSellerPercentageFee;
  final sellerTaxAmount = sellerFee * (taxPercentage ?? CICOTaxesFee);
  final buyerFee = totalFee * CICOBuyerPercentageFee;
  final totalBuyerTaxAmount = buyerFee * (taxPercentage ?? CICOTaxesFee);

  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      /// booth name
      Icon(Icons.note_alt_outlined, size: 25, color: model.disabledTextColor),
      const SizedBox(width: 8),
      /// booth name
      Flexible(
        child: Chip(
          side: BorderSide.none,
          backgroundColor: model.webBackgroundColor,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          label: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text((availability == null) ? 'All Dates' : (availability.dateTitle != null) ? availability.dateTitle! : 'Covers ${availability.selectedSlotItem.length} Dates', style: TextStyle(color: model.paletteColor, overflow: TextOverflow.ellipsis), maxLines: 1),
          ),
          avatar: Icon(Icons.calendar_month_rounded, size: 25, color: model.paletteColor),
        ),
      ),
      const SizedBox(width: 8),
      /// booth name
      Flexible(
        child: Chip(
          side: BorderSide.none,
          backgroundColor: model.webBackgroundColor,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          label: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text((vendorDetail.boothItem.boothTitle != null) ? vendorDetail.boothItem.boothTitle! : 'Booth ${(index + 1)}', style: TextStyle(color: model.paletteColor, overflow: TextOverflow.ellipsis), maxLines: 1),
          ),
          avatar: Icon(Icons.storefront, size: 25, color: model.paletteColor),
        ),
      ),
      const SizedBox(width: 8),

      // if (Responsive.isMobile(context)) Chip(
      //   side: BorderSide.none,
      //   backgroundColor: model.webBackgroundColor,
      //   padding: EdgeInsets.zero,
      //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      //   materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      //   labelPadding: EdgeInsets.zero,
      //   label: Padding(
      //     padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      //     child: Text((vendorDetail.boothItem.fee != null) ? completeTotalPriceWithCurrency(
      //         vendorDetail.boothItem.fee!.toDouble() +
      //         vendorDetail.boothItem.fee!.toDouble()*CICOBuyerPercentageFee +
      //         vendorDetail.boothItem.fee!.toDouble()*CICOTaxesFee, currency) : 'Free', style: TextStyle(color: model.paletteColor, overflow: TextOverflow.ellipsis), maxLines: 1),
      //   ),
      // ),

      /// fee
      if (isOwner == false) Chip(
        side: BorderSide.none,
        backgroundColor: model.webBackgroundColor,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        labelPadding: EdgeInsets.zero,
        label: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          child: Text((vendorDetail.boothItem.fee != null) ? completeTotalPriceWithCurrency(totalFee + totalTaxAmount + buyerFee + totalBuyerTaxAmount, currency) :
          'Free', style: TextStyle(color: model.paletteColor, decoration: (hasDiscount) ? TextDecoration.lineThrough : null, overflow: TextOverflow.ellipsis), maxLines: 1),
        ),
      ) else Chip(
        side: BorderSide.none,
        backgroundColor: model.webBackgroundColor,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        labelPadding: EdgeInsets.zero,
        label: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          child: Text((vendorDetail.boothItem.fee != null) ? completeTotalPriceWithCurrency(vendorDetail.boothItem.fee!.toDouble() - (sellerFee + sellerTaxAmount) + totalTaxAmount, currency) :
          'Free', style: TextStyle(color: model.paletteColor, decoration: (hasDiscount) ? TextDecoration.lineThrough : null, overflow: TextOverflow.ellipsis), maxLines: 1),
        ),
      ),

      const SizedBox(width: 8),
      if (hasDiscount) Chip(
        side: BorderSide.none,
        backgroundColor: (isOwner) ? Colors.red.withOpacity(0.24) : Colors.lightGreen.withOpacity(0.24),
        padding: EdgeInsets.zero,
        avatar: Icon(Icons.discount_outlined, size: 25, color: (isOwner) ? Colors.red : Colors.green),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        labelPadding: EdgeInsets.zero,
        label: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          child: Text('${vendorDetail.boothItem.stripePaymentIntent?.discountCode?.discountAmount ?? 0}%', style: TextStyle(color: (isOwner) ? Colors.red : Colors.green, overflow: TextOverflow.ellipsis), maxLines: 1),
        ),
      ),
      const SizedBox(width: 8),
      ///has discount
      if (isOwner == false && hasDiscount) Chip(
        side: BorderSide.none,
        backgroundColor: Colors.lightGreen.withOpacity(0.24),
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        labelPadding: EdgeInsets.zero,
        label: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          child: Text((vendorDetail.boothItem.fee != null) ? completeTotalPriceWithCurrency(totalFeeDiscount + totalTaxAmountDiscount + buyerFeeDiscount + totalBuyerTaxAmountDiscount, currency) :
          'Free', style: const TextStyle(color: Colors.green, overflow: TextOverflow.ellipsis), maxLines: 1),
        ),
      ),
      if (isOwner && hasDiscount) Chip(
        side: BorderSide.none,
        backgroundColor:  Colors.red.withOpacity(0.24),
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        labelPadding: EdgeInsets.zero,
        label: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          child: Text((vendorDetail.boothItem.fee != null) ? completeTotalPriceWithCurrency(totalFeeDiscount - (sellerFeeDiscount + sellerTaxAmountDiscount) + totalTaxAmountDiscount, currency) :
          'Free', style: const TextStyle(color: Colors.red, overflow: TextOverflow.ellipsis), maxLines: 1),
        ),
      ),

      const SizedBox(width: 8),

      if (vendorDetail.boothItem.stripePaymentIntent?.receipt_url != null) Chip(
        side: BorderSide.none,
        backgroundColor: model.webBackgroundColor,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        labelPadding: EdgeInsets.zero,
        label: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          child: Text('My Receipt', style: TextStyle(color: model.paletteColor, overflow: TextOverflow.ellipsis), maxLines: 1),
        ),
      ),

    ],
  );
}

Widget boothStatusButton(DashboardModel model, AvailabilityStatus? status) {
    switch (status) {
      case AvailabilityStatus.refunded:
        return Container(
            height: 30,
          decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.24),
          borderRadius: BorderRadius.circular(50),
          ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Center(child: Text('Refunded', style: TextStyle(color: Colors.red,))),
          ),
        );
      case AvailabilityStatus.cancelled:
        return Container(
          height: 30,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.red),
            borderRadius: BorderRadius.circular(50),
          ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Center(child: Text('Cancelled', style: TextStyle(color: Colors.red,))),
        ),
        );
      case AvailabilityStatus.denied:
        return Container(
          height: 30,
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.24),
              borderRadius: BorderRadius.circular(50),
          ),
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Center(child: Text('Denied', style: TextStyle(color: Colors.red,))),
          ),
        );
      case AvailabilityStatus.confirmed:
        return Container(
            height: 30,
            decoration: BoxDecoration(
              color: Colors.lightGreen.withOpacity(0.24),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Center(child: Text('Confirmed', style: TextStyle(color: Colors.lightGreen,),)),
          ),
        );
    case AvailabilityStatus.requested:
      return Container(
        height: 30,
          decoration: BoxDecoration(
            color: model.webBackgroundColor,
            borderRadius: BorderRadius.circular(50),
            ),
          child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Center(child: Text('Requested', style: TextStyle(color: model.disabledTextColor),)),
        ),
      );
      case null:
        // TODO: Handle this case.
      case AvailabilityStatus.inProgress:
        // TODO: Handle this case.
    }
  return Container();
}


Widget vendorAttendeeApplicationHeaderBar(BuildContext context, DashboardModel model, String? currentEditingMode, int widthResponsive, ActivityManagerForm activityManagerForm, UserProfileModel activityOwnerProfile, AttendeeItem attendee, List<VendorContactDetail> booths, VendorMerchantForm? vendorForm, EventMerchantVendorProfile? profile, UserProfileModel? userProfile, {required Function(VendorApplicationBoothOptions?) didSelectOption, required Function() didSelectSelectAll}) {
  final isAttendeePreviewing = facade.FirebaseChatCore.instance.firebaseUser?.uid == userProfile?.userId.getOrCrash();

  if (MediaQuery.of(context).size.width >= widthResponsive) {
    return Container(
        height: 80,
        decoration: BoxDecoration(
          color: model.accentColor,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(
                children: [
                  if (MediaQuery.of(context).size.width <= widthResponsive && profile != null && isAttendeePreviewing == false) Row(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: Image.network(profile.uriImage?.uriPath ?? '').image,
                          ),
                        ],
                      ),
                      const SizedBox(width: 8),
                      Text(profile.brandName.getOrCrash(), style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize))
                    ],
                  ),
                  if (userProfile != null) SizedBox(
                      height: 67,
                      width: 340,
                      child: ListTile(
                        onTap: () {
                          dedSelectProfilePopOverOnly(context, model, userProfile);
                          // selectedItem(user);
                        },
                        leading: Container(
                          height: 67,
                          width: 67,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Padding(
                                padding: const EdgeInsets.all(1.75),
                                child: CachedNetworkImage(
                            imageUrl: userProfile.photoUri ?? '',
                            imageBuilder: (context, imageProvider) => CircleAvatar(backgroundImage: imageProvider),
                            errorWidget: (context, url, error) => CircleAvatar(backgroundImage: Image.asset('assets/profile-avatar.png').image)
                            )
                          )
                        ),
                        title: Text('${userProfile.legalName.getOrCrash()} ${userProfile.legalSurname.value.fold((l) => '', (r) => r)}', style: TextStyle(color: model.paletteColor, overflow: TextOverflow.ellipsis), maxLines: 1),
                        subtitle: (vendorForm?.lastOpenedAt != null) ? Text('Submitted: ${DateFormat.MMMd().add_jm().format(DateTime.fromMillisecondsSinceEpoch(vendorForm!.lastOpenedAt))}', style: TextStyle(color: model.disabledTextColor)) : null,
                      )
                  ),
                  const SizedBox(width: 8),
                  if (vendorForm != null && isDocumentsOptionValid(vendorForm))
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            decoration: BoxDecoration(
                              color: model.disabledTextColor.withOpacity(0.18),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: InkWell(
                              onTap: () async {
                                showSelectedDocumentButton(
                                    context,
                                    model,
                                    getDocumentsList(vendorForm)?.toList() ?? []
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Uploaded Documents', style: TextStyle(color: model.paletteColor)),
                              ),
                            )
                        ),
                      ],
                    ),

                  if (vendorForm?.boothPaymentOptions?.where((e) => e.fee != null).isNotEmpty == true && userProfile != null && profile != null && vendorForm != null) Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        previewReceiptButton(
                          context,
                          model,
                          vendorForm,
                          generateReceiptPdf: () async {

                            final invoiceNumber = await facade.AttendeeFacade.instance.getNumberOfAttending(attendeeOwnerId: attendee.attendeeOwnerId.getOrCrash(), status: ContactStatus.joined, attendingType: AttendeeType.vendor, isInterested: null) ?? 1;
                            final receiptPdf = await generateReceiptPdf(activityManagerForm, activityOwnerProfile, userProfile, profile, attendee, invoiceNumber);


                            final receiptDoc = [
                              DocumentFormOption(
                                  documentForm: ImageUpload(
                                      key: '',
                                      imageToUpload: receiptPdf
                                  )
                              )
                            ];

                            showSelectedDocumentButton(
                                context,
                                model,
                                receiptDoc
                            );

                          },
                          generateRefundPdf: () async {
                            // final receiptPdf = await generateRefundPdf(widget.activityManagerForm, userProfile, profile, vendorForm!);

                            // final receiptDoc = [
                            //   DocumentFormOption(
                            //       documentForm: ImageUpload(
                            //           key: '',
                            //           imageToUpload: receiptPdf
                            //       )
                            //   )
                            // ];
                            //
                            // showSelectedDocumentButton(
                            //     context,
                            //     model,
                            //     receiptDoc
                            // );
                          },
                        ),
                      ],
                    ),
                  )

                ],
              ),
            ),
            selectAllStatusHeader(
                context,
                currentEditingMode,
                model,
                widthResponsive,
                booths,
                attendee,
                didSelectOption: (e) => didSelectOption(e),
                didSelectSelectAll: () => didSelectSelectAll()
            ),
            // selectAllStatusHeader(
            //     entry.value,
            //     entry.key,
            //     didSelectOption: (options) => _handleApplicantMoreOptionsDropdownSelection(context, options, userProfile, profile, entry.key, entry.value)
            // )
          ],
        )
    );
  }
  return Container(
    height: 80,
    decoration: BoxDecoration(
      color: model.accentColor,
      borderRadius: BorderRadius.circular(18),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (userProfile != null && profile != null) Row(
            children: [
              CircleAvatar(
                backgroundImage: Image.network(profile.uriImage?.uriPath ?? '').image,
              ),
              SizedBox(
                  height: 67,
                  width: 200,
                  child: ListTile(
                      onTap: () {
                        // selectedItem(user);
                      },
                      leading: Container(
                        height: 67,
                        width: 67,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Padding(
                              padding: const EdgeInsets.all(1.75),
                              child: CachedNetworkImage(
                                  imageUrl: userProfile.photoUri ?? '',
                                  imageBuilder: (context, imageProvider) => CircleAvatar(backgroundImage: imageProvider),
                                  errorWidget: (context, url, error) => CircleAvatar(backgroundImage: Image.asset('assets/profile-avatar.png').image)
                              )
                          )
                      ),
                      title: Text('${userProfile.legalName.getOrCrash()} ${userProfile.legalSurname.value.fold((l) => '', (r) => r)}', style: TextStyle(color: model.paletteColor, overflow: TextOverflow.ellipsis), maxLines: 1),
                      subtitle: Text(profile.brandName.getOrCrash(), style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis), maxLines: 1,)
                  )
              ),
            ],
          ),
          selectAllStatusHeader(
            context,
            currentEditingMode,
            model,
            widthResponsive,
            booths,
            attendee,
            didSelectOption: (e) => didSelectOption(e),
            didSelectSelectAll: () => didSelectSelectAll()
          ),
          // selectAllStatusHeader(
          //     entry.value,
          //     entry.key,
          //     didSelectOption: (options) => _handleApplicantMoreOptionsDropdownSelection(context, options, userProfile, profile, entry.key, entry.value)
          // ),
        ],
      ),
    ),
  );
}


Widget selectAllStatusHeader(BuildContext context, String? currentEditingMode, DashboardModel model, int widthResponsive, List<VendorContactDetail> booths, AttendeeItem currentAttendee, {required Function(VendorApplicationBoothOptions?) didSelectOption, required Function() didSelectSelectAll}) {
  final List<VendorApplicationBoothOptions> getApplicantOptionsList = VendorApplicationBoothOptions.values.where((action) => action.isAvailable(currentAttendee, booths.map((e) => e.boothItem.status?.name).contains(currentEditingMode))).toList();

  if (MediaQuery.of(context).size.width <= widthResponsive && getApplicantOptionsList.length != 1) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<VendorApplicationBoothOptions>(
        isDense: true,
        customButton: Icon(Icons.more_horiz_rounded, color: model.paletteColor),
        onChanged: (VendorApplicationBoothOptions? selectedAction) {
          didSelectOption(selectedAction);
          // _handleDropdownSelection(selectedAction, booths, currentAttendee);
        },
        items: getApplicantOptionsList.map((action) => DropdownMenuItem<VendorApplicationBoothOptions>(
          value: action,
          child: (action == VendorApplicationBoothOptions.previewStatus) ? Text('Status: ${currentAttendee.contactStatus?.name ?? 'Requested'}', style: TextStyle(color: model.disabledTextColor)) : Text(action.displayName, style: TextStyle(color: model.paletteColor)),
        )).toList(),
        dropdownStyleData: DropdownStyleData(
          width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: model.webBackgroundColor,
          ),
        ),
      ),
    );
  }
  return Padding(
    padding: const EdgeInsets.only(right: 8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Visibility(
          visible: booths.map((e) => e.boothItem.status?.name).contains(currentEditingMode),
          child: InkWell(
              onTap: () {
                didSelectSelectAll();
                // setState(() {
                //   for (VendorContactDetail vendor in booths.where((e) => e.boothItem.status?.name == currentEditingMode)) {
                //     if (selectedVendors.map((e) => e.uid).contains(vendor.uid) == false) {
                //       selectedVendors.add(vendor);
                //     } else {
                //       selectedVendors.removeWhere((element) => element.uid == vendor.uid);
                //     }
                //   }
                // });
              },
              child: Container(
                decoration: BoxDecoration(
                    color: model.disabledTextColor.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(30)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(' select All '),
                ),
              )
          ),
        ),
        // Text('Applied At: ${DateFormat.MMMd().add_jm().format(e.dateCreated)}', style: TextStyle(color: widget.model.disabledTextColor)),
        Text('Status: ${currentAttendee.contactStatus?.name ?? 'Requested'}', style: TextStyle(color: model.disabledTextColor)),
      ],
    ),
  );
}



Widget previewReceiptButton(BuildContext context, DashboardModel model, VendorMerchantForm? vendorForm, {required Function() generateReceiptPdf, required Function() generateRefundPdf}) {
  final hasConfirmed = vendorForm?.boothPaymentOptions?.map((e) => e.status).contains(AvailabilityStatus.confirmed) == true;
  final hasRefunded = vendorForm?.boothPaymentOptions?.map((e) => e.status).contains(AvailabilityStatus.refunded) == true;

  if (hasConfirmed && hasRefunded) {
    // Case 3: Both confirmed and refunded statuses present
    return Container(
      height: 40,
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          customButton: Container(
            decoration: BoxDecoration(
              color: model.disabledTextColor.withOpacity(0.18),
              borderRadius: BorderRadius.circular(35),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Preview Receipts', style: TextStyle(color: model.paletteColor), textAlign: TextAlign.center,),
            ),
          ),
          items: [
            DropdownMenuItem<String>(
              value: 'receipt',
              child: Text('Receipt', style: TextStyle(color: model.paletteColor)),
              onTap: () {
                // Handle Receipt preview logic here
                generateReceiptPdf();
              },
            ),
            DropdownMenuItem<String>(
              value: 'refunded',
              child: Text('Refunded', style: TextStyle(color: model.paletteColor)),
              onTap: () {
                // Handle Refunded receipt preview logic here
                generateRefundPdf();
              },
            ),
          ],
          dropdownStyleData: DropdownStyleData(
            width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: model.webBackgroundColor,
            ),
          ),
          onChanged: (value) {},
        ),
      ),
    );
  } else if (hasConfirmed || hasRefunded) {
    // Case 1 & 2: Only one of the statuses is present
    return Container(
      decoration: BoxDecoration(
        color: model.disabledTextColor.withOpacity(0.18),
        borderRadius: BorderRadius.circular(35),
      ),
      child: InkWell(
        onTap: () {
          if (hasConfirmed) {
            // Handle Receipt preview logic here
            generateReceiptPdf();
          } else if (hasRefunded) {
            // Handle Refunded receipt preview logic here
            generateRefundPdf();
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Preview Receipt',
            style: TextStyle(color: model.paletteColor),
          ),
        ),
      ),
    );
  }

  // If neither status is present, return an empty container (button should not exist)
  return SizedBox.shrink();
}


void showSelectedDocumentButton(BuildContext context, DashboardModel model, List<DocumentFormOption> documents) {
  if (kIsWeb) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Documents',
      transitionDuration: Duration(milliseconds: 350),
      pageBuilder: (BuildContext contexts, anim1, anim2) {
        return  Align(
            alignment: Alignment.center,
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                child: Container(
                    decoration: BoxDecoration(
                        color: model.accentColor,
                        borderRadius: BorderRadius.all(Radius.circular(17.5))
                    ),
                    width: 770,
                    height: 900,
                    child: MultiplePdfViewerScrollable(
                        model: model,
                        pdfs: documents
                    )
                )
            )
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform.scale(
            scale: anim1.value,
            child: Opacity(
                opacity: anim1.value,
                child: child
            )
        );
      },
    );
  } else {
    Navigator.push(context, MaterialPageRoute(
        builder: (_) {
          return MultiplePdfViewerScrollable(
              model: model,
              pdfs: documents
          );
        })
    );
  }
}
