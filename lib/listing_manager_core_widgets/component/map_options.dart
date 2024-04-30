import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:map_launcher/map_launcher.dart';



void presentMapOptions(
  BuildContext context,
  DashboardModel model,
    {required Function(AvailableMap map) onMapTap}) async {

  try {
  final availableMaps = await MapLauncher.installedMaps;
  if (!context.mounted) return;

  showDialog(context: context, builder: (context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      insetPadding: const EdgeInsets.all(12.0),
      elevation: 0,
      backgroundColor: Colors.transparent,
      content: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: model.accentColor,
                borderRadius: BorderRadius.circular(15)
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: availableMaps.map(
                  (map) => InkWell(
                    onTap: () {
                      onMapTap(map);
                    },
                    child: Column(

                      children: [
                        ListTile(
                          leading: SvgPicture.asset(map.icon, height: 30, width: 30),
                          title: Text(map.mapName, style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold),),
                        ),
                        Divider(color: model.disabledTextColor),
                      ],
                    ),
                  ),
                ).toList(),
              )
            )
          ),
          const SizedBox(height: 25),
          InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 45,
              decoration: BoxDecoration(
                  color: model.accentColor,
                  borderRadius: BorderRadius.circular(15)
                ),
                child: Center(child: Text('Cancel', style: TextStyle(color: model.paletteColor))),
                ),
              )
            ],
          ),
        );
      }
    );
  } catch (e) {

  }
}


// [
// InkWell(
// onTap: () {
// Navigator.of(context).pop();
// },
// child: Padding(
// padding: const EdgeInsets.symmetric(vertical: 10.0),
// child: Text('Take a Photo', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold),),
// ),
// ),
// Divider(color: model.disabledTextColor),
// InkWell(
// onTap: () {
// Navigator.of(context).pop();
//
// },
// child: Padding(
// padding: const EdgeInsets.symmetric(vertical: 10.0),
// child: Text('Choose From Library', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold),),
// ),
// ),
// ],
// ),