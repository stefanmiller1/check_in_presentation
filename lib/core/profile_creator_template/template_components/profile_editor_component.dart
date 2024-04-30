import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/cupertino.dart';

import '../profile_creator_template_helper.dart';

class ProfileEditorComponent extends StatelessWidget {

  final DashboardModel model;
  final bool isVisible;
  final ProfileEditorWidgetModel editorWidget;

  const ProfileEditorComponent({super.key,
    required this.model,
    required this.editorWidget,
    required this.isVisible
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: AnimatedContainer(
        height: isVisible ? editorWidget.height : 0,
        curve: Curves.easeInOut,
        duration: const Duration(milliseconds: 400),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: model.disabledTextColor),
                borderRadius: BorderRadius.circular(25)
              ),
                child: editorWidget.editorItem),
          ),
        ),
      ),
    );
  }
}

