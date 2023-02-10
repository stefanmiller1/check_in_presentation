library check_in_presentation;

import 'dart:math';

import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_credentials/check_in_credentials.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:intl/intl.dart';
import 'package:patterns_canvas/patterns_canvas.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:collection';

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

part 'listing_manager_core_widgets/space_option_info_widgets.dart';

part 'profile_core_widgets/profile_user_widget.dart';

part 'calendar_core_widgets/date_time_core_helper.dart';

part 'core/phone_field_view_widget.dart';
part 'core/fliter_selection_widget.dart';
part 'core/payment_method_widget.dart';
