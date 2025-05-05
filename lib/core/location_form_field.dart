part of check_in_presentation;

bool locationIsValid(LocationModel location) {
    return location.countryRegion.isNotEmpty &&
        location.street.isValid() &&
        location.city.isValid() &&
        location.provinceState.isValid() &&
        location.postalCode.isValid();
  }


Widget locationFormField({
  required DashboardModel model,
  required Function(String) onStreetChanged,
  required Function(String) onCityChanged,
  required Function(String) onProvinceStateChanged,
  required Function(String) onPostalCodeChanged,
  required Function(ImageUpload) onLocationMediaChanged,
  required LocationModel initialLocation,
}) {
  
  return Container(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  buildTextFieldWithLabel(
                    model: model,
                    initialText: initialLocation.street.isValid() ? initialLocation.street.getOrCrash() : null,
                    label: 'Street',
                    isValid: initialLocation.street.isValid(),
                    onChanged: (value) {
                      onStreetChanged(value);
                    },
                    validator: (e) => initialLocation.street.value.fold(
                    (l) => l.maybeMap(location: (e) => e.f?.maybeMap(invalidAddress: (e) => 'Invalid Address', isEmpty: (e) => 'Cannot be empty', orElse: () => null) ?? null, orElse: () => null),
                    (r) => null),
                  ),
                  buildTextFieldWithLabel(
                    model: model,
                    initialText: initialLocation.city.isValid() ? initialLocation.city.getOrCrash() : null,
                    label: 'City',
                    isValid: initialLocation.city.isValid(),
                    onChanged: (value) {
                      onCityChanged(value);
                    },
                    validator: (e) => initialLocation.city.value.fold(
                    (l) => l.maybeMap(location: (e) => e.f?.maybeMap(invalidCity: (e) => 'Invalid City', isEmpty: (e) => 'Cannot be empty', orElse: () => null) ?? null, orElse: () => null),
                    (r) => null),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  // height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    // color: model.accentColor
                  ),
                  margin: const EdgeInsets.only(left: 16.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ProfileImageUploadPreview(
                      model: model,
                      title: 'Location Pics',
                      subTitle: 'Add a Photo of the Space (optional)',
                      currentNetworkImage: ((initialLocation.imageUploads ?? []).isNotEmpty) ? initialLocation.imageUploads![0] : null,
                      imageToUpLoad: (image) {
                        onLocationMediaChanged(image);
                      }
                    ),
                  ),
                  // IconButton(
                  //   icon: Icon(Icons.image, color: model.disabledTextColor, size: 45),
                  //   onPressed: () {
                  //     // didUpdateLocationModel(initialLocation.copyWith(street: FacilityLocationStreet(value)));
                  // // Implement image upload functionality here
                  //       },
                  //   ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 16.0),
                  //   child: Text(
                  //     'Add a photo of the\nspace (optional)',
                  //     maxLines: 2,
                  //       style: TextStyle(color: model.paletteColor, overflow: TextOverflow.ellipsis),
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
          
        
        buildTextFieldWithLabel(
          model: model,
          initialText: initialLocation.provinceState.isValid() ? initialLocation.provinceState.getOrCrash() : null,
          label: 'Province/State',
          isValid: initialLocation.provinceState.isValid(),
          onChanged: (value) {
            onProvinceStateChanged(value);
          },
          validator: (e) => initialLocation.provinceState.value.fold(
          (l) => l.maybeMap(location: (e) => e.f?.maybeMap(missingCountry: (e) => 'Country Missing', invalidStateProvince: (e) => 'Invalid State/Province', isEmpty: (e) => 'Cannot be empty', orElse: () => null) ?? null, orElse: () => null),
          (r) => null),
        ),
        buildTextFieldWithLabel(
          model: model,
          initialText: initialLocation.postalCode.isValid() ? initialLocation.postalCode.getOrCrash() : null,
          label: 'Postal Code',
          isValid: initialLocation.postalCode.isValid(),
          onChanged: (value) {
            onPostalCodeChanged(value);
          },
          validator: (e) => initialLocation.postalCode.value.fold(
          (l) => l.maybeMap(location: (e) => e.f?.maybeMap(missingCountry: (e) => 'Country Missing', invalidPostalCode: (e) => 'Invalid Postal Code', isEmpty: (e) => 'Cannot be empty', orElse: () => null) ?? null, orElse: () => null),
          (r) => null),
          ),
      ]
    )
  );
}

Widget buildAdditionalOptionsWidget({
  required BuildContext context,
  required DashboardModel model,
  required LocationModel initialLocation,
  required Function(LocationType) onLocationTypeChanged,
  required Function(String) onLocationNameChanged,
  required Function(bool) onParkingAvailabilityChanged,
  required Function(bool) onNearTransitChanged,
  required Function(bool) onOvernightStorageProvisionChanged,
  required Function(bool) onBarrierFreeAccessibleChanged,
  required Function(List<LocationBarrierFreeTypes>) onBarrierFreeProvisionChanged,
  required Function(List<LocationAmenities>) onAmenityProvisionChanged,
  required Function(List<LocationEquipment>) onEquipmentProvisionChanged,
  required Function(LocationRentalOptions) onRentalOptionChanged,
}) {
  return Container(
    width: MediaQuery.of(context).size.width,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
          children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: buildTextFieldWithLabel(
                      model: model,
                      initialText: initialLocation.locationName,
                      label: 'Location Name',
                      isValid: false,
                      onChanged: (value) {
                        onLocationNameChanged(value);
                        // Handle location name change
                      },
                      validator: (e) => null
                    ),
                  ),
                  const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Text(
                            'Location Type',
                            style: TextStyle(
                              color: model.paletteColor,
                              fontSize: model.secondaryQuestionTitleFontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                        height: 50,
                        constraints: const BoxConstraints(maxWidth: 240),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2(
                          isDense: true,
                          value: initialLocation.locationType,
                          customButton: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: (initialLocation.locationType == LocationType.none) ? model.accentColor : model.paletteColor,
                              borderRadius: BorderRadius.circular(35),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  getLocationTypeName(initialLocation.locationType),
                                  style: TextStyle(
                                  color: (initialLocation.locationType == LocationType.none) ? model.paletteColor : model.accentColor,
                                    fontSize: model.secondaryQuestionTitleFontSize,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            )
                          ),
                          dropdownStyleData: DropdownStyleData(
                            width: 240,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: model.accentColor,
                            ),
                          ),
                          // decoration: InputDecoration(
                          //   labelText: 'Location Type',
                          //   border: OutlineInputBorder(
                          //   borderRadius: BorderRadius.circular(25.0),
                          //   ),
                          // ),
                          items: LocationType.values.map((LocationType type) {
                            return DropdownMenuItem<LocationType>(
                            value: type,
                            child: Text(getLocationTypeName(type)),
                            );
                          }).toList(),
                          onChanged: (LocationType? newValue) {
                                if (newValue != null) {
                                onLocationTypeChanged(newValue);
                              }
                            }  
                          ),
                        ),
                                          ),
                      ],
                    )
                ],
              ),
             const SizedBox(height: 24),
                ListTile(
                  leading: Icon(
                  Icons.local_parking,
                  color: initialLocation.isParkingAvailable ?? false ? model.paletteColor : model.disabledTextColor,
                  ),
                  title: Text(
                  'Parking Available',
                  style: TextStyle(
                    color: initialLocation.isParkingAvailable ?? false ? model.paletteColor : model.disabledTextColor,
                    fontSize: model.secondaryQuestionTitleFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                  ),
                  subtitle: Text(
                  'Is there parking available at the location?',
                  style: TextStyle(
                    color: model.disabledTextColor,
                  ),
                  ),
                  trailing: Container(
                    height: 60,
                    width: 60,
                    child: FlutterSwitch(
                    width: 60,
                    activeColor: model.paletteColor,
                    inactiveColor: model.accentColor,
                    value: initialLocation.isParkingAvailable ?? false,
                    onToggle: (value) {
                      onParkingAvailabilityChanged(value);
                    },
                    ),
                  ),
                ),

                ListTile(
                  leading: Icon(
                  Icons.directions_transit,
                  color: initialLocation.isNearTransit ?? false ? model.paletteColor : model.disabledTextColor,
                  ),
                  title: Text(
                  'Near Transit',
                  style: TextStyle(
                    color: initialLocation.isNearTransit ?? false ? model.paletteColor : model.disabledTextColor,
                    fontSize: model.secondaryQuestionTitleFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                  ),
                  subtitle: Text(
                  'Is the location near public transit?',
                  style: TextStyle(
                    color: model.disabledTextColor,
                  ),
                  ),
                  trailing: Container(
                    height: 60,
                    width: 60,
                    child: FlutterSwitch(
                    width: 60,
                    activeColor: model.paletteColor,
                    inactiveColor: model.accentColor,
                    inactiveTextColor: model.paletteColor,
                    value: initialLocation.isNearTransit ?? false,
                    onToggle: (value) {
                      onNearTransitChanged(value);
                      },
                    ),
                  ),
                ),

                ListTile(
                    leading: Icon(
                    Icons.garage,
                    color: initialLocation.overnightStorageProvision ?? false ? model.paletteColor : model.disabledTextColor,
                    ),
                  title: Text(
                  'Overnight Storage',
                  style: TextStyle(
                    color: initialLocation.overnightStorageProvision ?? false ? model.paletteColor : model.disabledTextColor,
                    fontSize: model.secondaryQuestionTitleFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                  ),
                  subtitle: Text(
                  'Is storage overnight provided at this location?',
                  style: TextStyle(
                    color: model.disabledTextColor,
                  ),
                  ),
                  trailing: Container(
                    height: 60,
                    width: 60,
                    child: FlutterSwitch(
                    width: 60,
                    activeColor: model.paletteColor,
                    inactiveColor: model.accentColor,
                    value: initialLocation.overnightStorageProvision ?? false,
                    onToggle: (value) {
                      onOvernightStorageProvisionChanged(value);
                    },
                    ),
                  ),
                ),

                ListTile(
                  leading: Icon(
                  Icons.accessible,
                  color: initialLocation.isBarrierFreeAccessible ?? false ? model.paletteColor : model.disabledTextColor,
                  ),
                  title: Text(
                  'Barrier-Free Accessible',
                  style: TextStyle(
                    color: initialLocation.isBarrierFreeAccessible ?? false ? model.paletteColor : model.disabledTextColor,
                    fontSize: model.secondaryQuestionTitleFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                  ),
                  subtitle: Text(
                  'Is the location barrier-free accessible?',
                  style: TextStyle(
                    color: model.disabledTextColor,
                  ),
                  ),
                  trailing: Container(
                    height: 60,
                    width: 60,
                    child: FlutterSwitch(
                    width: 60,
                    activeColor: model.paletteColor,
                    inactiveColor: model.accentColor,
                    value: initialLocation.isBarrierFreeAccessible ?? false,
                    onToggle: (value) {
                      onBarrierFreeAccessibleChanged(value);
                    },
                    ),
                  ),
                ),

                const SizedBox(height: 24),
      
              if (initialLocation.isBarrierFreeAccessible == true) ...[
              ListTile(
                leading: Icon(Icons.accessible, color: model.paletteColor),
                title: Text(
                'Barrier-Free Provisions',
                style: TextStyle(
                  color: model.paletteColor,
                  fontSize: model.secondaryQuestionTitleFontSize,
                  fontWeight: FontWeight.bold,
                ),
                ),
                subtitle: Text(
                'Select the types of barrier-free provisions available at the location.',
                style: TextStyle(
                  color: model.disabledTextColor,
                ),
                ),
              ),
              Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              alignment: WrapAlignment.center,
              children: LocationBarrierFreeTypes.values.map((provision) {
                return GestureDetector(
                onTap: () {
                  final newList = List<LocationBarrierFreeTypes>.from(initialLocation.barrierFreeProvisions ?? []);
                  if (initialLocation.barrierFreeProvisions?.contains(provision) ?? false) {
                  newList.remove(provision);
                  } else {
                  newList.add(provision);
                  }
                  onBarrierFreeProvisionChanged(newList);
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                  color: initialLocation.barrierFreeProvisions?.contains(provision) ?? false
                    ? model.paletteColor
                    : model.accentColor,
                  borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    child: Text(
                    getLocationBarrierFreeTypesName(provision),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: initialLocation.barrierFreeProvisions?.contains(provision) ?? false
                      ? model.accentColor
                      : model.paletteColor,
                    ),
                    ),
                  ),
                ),
                );
              }).toList(),
              ),],
              
              ListTile(
              leading: Icon(Icons.local_offer, color: model.paletteColor),
              title: Text(
                'Amenities',
                style: TextStyle(
                color: model.paletteColor,
                fontSize: model.secondaryQuestionTitleFontSize,
                fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'Select the amenities available at the location.',
                style: TextStyle(
                color: model.disabledTextColor,
                ),
              ),
              ),
              Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              alignment: WrapAlignment.center,
              children: LocationAmenities.values.map((provision) {
                return InkWell(
                onTap: () {
                  final newList = List<LocationAmenities>.from(initialLocation.amenityProvisions ?? []);
                  if (initialLocation.amenityProvisions?.contains(provision) ?? false) {
                  newList.remove(provision);
                  } else {
                  newList.add(provision);
                  }
                  onAmenityProvisionChanged(newList);
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                  color: initialLocation.amenityProvisions?.contains(provision) ?? false
                    ? model.paletteColor
                    : model.accentColor,
                  borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    child: Text(
                    getLocationAmenitiesName(provision),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: initialLocation.amenityProvisions?.contains(provision) ?? false
                      ? model.accentColor
                      : model.paletteColor,
                    ),
                    ),
                  ),
                ),
                );
              }).toList(),
              ),
              
              ListTile(
              leading: Icon(Icons.build, color: model.paletteColor),
              title: Text(
                'Equipment Provisions',
                style: TextStyle(
                color: model.paletteColor,
                fontSize: model.secondaryQuestionTitleFontSize,
                fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'Select the equipment provisions available at the location.',
                style: TextStyle(
                color: model.disabledTextColor,
                ),
              ),
              ),
              Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              alignment: WrapAlignment.center,
              children: LocationEquipment.values.map((provision) {
                return InkWell(
                onTap: () {
                  final newList = List<LocationEquipment>.from(initialLocation.equipmentProvisions ?? []);
                  if (initialLocation.equipmentProvisions?.contains(provision) ?? false) {
                  newList.remove(provision);
                  } else {
                  newList.add(provision);
                  }
                  onEquipmentProvisionChanged(newList);
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                  color: initialLocation.equipmentProvisions?.contains(provision) ?? false
                     ? model.paletteColor
                    : model.accentColor,
                  borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    child: Text(getLocationEquipmentName(provision),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: initialLocation.equipmentProvisions?.contains(provision) ?? false
                      ? model.accentColor
                      : model.paletteColor,
                    ),
                    ),
                  ),
                ),
                );
              }).toList(),
              ),
              
              if ((initialLocation.equipmentProvisions ?? []).isNotEmpty) ...[
              ListTile(
                leading: Icon(Icons.home_work, color: model.paletteColor),
                title: Text(
                'Rental Options',
                style: TextStyle(
                  color: model.paletteColor,
                  fontSize: model.secondaryQuestionTitleFontSize,
                  fontWeight: FontWeight.bold,
                ),
                ),
                subtitle: Text(
                'Select the rental options available at the location.',
                style: TextStyle(
                  color: model.disabledTextColor,
                  ),
                ),
              ),
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                alignment: WrapAlignment.center,
                children: LocationRentalOptions.values.map((option) {
                return InkWell(
                  onTap: () {
                  // Handle rental option selection
                  onRentalOptionChanged(option);
                  },
                  child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: (initialLocation.rentalOptions != null && initialLocation.rentalOptions! == option) ? model.paletteColor : model.accentColor,
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    child: Text(
                      getLocationRentalOptionsName(option),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                      color: (initialLocation.rentalOptions != null && initialLocation.rentalOptions! == option) ? model.accentColor : model.paletteColor,
                        ),
                      ),
                    ),
                  ),
                );
                }).toList(),
              ),
              
          ],
        ],
      ),
    ),
  );
}

Widget buildTextFieldWithLabel({
  required DashboardModel model,
  required String? initialText,
  required String label,
  required Function(String) onChanged,
  required bool isValid,
  required String? Function(String?) validator,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            label,
            style: TextStyle(
              color: model.paletteColor,
              fontSize: model.secondaryQuestionTitleFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        IgnorePointer(
          ignoring: isValid,
          child: TextFormField(
            initialValue: initialText,
            style: TextStyle(color: model.paletteColor),
            decoration: InputDecoration(
                suffixIcon: isValid
              ? Icon(
                Icons.check_circle_outline_outlined,
                color: model.paletteColor,
              )
              : null,
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(
                  color: Colors.transparent
                ),
              ),
              errorStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: model.disabledTextColor,
              ),
              filled: true,
              fillColor: isValid ? model.disabledTextColor.withOpacity(0.6) : model.accentColor,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(
                  color: model.paletteColor,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(
                  color: model.paletteColor,
                  width: 2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(
                  color: Colors.transparent,
                  width: 0,
                ),
              ),
            ),
            onChanged: onChanged,
            validator: validator,
            autocorrect: false,
          ),
        ),
      ],
    ),
  );
}