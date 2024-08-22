part of check_in_presentation;

class AddressSearchControllerWidget extends StatefulWidget {

  final String currentAddress;
  final String currentCountry;
  final String? positionAddress;
  final String localization;
  final DashboardModel model;
  final Function() update;
  final Function(bool focus) onFocusChanged;
  final Function(String e) onQueryChanged;
  final Function({String addressStr, String cityStr, String provinceStateStr, String placeId, double lat, double lng}) selectionChanged;

  const AddressSearchControllerWidget({Key? key, required this.model, this.positionAddress, required this.update, required this.currentCountry, required this.onQueryChanged, required this.selectionChanged, required this.currentAddress, required this.localization, required this.onFocusChanged}) : super(key: key);

  @override
  _LocationSearchControllerWidgetState createState() => _LocationSearchControllerWidgetState();
}

class _LocationSearchControllerWidgetState extends State<AddressSearchControllerWidget> {

  bool isOpen = false;
  FloatingSearchBarController? controller;

  @override
  void initState() {
    controller = FloatingSearchBarController();
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return Center(
      child: AnimatedContainer(
          height: 700,
          // width: widget.model.mainContentWidth! - 100,
          duration: const Duration(milliseconds: 300),
          curve: Curves.fastOutSlowIn,
          child: ChangeNotifierProvider(create: (_) => facade.AutoCompleteSearchModel(),
              child: Consumer<facade.AutoCompleteSearchModel>(
                  builder: (context, model, _) {
                    return searchBarMenuItem(context, model);
                  }
              )
          )
      ),
    );
  }


  Widget searchBarMenuItem(BuildContext context, facade.AutoCompleteSearchModel model) {
    if (controller?.isClosed ?? true) {
      model.endLoading();
    }

    return FloatingSearchBar(
      queryStyle: TextStyle(color: widget.model.paletteColor),
      border: BorderSide(width: isOpen ? 1.25 : 0.5, color: isOpen ? widget.model.paletteColor : widget.model.disabledTextColor),
      margins: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      elevation: 0,
      backgroundColor: widget.model.accentColor,
      backdropColor: Colors.transparent,
      transitionCurve: Curves.easeInOut,
      controller: controller,
      borderRadius: BorderRadius.circular(25),
      transition: CircularFloatingSearchBarTransition(),
      automaticallyImplyDrawerHamburger: false,
      automaticallyImplyBackButton: false,
      progress: model.isLoading,
      accentColor: widget.model.paletteColor,
      hint: 'Search & Select a Location...',
      title: (widget.currentAddress != '') ? Text(widget.currentAddress, style: TextStyle(color: widget.model.paletteColor, fontSize: 16),) : null,
      onQueryChanged: (query) {
        // widget.onQueryChanged(query);
        if (widget.currentCountry != '') {
          model.onQueryChanged(context, "$query, ${widget.currentCountry}", widget.localization);
        } else {
          model.onQueryChanged(context, query, widget.localization);
        }
      },
      clearQueryOnClose: false,
      onSubmitted: (query) {
        // controller!.close();
        // model.endLoading();
      },
      onFocusChanged: (isFocused) {
        widget.onFocusChanged(isFocused);
        if (isFocused) {
          isOpen = true;
        } else {
          isOpen = false;
        }
      },
      actions: [
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
        ),
      ],
      physics: const BouncingScrollPhysics(),
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Material(
            color: Colors.white,
            elevation: 4.0,
            borderRadius: BorderRadius.circular(8),
              child: Column(
                  children: model.suggestions.map((e) => buildItem(context, e, model)).toList()

            // child: ImplicitlyAnimatedList<facade.LocationSearchModel>(
            //   shrinkWrap: true,
            //   padding: EdgeInsets.zero,
            //   physics: const NeverScrollableScrollPhysics(),
            //   items: model.suggestions.toList(),
            //   areItemsTheSame: (a, b) => a == b,
            //   itemBuilder: (context, animation, place, i) {
            //     return SizeFadeTransition(
            //       animation: animation,
            //       child: buildItem(context, place, model),
            //     );
            //   },
            //   updateItemBuilder: (context, animation, place) {
            //
            //     return FadeTransition(
            //       opacity: animation,
            //       child: buildItem(context, place, model),
            //     );
            //   },
            // ),
            ),
          ),
        );
      },
    );
  }

  String getAddress(String description) {
    final split = description.split(',');
    final Map<int, String> values = {
      for (int i = 0; i < split.length; i++) i: split[i]
    };


    if (values.containsKey(0)) {
      controller?.query = values[0] ?? controller?.query ?? '';
      return values[0] ?? '';
    }
    return '';
  }

  String getCity(String description) {
    final split = description.split(', ');
    final Map<int, String> values = {
      for (int i = 0; i < split.length; i++) i: split[i]
    };

    if (values.containsKey(1)) {
      return values[1] ?? '';
    }
    return '';
  }


  String getStateProvince(String description) {
    final split = description.split(', ');
    final Map<int, String> values = {
      for (int i = 0; i < split.length; i++) i: split[i]
    };


    if (values.containsKey(2)) {
      return values[2] ?? '';
    }
    return '';
  }


  Widget buildItem(BuildContext context, facade.LocationSearchModel location, facade.AutoCompleteSearchModel model) {

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final model = Provider.of<facade.AutoCompleteSearchModel>(context, listen: true);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () async {

            const String baseUrl = 'https://maps.googleapis.com/maps/api/place/details/json';
            final String request = '$baseUrl?place_id=${location.placeId}&key=$PLACES_API_KEY';
            double _placeLat = 0;
            double _placeLng = 0;

            try {
              final http.Response response = await http.get(Uri.parse(request));
              final result = jsonDecode(response.body)['result'];

              _placeLat = result['geometry']['location']['lat'];
              _placeLng = result['geometry']['location']['lng'];

            } catch (e) {
              print(e);
            }


            setState(() {
              widget.selectionChanged(
                  addressStr: getAddress(location.description),
                  cityStr: getCity(location.description),
                  provinceStateStr: getStateProvince(location.description),
                  placeId: location.placeId,
                  lat: _placeLat,
                  lng: _placeLng
              );
              controller!.close();
              widget.update();
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              height: 60,
                child: Row(
                children: [
                  SizedBox(
                    width: 36,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      child: location.key != 'search'
                          ? const Icon(Icons.verified_rounded, key: Key('history'), color: Colors.deepOrange)
                          : const Icon(Icons.place, key: Key('place')),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          location.description,
                          // style: textTheme.subtitle1,
                        ),
                        const SizedBox(height: 2),
                        Expanded(
                          child: Text(
                            location.secondary,
                            // style: textTheme.bodyText2?.copyWith(color: Colors.grey.shade600),
                          )
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ),
        ),
      ],
    );
  }
}