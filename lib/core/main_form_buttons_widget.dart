part of check_in_presentation;

class QuantityButtons extends StatefulWidget {

  final DashboardModel model;
  final int? initNumber;
  final Function(int) counterCallback;

  const QuantityButtons({required this.model, this.initNumber, required this.counterCallback});

  @override
  _QuantityButtonsState createState() => _QuantityButtonsState();
}

class _QuantityButtonsState extends State<QuantityButtons> {

  int? _currentCount;
  Function? _counterCallback;

  @override
  void initState() {
    _currentCount = widget.initNumber ?? 1;
    _counterCallback = widget.counterCallback;
    super.initState();
  }

  @override
  void dispose() {
    _currentCount = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Container(
      width: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 8),
            child: _createIncrementButton(Icons.remove, "dincrement"),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _createIncrementButton(Icons.add, "increment"),
          ),
        ],
      ),
    );
  }

  Widget _createIncrementButton(IconData icon, String type) {
    return RawMaterialButton(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      constraints: BoxConstraints(minWidth: 18.5, minHeight: 18.5),
      onPressed: () {
        if (type == "increment") {
          return _addInterval();
        }
        if (type == "dincrement") {
          return _removeInterval();
        }
      },
      elevation: 0.5,
      fillColor: widget.model.accentColor,
      shape: const CircleBorder(),
      child: Icon(
        icon,
        color: widget.model.paletteColor,
        size: 22.0,
      ),
    );
  }

  void _addInterval() {
    setState(() {
      if (_currentCount != null && _counterCallback != null) {
        _currentCount = _currentCount! + 1;
        _counterCallback!(_currentCount);
      }
    });
  }

  void _removeInterval() {
    setState(() {
      if (_currentCount != null && _currentCount! > 1 && _counterCallback != null) {
        _currentCount = _currentCount! - 1;
        _counterCallback!(_currentCount);
      }
    });
  }

}



