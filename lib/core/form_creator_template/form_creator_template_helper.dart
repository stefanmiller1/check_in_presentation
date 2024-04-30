part of check_in_presentation;

class FormCreatorContainerModel {

  final IconData formHeaderIcon;
  final String formHeaderTitle;
  final String? formHeaderSubTitle;
  final String? errorMessage;
  final bool? showErrorMessage;
  final Widget? formSubHelper;
  final Widget formMainCreatorWidget;
  final double height;
  final bool showAddIcon;
  final bool isActivated;
  final bool? isLoading;
  final Function(bool) didSelectActivate;

  FormCreatorContainerModel({
     required this.formHeaderIcon,
     required this.formHeaderTitle,
     this.formHeaderSubTitle,
     this.errorMessage,
     this.showErrorMessage,
     this.formSubHelper,
     this.isLoading,
     required this.formMainCreatorWidget,
     required this.height,
     required this.showAddIcon,
     required this.didSelectActivate,
     required this.isActivated,
  });

}