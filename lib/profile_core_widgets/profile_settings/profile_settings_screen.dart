import 'package:beamer/beamer.dart';
import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:url_launcher/url_launcher.dart' as url;

import 'components/notifications_profile.dart';
import 'components/payments_payouts_profile.dart';

class ProfileSettingsScreen extends StatefulWidget {

  final DashboardModel model;
  final bool isActivityApp;
  final bool isWeb;
  final ProfileSettingMarker? currentSettingsMarker;
  final Function(ProfileSettingMarker navItem) didSelectNav;
  final Function() didDeleteAccount;
  final Function() didSelectLogOut;

  const ProfileSettingsScreen({super.key, required this.model, required this.isActivityApp, required this.didSelectLogOut, required this.didDeleteAccount, required this.isWeb, required this.didSelectNav, this.currentSettingsMarker});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {

  late bool isLoggedIn = false;
  late bool logOutIsOn = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: retrieveAuthenticationState(context),
    );
  }

  Widget retrieveAuthenticationState(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => getIt<AuthBloc>()..add(const AuthEvent.mobileAuthCheckRequested())),
          BlocProvider(create: (_) => getIt<UserProfileWatcherBloc>()..add(const UserProfileWatcherEvent.watchUserProfileStarted())),
        ],
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            setState(() {
            state.maybeMap(
                authenticatedUser: (_) {
                  isLoggedIn = true;
                  return;
                },
                unauthenticated: (_) {
                  isLoggedIn = false;
                  return;
                },
                orElse: () {
                  isLoggedIn = false;
                  return;
                }
              );
            });
          },
          child: BlocBuilder<UserProfileWatcherBloc, UserProfileWatcherState>(
            builder: (context, authState) {
              return authState.maybeMap(
                  loadInProgress: (_) => JumpingDots(color: widget.model.paletteColor, numberOfDots: 3),
                  loadProfileFailure: (_) => GetLoginSignUpWidget(
                    showFullScreen: true,
                    model: widget.model,
                    didLoginSuccess: () {

                    },
                  ),
                  loadUserProfileSuccess: (item) {
                    if (!logOutIsOn) {
                      isLoggedIn = true;
                    } else {
                      isLoggedIn = false;
                    }
                    return getUserProfileSettings(context, widget.model, item.profile);
                  },
                  orElse: () {
                    return JumpingDots(color: widget.model.paletteColor, numberOfDots: 3);
              }
            );
          },
        ),
      ),
    );
  }


  Widget getUserProfileSettings(BuildContext context, DashboardModel model, UserProfileModel profile) {
    if (!isLoggedIn) {
      return GetLoginSignUpWidget(
        showFullScreen: true,
        model: widget.model,
        didLoginSuccess: () {

        },
      );
    } else {
      return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: !widget.isWeb,
             child: Column(
                 mainAxisAlignment: MainAxisAlignment.start,
                 crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 const SizedBox(height: 12),
                 Text('Profile', style: TextStyle(color: model.paletteColor,
                     fontSize: model.questionTitleFontSize,
                     fontWeight: FontWeight.bold)),
                 const SizedBox(height: 24),

                 Visibility(
                   visible: !widget.isActivityApp,
                   child: Column(
                     mainAxisAlignment: MainAxisAlignment.start,
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Container(
                         decoration: BoxDecoration(
                             color: model.paletteColor,
                             borderRadius: BorderRadius.circular(15)
                         ),
                         child: Padding(
                           padding: const EdgeInsets.symmetric(vertical: 18.0),
                           child: Center(
                             child: Row(
                               mainAxisAlignment: MainAxisAlignment.start,
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Padding(
                                   padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                   child: Icon(
                                     Icons.event, color: model.accentColor, size: 32,),
                                 ),
                                 Expanded(
                                   child: Column(
                                     mainAxisAlignment: MainAxisAlignment.start,
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: [
                                       Text('Start Hosting an Event or Space',
                                           style: TextStyle(color: model.accentColor,
                                               fontSize: model
                                                   .secondaryQuestionTitleFontSize,
                                               fontWeight: FontWeight.bold)),
                                       const SizedBox(height: 4),
                                       Text('Let everyone know what you are looking to do.',
                                           style: TextStyle(color: model.accentColor))
                                     ],
                                   ),
                                 )
                               ],
                             ),
                           ),
                         ),
                       ),
                       const SizedBox(height: 24),

                       InkWell(
                         onTap: () {
                           dedSelectProfilePopOverOnly(context, model, profile);
                         },
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Row(
                               children: [
                                 if (profile.profileImage != null) ClipRRect(
                                   borderRadius: BorderRadius.circular(50),
                                   child: Container(
                                     height: 75,
                                     width: 75,
                                     child: Image(image: profile.profileImage!.image, fit: BoxFit.cover),
                                   ),
                                 ),
                                 if (profile.profileImage == null) Container(
                                   height: 50,
                                   width: 50,
                                   decoration: BoxDecoration(
                                       color: model.accentColor,
                                       borderRadius: BorderRadius.circular(25)
                                   ),
                                   child: Center(child: Text(profile.legalName
                                       .getOrCrash()[0], style: TextStyle(
                                       color: model.paletteColor,
                                       fontSize: model.questionTitleFontSize))),
                                 ),
                                 const SizedBox(width: 16),
                                 Column(
                                   mainAxisAlignment: MainAxisAlignment.start,
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                     Text('${profile.legalName.getOrCrash()}\'s profile',
                                         style: TextStyle(color: model.paletteColor,
                                             fontWeight: FontWeight.bold,
                                             fontSize: model
                                                 .secondaryQuestionTitleFontSize)),
                                     const SizedBox(height: 4),
                                     Text('review profile', style: TextStyle(color: model
                                         .disabledTextColor))
                                   ],
                                 )
                               ],
                             ),

                             Icon(Icons.keyboard_arrow_right_rounded,
                                 color: model.paletteColor)

                           ],
                         ),
                       ),

                       if (kIsWeb == false) const SizedBox(height: 12),
                       if (kIsWeb == false) Divider(color: model.disabledTextColor, height: 1),
                       const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ]
              )
            ),

            Text('Account Settings', style: TextStyle(color: model.paletteColor,
                fontSize: model.secondaryQuestionTitleFontSize,
                fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            ...accountSettingsList(widget.isActivityApp).map(
                    (e) =>
                    profileSettingItemWidget(
                        model,
                        e.icon,
                        e.title,
                        false,
                        (widget.currentSettingsMarker == null) ? true : widget.currentSettingsMarker == e.marker,
                        didSelectItem: () async {
                          switch (e.marker) {
                            case ProfileSettingMarker.personalIno:
                              if (kIsWeb) {
                                widget.didSelectNav(e.marker);
                              } else {
                              Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                                return PersonalInformationProfile(
                                  model: widget.model,
                                  profile: profile,
                                    didDeleteAccount: () => widget.didDeleteAccount(),
                                  );
                                }));
                              }
                              break;
                            case ProfileSettingMarker.payments:
                              if (kIsWeb) {
                                widget.didSelectNav(e.marker);
                              } else {
                              Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                                return PaymentsPayoutsProfile(
                                    model: widget.model,
                                    isActivityVersion: widget.isActivityApp,
                                    profile: profile,
                                  );
                                }));
                              }
                              break;
                            case ProfileSettingMarker.notification:
                              if (kIsWeb) {
                                widget.didSelectNav(e.marker);
                              } else {
                              Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                                  return NotificationProfile(
                                    model: widget.model
                                  );
                                }));
                              }
                              break;
                            case ProfileSettingMarker.privacy:
                                if (await canLaunchUrlString('https://cincout.wixstudio.io/circle/privacy-policy')) {
                                  launchUrlString('https://cincout.wixstudio.io/circle/privacy-policy');
                                }
                              break;
                            default:
                              break;
                          }
                        }
                    )
            ).toList(),

            if (kIsWeb) Divider(color: model.disabledTextColor.withOpacity(0.4), height: 1),

            Visibility(
              visible: !widget.isActivityApp,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  Text('Hosting', style: TextStyle(color: model.paletteColor,
                      fontSize: model.secondaryQuestionTitleFontSize,
                      fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  ...accountHostingList(context).map(
                          (e) =>
                          profileSettingItemWidget(
                              model,
                              e.icon,
                              e.title,
                              false,
                              (widget.currentSettingsMarker == null) ? true : widget.currentSettingsMarker == e.marker,
                              didSelectItem: () {
                                widget.didSelectNav(e.marker);
                                switch (e.marker) {
                                  case ProfileSettingMarker.switchToHosting:
                                  // TODO: Handle this case.
                                    break;
                                  case ProfileSettingMarker.listSpace:
                                  // TODO: Handle this case.
                                    break;
                                  case ProfileSettingMarker.listActivity:
                                  // TODO: Handle this case.
                                    break;
                                  case ProfileSettingMarker.manageSpace:
                                  // TODO: Handle this case.
                                    break;
                                  default:
                                    break;
                              }
                            }
                          )
                  ).toList(),
                ],
              )
            ),

            if (kIsWeb) Divider(color: model.disabledTextColor.withOpacity(0.4), height: 1),

            const SizedBox(height: 32),
            Text('Support', style: TextStyle(color: model.paletteColor,
                fontSize: model.secondaryQuestionTitleFontSize,
                fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            ...accountSupportList(context).map(
                    (e) =>
                    profileSettingItemWidget(
                        model,
                        e.icon,
                        e.title,
                        false,
                        (widget.currentSettingsMarker == null) ? true : widget.currentSettingsMarker == e.marker,
                        didSelectItem: () async {
                          switch (e.marker) {
                            case ProfileSettingMarker.howWorks:
                              if (await canLaunchUrlString('https://cincout.wixstudio.io/circle/organizers')) {
                                launchUrlString('https://cincout.wixstudio.io/circle/organizers');
                              }
                              break;
                            case ProfileSettingMarker.getHelp:
                              final Uri params = Uri(
                                scheme: 'mailto',
                                path: 'hello@cincout.ca',
                                query: encodeQueryParameters(<String, String>{
                                  'subject':'Looking for Help - Circle Activities Issue',
                                }),
                              );

                              if (await url.canLaunchUrl(params)) {
                                url.launchUrl(params);
                              }

                              break;
                            case ProfileSettingMarker.giveFeedback:
                              final Uri params = Uri(
                                scheme: 'mailto',
                                path: 'hello@cincout.ca',
                                query: encodeQueryParameters(<String, String>{
                                  'subject':'Feedback - Circle Activities Notes',
                                }),
                              );

                              if (await url.canLaunchUrl(params)) {
                                url.launchUrl(params);
                              }

                              break;
                            case ProfileSettingMarker.termsOfService:
                              if (await canLaunchUrlString('https://docs.google.com/document/d/1G802TQimGBnNeNaDQPkRdlsHjqQUaHYSoZ3-L2-9eqI/edit#heading=h.9joqcpsrjy0v')) {
                                launchUrlString('https://docs.google.com/document/d/1G802TQimGBnNeNaDQPkRdlsHjqQUaHYSoZ3-L2-9eqI/edit#heading=h.9joqcpsrjy0v');
                              }
                              break;
                            case ProfileSettingMarker.privacyPolicy:
                              if (await canLaunchUrlString('https://docs.google.com/document/d/1-frxciDuE0fCsg6kEkAhCY-cI-sa2BZt4MbDh77_kA0/edit#heading=h.rtckfw40g6p4')) {
                                launchUrlString('https://docs.google.com/document/d/1-frxciDuE0fCsg6kEkAhCY-cI-sa2BZt4MbDh77_kA0/edit#heading=h.rtckfw40g6p4');
                              }
                              break;
                            default:
                              break;
                          }
                        }
                    )
            ).toList(),
            if (kIsWeb) Divider(color: model.disabledTextColor.withOpacity(0.4), height: 1),

            const SizedBox(height: 32),
            Text('Legal', style: TextStyle(color: model.paletteColor,
                fontSize: model.secondaryQuestionTitleFontSize,
                fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            ...accountLegalList(context).map(
                    (e) => profileSettingItemWidget(
                      model,
                      e.icon,
                      e.title,
                      false,
                      (widget.currentSettingsMarker == null) ? true : widget.currentSettingsMarker == e.marker,
                      didSelectItem: ()  async{
                        // widget.didSelectNav(e.marker);
                        switch (e.marker) {
                          case ProfileSettingMarker.termsOfService:
                              if (await canLaunchUrlString('https://docs.google.com/document/d/1G802TQimGBnNeNaDQPkRdlsHjqQUaHYSoZ3-L2-9eqI/edit#heading=h.9joqcpsrjy0v')) {
                              launchUrlString('https://docs.google.com/document/d/1G802TQimGBnNeNaDQPkRdlsHjqQUaHYSoZ3-L2-9eqI/edit#heading=h.9joqcpsrjy0v');
                              }
                            break;
                          case ProfileSettingMarker.privacyPolicy:
                            if (await canLaunchUrlString('https://docs.google.com/document/d/1-frxciDuE0fCsg6kEkAhCY-cI-sa2BZt4MbDh77_kA0/edit#heading=h.rtckfw40g6p4')) {
                              launchUrlString('https://docs.google.com/document/d/1-frxciDuE0fCsg6kEkAhCY-cI-sa2BZt4MbDh77_kA0/edit#heading=h.rtckfw40g6p4');
                            }
                            break;
                          default:
                            break;
                        }
                      }
                    )
                  ).toList(),
            if (kIsWeb) Divider(color: model.disabledTextColor.withOpacity(0.4), height: 1),
            const SizedBox(height: 32),

            InkWell(
              onTap: () {
                setState(() {
                  context.read<AuthBloc>().add(const AuthEvent.signedOut());
                  isLoggedIn = false;
                  logOutIsOn = true;
                  widget.didSelectLogOut();
                });
              },
              child: Text('Log Out', style: TextStyle(color: model.paletteColor,
                  fontSize: model.secondaryQuestionTitleFontSize,
                  decoration: TextDecoration.underline),),
            ),
            const SizedBox(height: 32),
            Text('V. 1.0.9', style: TextStyle(color: model.disabledTextColor)),
            const SizedBox(height: 32),
          ],
        ),
      );
    }
  }
}