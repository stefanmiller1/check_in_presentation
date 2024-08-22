part of check_in_presentation;

class MapListingComponent extends StatefulWidget {

  final Marker locationMarker;
  final DashboardModel model;

  const MapListingComponent({super.key, required this.locationMarker, required this.model});

  @override
  State<MapListingComponent> createState() => _MapListingComponentState();
}

class _MapListingComponentState extends State<MapListingComponent> {

  late String _mapStyle = '';
  late GoogleMapController mapController;

  @override
  void initState() {

    SchedulerBinding.instance.addPostFrameCallback((_) {
      rootBundle.loadString('assets/style/map_style.txt').then((string) {
        _mapStyle = string;
      });
    });

    super.initState();
  }


  void _onMapCreated(BuildContext context, GoogleMapController controller) async {
    mapController = controller;
    mapController.setMapStyle(_mapStyle);
  }

  Future<Set<Marker>> generateMarker(Marker marker) async {
    final Marker newMarker;
    newMarker = Marker(
        markerId: marker.markerId,
        position: marker.position,
        icon: await MapHelper.getGeneralMarkerIcon(widget.model)
    );
    return  <Marker>{newMarker};
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      initialData: <Marker>{widget.locationMarker},
      future: generateMarker(widget.locationMarker),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return Container();
        }
        return GoogleMap(
            mapToolbarEnabled: false,
            zoomControlsEnabled: false,
            zoomGesturesEnabled: false,
            myLocationButtonEnabled: false,
            markers: snapshot.data!,
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: snapshot.data!.first.position,
              zoom: 14.5
          ),
            onMapCreated: (controller) => _onMapCreated(context, controller),
        );
      }
    );
  }
}