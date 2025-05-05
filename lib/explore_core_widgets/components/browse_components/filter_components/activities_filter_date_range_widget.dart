part of check_in_presentation;

class DateRangeSliderWidget extends StatefulWidget {

  final int? initialStart;
  final int? initialEnd;
  final DashboardModel model;
  final List<int> monthlyActivityCounts; // List of activity counts for each month (January to December)
  final Function(int StartMonth, int endMonth) didUpdateMonthRange;

  const DateRangeSliderWidget({Key? key, required this.monthlyActivityCounts, required this.model, required this.didUpdateMonthRange, this.initialStart, this.initialEnd}) : super(key: key);

  @override
  _DateRangeSliderWidgetState createState() => _DateRangeSliderWidgetState();
}

class _DateRangeSliderWidgetState extends State<DateRangeSliderWidget> {
  int _startMonth = 1; // January (1)
  int _endMonth = 12; // December (12)

  @override
  void initState() {
    _startMonth = widget.initialStart ?? 1;
    _endMonth = widget.initialEnd ?? 12;
    super.initState();
  }


List<int> generateSmoothNumbers(List<int> input) {
  List<int> result = [];

  for (int i = 0; i < input.length; i++) {
    int current = input[i];
    int? next = i < input.length - 1 ? input[i + 1] : null;

    result.add(current); // Add the current value

    // If next exists, generate smooth numbers with half-step increments
    if (next != null) {
      double step = (next - current) / 2; // Calculate the step to reduce increment by half

      if (current < next) {
        for (double j = current + step; j < next; j += step) {
          result.add(j.round()); // Add rounded half-step increments
        }
      } else if (current > next) {
        for (double j = current + step; j > next; j += step) {
          result.add(j.round()); // Add rounded half-step decrements
        } 
      }
    }
  }
  return result;
}

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Title
        ListTile(
          title: Text('Date Range', style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
          subtitle: Text('Number of Activities based on filter and type for this year: ${_getFilteredActivityCount()}'),
        ),
        // Bar Chart
        SizedBox(
          height: 230,
          child:Stack(
          alignment: Alignment.topCenter,
          children: [
            // SfCartesianChart
            Positioned.fill(
              top: 0,
              bottom: 16.5, // Leave space for the slider
              child: charts.SfCartesianChart(
                borderWidth: 0,
                plotAreaBorderWidth: 0,
                primaryXAxis: charts.CategoryAxis(
                  majorGridLines: const charts.MajorGridLines(width: 0), // Remove grid lines
                  axisLine: const charts.AxisLine(width: 0), // Remove x-axis line
                  labelStyle: const TextStyle(color: Colors.transparent), // Hide labels
                  isVisible: false, // Hide the x-axis completely
                ),
                primaryYAxis: charts.NumericAxis(
                  majorGridLines: const charts.MajorGridLines(width: 0), // Remove grid lines
                  axisLine: const charts.AxisLine(width: 0), // Remove y-axis line
                  labelStyle: const TextStyle(color: Colors.transparent), // Hide labels
                  isVisible: false, // Hide the y-axis completely
                ),
                series: <charts.CartesianSeries>[
                  charts.ColumnSeries<MapEntry<int, int>, String>(
                    dataSource: generateSmoothNumbers(widget.monthlyActivityCounts)
                        .asMap()
                        .entries
                        .toList(),
                    xValueMapper: (entry, _) => (entry.key + 1).toString(),
                    yValueMapper: (entry, _) => entry.value,
                    pointColorMapper: (entry, _) {
                      int smoothMonthIndex = (entry.key * widget.monthlyActivityCounts.length) ~/ generateSmoothNumbers(widget.monthlyActivityCounts).length;

                      if (smoothMonthIndex + 1 >= _startMonth && smoothMonthIndex + 1 <= _endMonth) {
                        return widget.model.paletteColor; // Highlighted bar color
                      }
                      return widget.model.accentColor; // Default bar color
                    },
                    width: 1,
                    spacing: 0.2,
                    animationDuration: 500,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ],
              ),
            ),

            // RangeSlider as X-Axis
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  rangeThumbShape: RoundRangeSliderThumbShape(
                    disabledThumbRadius: 20,
                    enabledThumbRadius: 20,
                    elevation: 8.0,  
                  ),
                  activeTrackColor: widget.model.webBackgroundColor, // Active track color
                  inactiveTrackColor: Colors.grey.shade300, // Inactive track color
                  thumbColor: widget.model.webBackgroundColor, // Thumb (circle) color
                  thumbShape: RoundSliderThumbShape(
                    // disabledThumbRadius: 30.0,
                    enabledThumbRadius: 14.0, // Adjust thumb size (default is 10.0)
                    elevation: 5.5, // Add elevation to the thumb
                  ),// Color for the circle on hover
                  trackHeight: 4.0, // Adjust the thickness of the slider track
                ),
                child: RangeSlider(
                  min: 1,
                  max: 12,
                  divisions: 11,
                  labels: RangeLabels(
                    _monthToString(_startMonth),
                    _monthToString(_endMonth),
                  ),
                  values: RangeValues(_startMonth.toDouble(), _endMonth.toDouble()),
                  onChanged: (values) {
                    setState(() {
                      _startMonth = values.start.toInt();
                      _endMonth = values.end.toInt();
                      widget.didUpdateMonthRange(_startMonth, _endMonth);
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),

          // Month Labels
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  height: 50,
                  decoration: BoxDecoration(
                      color: widget.model.accentColor,
                      borderRadius: BorderRadius.circular(25)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                    child: Text(_monthToString(_startMonth.toInt()), textAlign: TextAlign.center, style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                )
              ),
              Container(
                  height: 50,
                  decoration: BoxDecoration(
                      color: widget.model.accentColor,
                      borderRadius: BorderRadius.circular(25)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                    child: Text(_monthToString(_endMonth.toInt()), textAlign: TextAlign.center, style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                )
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Helper function to convert month index to month name
  String _monthToString(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }

  // Helper function to calculate the total activity count within the selected range
  int _getFilteredActivityCount() {
    int startIndex = _startMonth.toInt() - 1;
    int endIndex = _endMonth.toInt() - 1;
    return widget.monthlyActivityCounts
        .sublist(startIndex, endIndex + 1)
        .reduce((value, element) => value + element);
  }
}

