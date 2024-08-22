part of check_in_presentation;

class SingleLineWebFooter extends StatelessWidget {

  final DashboardModel model;

  const SingleLineWebFooter({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: model.webBackgroundColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            _buildTextColumn(
              context,
              model,
              ['Info', 'Terms of Service', 'Privacy Policy'],
              ['https://cincout.wixstudio.io/circle', 'https://docs.google.com/document/d/1G802TQimGBnNeNaDQPkRdlsHjqQUaHYSoZ3-L2-9eqI/edit#heading=h.9joqcpsrjy0v', 'https://cincout.wixstudio.io/circle/privacy-policy'],
            ),
            Text(
              '© CINCOUT 2024 ',
              style: TextStyle(color: model.disabledTextColor),
            ),
          ]
        ),
      )
    );
  }
}

class BasicWebFooter extends StatelessWidget {

  final DashboardModel model;

  const BasicWebFooter({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 600,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTextColumn(
            context,
            model,
            ['Info', 'Instagram', 'Host my Space - coming soon'],
            ['https://cincout.wixstudio.io/circle', instagramLink, ''],
          ),
          _buildTextColumn(
            context,
            model,
            ['Terms of Service', 'Privacy Policy'],
            ['https://docs.google.com/document/d/1G802TQimGBnNeNaDQPkRdlsHjqQUaHYSoZ3-L2-9eqI/edit#heading=h.9joqcpsrjy0v', 'https://cincout.wixstudio.io/circle/privacy-policy'],
          ),
          const SizedBox(height: 16),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '© CINCOUT 2024',
                style: TextStyle(color: model.disabledTextColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void _launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

Widget _buildTextColumn(BuildContext context, DashboardModel model, List<String> texts, List<String> urls) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: texts.asMap().entries.map((entry) {
      int idx = entry.key;
      String text = entry.value;
      return Flexible(
        child: GestureDetector(
          onTap: () => _launchURL(urls[idx]),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              maxLines: 1,
              text,
              style: TextStyle(color: model.paletteColor),
            ),
          ),
        ),
      );
    }).toList(),
  );
}