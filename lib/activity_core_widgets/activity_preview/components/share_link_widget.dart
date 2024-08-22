part of check_in_presentation;

class ShareActivityUrlWidget extends StatefulWidget {
  final String url;
  final DashboardModel model;
  final bool isPrivate;
  final bool isInviteOnly;

  ShareActivityUrlWidget({
    required this.url,
    required this.model,
    this.isPrivate = false,
    this.isInviteOnly = false,
  });

  @override
  _ShareActivityUrlWidgetState createState() => _ShareActivityUrlWidgetState();
}

class _ShareActivityUrlWidgetState extends State<ShareActivityUrlWidget> {
  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied to Clipboard!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Share Your Activity',
            style: TextStyle(
              fontSize: widget.model.secondaryQuestionTitleFontSize,
              color: widget.model.paletteColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            _getDescriptionText(),
            style: TextStyle(color: widget.model.disabledTextColor),
          ),
          SizedBox(height: 16),
          if (widget.isPrivate)
            _buildPrivateNotice()
          else
            Center(
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => _copyToClipboard(widget.url),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: widget.model.disabledTextColor.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'My Custom Link',
                          style: TextStyle(
                            color: widget.model.disabledTextColor,
                            fontSize: widget.model.secondaryQuestionTitleFontSize,
                          ),
                        ),
                        SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.link_rounded, color: widget.model.disabledTextColor),
                            if (widget.isInviteOnly) ...[
                              SizedBox(width: 8),
                              Icon(Icons.lock, color: widget.model.disabledTextColor),
                            ],
                            SizedBox(width: 8),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: widget.model.accentColor.withOpacity(0.75),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(14.0),
                                  child: Text(
                                    widget.url,
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: widget.model.disabledTextColor,
                                      // decoration: TextDecoration.underline,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (widget.isInviteOnly)
                          Text(
                            'This activity is hidden from public view but can be accessed by anyone with the link.',
                            style: TextStyle(color: widget.model.disabledTextColor),
                            textAlign: TextAlign.center,
                          ),
                        Text(
                          'Select above to copy',
                          style: TextStyle(color: widget.model.disabledTextColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _getDescriptionText() {
    if (widget.isPrivate) {
      return 'A URL is not available when the activity is set to private.';
    } else if (widget.isInviteOnly) {
      return 'You can share this URL to let others access your activity directly. This activity is hidden from public view but can be accessed by anyone with the link.';
    } else {
      return 'You can share this URL to let others access your activity directly. Simply click on the URL below to copy it to your clipboard.';
    }
  }

  Widget _buildPrivateNotice() {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: widget.model.disabledTextColor.withOpacity(0.25),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          'A URL is not available when the activity is set to private.',
          style: TextStyle(color: widget.model.disabledTextColor),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}