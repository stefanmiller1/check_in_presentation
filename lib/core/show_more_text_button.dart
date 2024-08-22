part of check_in_presentation;

class ExpandableText extends StatefulWidget {
  final String text;
  final DashboardModel model;
  final double width;
  final int maxLines;

  const ExpandableText({
    Key? key,
    required this.text,
    required this.model,
    this.maxLines = 2,
    required this.width,
  }) : super(key: key);

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _isExpanded = false;
  bool _isOverflowing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkOverflow());
  }

  void _checkOverflow() {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: widget.text),
      maxLines: 1,
      textDirection: UI.TextDirection.ltr
    )..layout(maxWidth: widget.width); // Adjust width based on your layout

    if (textPainter.didExceedMaxLines) {
      setState(() {
        _isOverflowing = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          widget.text,
          style: TextStyle(color: widget.model.disabledTextColor, overflow: TextOverflow.ellipsis),
          maxLines: (_isExpanded == true) ? 10 : widget.maxLines,
        ),
        const SizedBox(height: 8),
        if (_isOverflowing) InkWell(
          child: Text(
            _isExpanded ? 'Show Less' : 'Show More',
            style: TextStyle(
                color: _isExpanded ? widget.model.disabledTextColor : widget.model.paletteColor,
                fontWeight: FontWeight.bold),
          ),
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
        ),
      ],
    );
  }
}