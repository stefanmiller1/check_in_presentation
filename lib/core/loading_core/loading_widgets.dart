part of check_in_presentation;

Widget emptyLoadingListView(BuildContext context, bool isBrowser) {
  return Container(
    height: (isBrowser) ? MediaQuery.of(context).size.height : MediaQuery.of(context).size.height - 170,
    width: MediaQuery.of(context).size.width,
    child: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: loadingRoomItem(context),
      );
    }),
  );
}




Widget emptyLargeListView(BuildContext context, int count, double height, Axis axis, bool isBrowser) {

final itemWidth = 380.0; // Define fixed item width for browser layout
final screenWidth = MediaQuery.of(context).size.width;
final crossAxisCount = (screenWidth / itemWidth).floor(); // Calculate items per row


Widget shimmerWidget = Shimmer.fromColors(
    baseColor: Colors.grey.shade400,
    highlightColor: Colors.grey.shade100,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.grey.withOpacity(0.15),
          ),
        ),
        const SizedBox(height: 10),
          Container(
            height: 60,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey.withOpacity(0.15),
          ),
        ),
      ],
    )
  );

  return Container(
    height: (isBrowser) ? MediaQuery.of(context).size.height : MediaQuery.of(context).size.height - 230,
    width: MediaQuery.of(context).size.width,
    child: (isBrowser) ? Wrap(
            spacing: 8.0, // Space between items horizontally
            runSpacing: 8.0, // Space between rows vertically
            alignment: WrapAlignment.center,
            children: List.generate(
              count,
              (index) => Container(
                width: itemWidth,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SlideInTransitionWidget(
                    durationTime: 300 * index,
                    offset: Offset(0, 0.25),
                    transitionWidget: shimmerWidget
            )      
          )
        )
      )
    ) : ListView.builder(
        itemCount: count,
        scrollDirection: axis,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SlideInTransitionWidget(
              durationTime: 300 * index,
              offset: Offset(0, 0.25),
              transitionWidget: Container(
                  height: 370,
                  width: (axis == Axis.vertical) ? MediaQuery.of(context).size.width : 380,
                  child: shimmerWidget
            ),
          )
        );
      }
    ),
  );
}