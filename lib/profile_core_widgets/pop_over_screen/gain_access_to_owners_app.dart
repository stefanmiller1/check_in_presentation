part of check_in_presentation;

class RequestAccessPopover extends StatelessWidget {

  final DashboardModel model;
  final VoidCallback onSendRequest;
  final VoidCallback onCancel;

  RequestAccessPopover({required this.onSendRequest, required this.onCancel, required this.model});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.send, color: model.paletteColor, size: 28),
                const SizedBox(width: 10),
                Text(
                  'Request Access',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              "'a circle' provides owners with tools to manage their facilities and connect with organizers. Send a request to gain access to these exclusive features.",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: onSendRequest,
                  child: Row(
                    children: [
                      Icon(Icons.send),
                      const SizedBox(width: 8),
                      Text('Send Request'),
                    ],
                  ),
                ),
                OutlinedButton(
                  onPressed: onCancel,
                  child: Row(
                    children: [
                      Icon(Icons.cancel),
                      const SizedBox(width: 8),
                      Text('Cancel'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}