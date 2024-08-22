part of check_in_presentation;

// class StickyHeaderWidget extends StatelessWidget {
//
//   final Widget belowHeaderWidget;
//
//   const StickyHeaderWidget({super.key, required this.belowHeaderWidget});
//
//   @override
//   Widget build(BuildContext context) {
//     return CustomScrollView(
//       slivers: [
//         // SliverPersistentHeader(
//         //   pinned: true,
//         //   delegate: _StickyHeaderDelegate(
//         //     minHeight: 60.0,
//         //     maxHeight: 300.0,
//         //     child: Container(
//         //       color: Colors.blue,
//         //       child: Center(
//         //         child: Text(
//         //           'Sticky Header',
//         //           style: TextStyle(color: Colors.white, fontSize: 20),
//         //         ),
//         //       ),
//         //     ),
//         //   ),
//         // ),
//
//         // SliverToBoxAdapter(
//         //   child: belowHeaderWidget,
//         // ),
//
//         // SliverList(
//         //   delegate: SliverChildBuilderDelegate(
//         //         (context, index) => ListTile(
//         //       title: Text('Item #$index'),
//         //     ),
//         //     childCount: 50, // Number of items in the list
//         //   ),
//         // ),
//       ],
//     );
//   }
// }

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _StickyHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return oldDelegate.maxExtent != maxExtent ||
        oldDelegate.minExtent != minExtent ||
        (oldDelegate as _StickyHeaderDelegate).child != child;
  }
}