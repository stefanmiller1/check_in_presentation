import 'package:flutter/material.dart';
import '../../check_in_presentation.dart';

class SettingsEditorWidgetTemplate extends StatefulWidget {

  final Widget previewContainer;
  final Widget editorContainer;
  final DashboardModel model;
  final bool isSelected;
  final Function() didSelectBack;

  const SettingsEditorWidgetTemplate({super.key, required this.previewContainer, required this.editorContainer, required this.isSelected, required this.model, required this.didSelectBack});

  @override
  State<SettingsEditorWidgetTemplate> createState() => _SettingsEditorWidgetTemplateState();
}

class _SettingsEditorWidgetTemplateState extends State<SettingsEditorWidgetTemplate> {

  ScrollController? _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }


  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: widget.isSelected,
          child: SlideInTransitionWidget(
            durationTime: 250,
            transitionWidget: widget.editorContainer,
            offset: (widget.isSelected) ?  Offset(-0.15, 0) : Offset(0.25, 0),
          )
        ),
        Visibility(
          visible: widget.isSelected == false,
          child: SlideInTransitionWidget(
            durationTime: 400,
            transitionWidget: widget.previewContainer,
            offset: Offset(0.25, 0),
          )
        ),
      ],
    );
  }
}