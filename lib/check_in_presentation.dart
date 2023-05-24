library check_in_presentation;

import 'dart:convert';
import 'dart:math';

import 'package:avatar_stack/avatar_stack.dart';
import 'package:check_in_application/auth/update_services/listing_update_create_services/settings_update_create_services/activity_settings/activity_settings_form_bloc.dart';
import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_credentials/check_in_credentials.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_facade/check_in_facade.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:intl/intl.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:patterns_canvas/patterns_canvas.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:collection';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
// import 'package:check_in_web/presentation/auth_dashboard/manage_dashboard/profile_dashboard/widgets/profile_user_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
// import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
// import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';


part 'check_in_theme_model.dart';
part 'misc.dart';
part 'reservation_listing_core_widgets/reservation_listing_space.dart';
part 'reservation_listing_core_widgets/reservation_listing_pricing_cancellation.dart';
part 'reservation_listing_core_widgets/reservatioin_listing_rules.dart';
part 'reservation_listing_core_widgets/create_new_reservation_helper.dart';
part 'reservation_listing_core_widgets/reservation_listing_calendar.dart';
part 'reservation_listing_core_widgets/reservation_listing_selected_slots.dart';
part 'reservation_listing_core_widgets/reservation_helper.dart';
part 'reservation_profile_core_widgets/reservation_profile_spaces.dart';

part 'messenger_core_widgets/messenger_helper.dart';

part 'listing_manager_core_widgets/space_option_info_widgets.dart';
part 'listing_manager_core_widgets/profile_manager_dashboard.dart';
part 'listing_manager_core_widgets/facility_listing_settings_helper.dart';

part 'profile_core_widgets/profile_user_widget.dart';

part 'calendar_core_widgets/date_time_core_helper.dart';

part 'core/search_user_profile_widget.dart';
part 'core/phone_field_view_widget.dart';
part 'core/fliter_selection_widget.dart';
part 'core/payment_method_widget.dart';
part 'core/indicator_widget.dart';
part 'core/main_form_buttons_widget.dart';
part 'core/list_wheel_scroll_view.dart';

part 'activity_core_widgets/activity_icon_helper_widgets.dart';
part 'activity_core_widgets/activity_instrutctor_helper_widgets.dart';
part 'activity_core_widgets/activity_listing_settings_helper.dart';

part 'location_core_widgets/search_locations_google_places.dart';