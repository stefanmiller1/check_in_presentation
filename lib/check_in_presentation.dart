library check_in_presentation;

import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:check_in_application/misc/watcher_services/stripe_watcher_services/stripe_payment_watcher_bloc.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/foundation.dart';
import 'package:avatar_stack/avatar_stack.dart';
import 'package:check_in_application/auth/update_services/listing_update_create_services/settings_update_create_services/activity_settings/activity_settings_form_bloc.dart';
import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_credentials/check_in_credentials.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_facade/check_in_facade.dart' as facade;
import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:glowy_borders/glowy_borders.dart';
import 'package:implicitly_animated_reorderable_list_2/implicitly_animated_reorderable_list_2.dart';
import 'package:implicitly_animated_reorderable_list_2/transitions.dart';
import 'package:intl/intl.dart';
import 'package:intl/number_symbols_data.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';
// import 'package:pattern_formatter/pattern_formatter.dart';
import 'package:patterns_canvas/patterns_canvas.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:collection';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:check_in_application/auth/update_services/listing_update_create_services/attendee_update_create_services/listing_attendee_form_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:typed_data';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:dartz/dartz.dart' as dart;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:check_in_domain/domain/misc/attendee_services/attendee_item/attendee_item.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'core/image_picker_core.dart' if (dart.library.html) 'core/image_picker_core_for_web.dart';
import 'package:auth_buttons/auth_buttons.dart';
import 'core/web_core/payment_core/widgets/embedded_stripe_checkout.dart' if (dart.library.html) 'core/web_core/payment_core/widgets/embedded_stripe_checkout_for_web.dart';
import 'package:lottie/lottie.dart';
import 'package:add_to_wallet/add_to_wallet.dart';
import 'package:flutter_wallet_card/flutter_wallet_card.dart';
import 'package:flutter_wallet_card/core/passkit.dart';
import 'package:pass_flutter/pass_flutter.dart';

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
part 'listing_manager_core_widgets/helpers/check_in_edit_helper.dart';
part 'listing_manager_core_widgets/helpers/custom_rule_edit_helper.dart';
part 'listing_manager_core_widgets/payment_info_widget.dart';
part 'listing_manager_core_widgets/helpers/cancellation_edit_widgets.dart';
part 'listing_manager_core_widgets/helpers/check_in_form_edit_widget.dart';
part 'listing_manager_core_widgets/helpers/custom_rule_edit_widget.dart';

part 'profile_core_widgets/profile_user_widget.dart';

part 'calendar_core_widgets/date_time_core_helper.dart';

part 'core/search_user_profile_widget.dart';
part 'core/phone_field_view_widget.dart';
part 'core/fliter_selection_widget.dart';
part 'core/web_core/payment_core/widgets/payment_method_widget.dart';
part 'core/web_core/payment_core/widgets/payment_history_widget.dart';
part 'core/web_core/payment_core/check_out_payment_flow_widget.dart';
part 'core/indicator_widget.dart';
part 'core/main_form_buttons_widget.dart';
part 'core/list_wheel_scroll_view.dart';
part 'core/search_profiles_widget.dart';
part 'core/attendee_type_helper_widget.dart';
part 'core/web_core/payment_core/check_out_payment_helper.dart';
part 'core/create_new_main.dart';
part 'core/completed_task_animation_widget.dart';
part 'core/web_core/payment_core/widgets/payment_processing_widget.dart';
part 'core/check_out_view_widget.dart';
part 'core/animated_complete_button.dart';
part 'core/on_boarding_pop_over_widget.dart';

part 'activity_core_widgets/activity_icon_helper_widgets.dart';
part 'activity_core_widgets/activity_instrutctor_helper_widgets.dart';
part 'activity_core_widgets/activity_listing_settings_helper.dart';
part 'activity_core_widgets/activity_background_info_settings_widget.dart';
part 'activity_core_widgets/activity_requirements_setting_widget.dart';
part 'activity_core_widgets/activity_reservation_settings_widget.dart';
part 'activity_core_widgets/activity_visibility_settings_widget.dart';
part 'activity_core_widgets/activity_cancellation_setting_widget.dart';
part 'activity_core_widgets/activity_custom_rule_info_widget.dart';
part 'activity_core_widgets/activity_check_in_info.dart';
part 'activity_core_widgets/activity_general_rules_widget.dart';
part 'activity_core_widgets/activity_attendee_type_widget.dart';
part 'activity_core_widgets/activity_ticket_attendee_widget.dart';
part 'activity_core_widgets/pop_over_main_container_widgets/create_new_vendor/create_new_vendor_merchant.dart';
part 'activity_core_widgets/pop_over_main_container_widgets/create_new_vendor/vendor_merchant_helper.dart';
part 'activity_core_widgets/pop_over_main_container_widgets/create_new_partner/create_new_partner.dart';
part 'activity_core_widgets/pop_over_main_container_widgets/create_new_instructor/create_new_instructor_form.dart';
part 'activity_core_widgets/pop_over_main_container_widgets/create_new_instructor/instructor_helper.dart';
part 'activity_core_widgets/pop_over_main_container_widgets/create_new_instructor/create_new_experience.dart';
part 'activity_core_widgets/pop_over_main_container_widgets/create_new_instructor/create_new_certification.dart';
part 'activity_core_widgets/pop_over_main_container_widgets/create_new_ticket_holder/create_new_ticket_holder_attendee.dart';
part 'activity_core_widgets/pop_over_main_container_widgets/create_new_ticket_holder/activity_ticket_pricing_cancellation_helper.dart';
part 'activity_core_widgets/pop_over_main_container_widgets/present_ticket/present_attendee_ticket_widget.dart';
part 'activity_core_widgets/pop_over_main_container_widgets/create_new_attendee/create_new_activity_attendee.dart';
part 'activity_core_widgets/pop_over_main_container_widgets/create_new_attende_helper.dart';
part 'activity_core_widgets/pop_over_main_container_widgets/request_partnership_attendee/request_new_partner_attendee.dart';


part 'attendee_core_widgets/attendee_reservation_settings_helper.dart';
part 'attendee_core_widgets/attendee_profile_helper.dart';

part 'account/login_signup_core.dart';
part 'account/login_forgot_password_email.dart';
part 'account/login_email_core.dart';

part 'location_core_widgets/search_locations_google_places.dart';

part 'dashboard_core_widgets/counter_badge_widget.dart';

part 'booking_widgets/booking_slot_helper.dart';

part 'widget_transitions/create_widget_transitions.dart';