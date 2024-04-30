part of check_in_presentation;

class SlideInTransitionWidget extends StatefulWidget {
  final Widget transitionWidget;
  final int durationTime;
  final Offset? offset;

  SlideInTransitionWidget({
    Key? key,
    required this.transitionWidget,
    required this.durationTime,
    this.offset,
  }) : super(key: key);

  @override
  State<SlideInTransitionWidget> createState() => _SlideInTransitionWidgetState();
}

class _SlideInTransitionWidgetState extends State<SlideInTransitionWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: Duration(milliseconds: widget.durationTime),
    vsync: this,
  );
  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: widget.offset ?? Offset(0.25, 0),
    end: Offset.zero,
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOut,
  ));
  late final Animation<double> _opacityAnimation = Tween<double>(
    begin: 0.0,
    end: 1.0,
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOut,
  ));

  @override
  void initState() {
    super.initState();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: SlideTransition(
            position: _offsetAnimation,
            child: widget.transitionWidget,
          ),
        );
      },
    );
  }
}