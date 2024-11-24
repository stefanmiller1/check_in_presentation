part of check_in_presentation;

class ActivityReviewPricingBreakdown extends StatelessWidget {

  final DashboardModel model;

  const ActivityReviewPricingBreakdown({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: model.paletteColor,
        title: Text('Pricing', style: TextStyle(color: model.accentColor)),
        actions: [

        ],
      ),
      body: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppLocalizations.of(context)!.facilityCosting, style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize)),
                SizedBox(height: 10),
                Text(AppLocalizations.of(context)!.facilityCostingDescription, style: TextStyle(color: model.paletteColor)),
                SizedBox(height: 25),

                Text(AppLocalizations.of(context)!.facilityCostingBase, style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize)),
                SizedBox(height: 10),
                Text(AppLocalizations.of(context)!.facilityCostingBaseDescription, style: TextStyle(color: model.paletteColor)),
                SizedBox(height: 25),
              ],
            ),
          )
      ),
    );
  }

}