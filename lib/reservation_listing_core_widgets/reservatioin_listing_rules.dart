part of check_in_presentation;

IconData getRuleTypeIcon(CustomRuleObjectType type) {
  switch (type) {

    case CustomRuleObjectType.textFieldRule:
      return Icons.pending_actions;
    case CustomRuleObjectType.singleSelectionRule:
      return Icons.list;
    case CustomRuleObjectType.multiSelectionRule:
      return Icons.playlist_add_check_rounded;
    case CustomRuleObjectType.numberLimitRule:
      return Icons.confirmation_number_outlined;
    case CustomRuleObjectType.checkBoxRule:
      return Icons.check_box_outlined;
  }
}