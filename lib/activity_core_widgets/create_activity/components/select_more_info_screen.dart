import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';

class AdditionalDetailsWidget extends StatelessWidget {
  final DashboardModel model;
  final ActivityManagerForm? activityForm;
  final ReservationItem reservation;
  final Function() didSelectLinkCircle;
  final Function(bool) isTicketedChanged;
  final Function(bool) isAgeRestrictedChanged;
  final Function(bool) isPrivateChanged;
  final Function(List<String>) onLinkedCirclesChanged;

  const AdditionalDetailsWidget({
    Key? key,
    required this.model,
    required this.activityForm,
    required this.reservation,
    required this.didSelectLinkCircle,
    required this.isTicketedChanged,
    required this.isAgeRestrictedChanged,
    required this.isPrivateChanged,
    required this.onLinkedCirclesChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: Icon(Icons.group, color: model.paletteColor),
            title: Text('Link to a Circle', style: TextStyle(color: model.paletteColor)),
            subtitle: Text('Create or select a circle.', style: TextStyle(color: model.disabledTextColor)),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Handle circle linking
            },
          ),
          ListTile(
            leading: Icon(Icons.shield, color: model.paletteColor),
            title: Text('Age Restricted', style: TextStyle(color: model.paletteColor)),
            trailing: Container(
              width: 60,
              child: FlutterSwitch(
                width: 60, 
                activeColor: model.paletteColor,
                inactiveColor: model.accentColor,
                value: activityForm?.profileService.activityRequirements.isAgeRestricted ?? false,
                onToggle: (val) {
                  isAgeRestrictedChanged(val);
                },
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.local_activity, color: model.paletteColor),
            title: Text('Is Ticketed', style: TextStyle(color: model.paletteColor)),
            trailing: Container(
              width: 60,
              child: FlutterSwitch(
                width: 60, 
                activeColor: model.paletteColor,
                inactiveColor: model.accentColor,
                value: activityForm?.activityAttendance.isTicketBased ?? false,
                onToggle: (val) {
                  isTicketedChanged(val);
                  },
                ),
              ),
          ),
          ListTile(
            leading: Icon(Icons.lock, color: model.paletteColor),
            title: Text('Private Event', style: TextStyle(color: model.paletteColor)),
            trailing: Container(
              width: 60,
              child: FlutterSwitch(
                width: 60, 
                activeColor: model.paletteColor,
                inactiveColor: model.accentColor,
                value: reservation.isPrivate ?? false,
                onToggle: (val) {
                  isPrivateChanged(val);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}