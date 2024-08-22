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




Widget emptyLargeListView(BuildContext context, int count, Axis axis, bool isBrowser) {
  return Container(
    height: (isBrowser) ? MediaQuery.of(context).size.height : MediaQuery.of(context).size.height - 230,
    width: MediaQuery.of(context).size.width,
    child: ListView.builder(
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
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey.shade400,
                    highlightColor: Colors.grey.shade100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 300,
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
              )
            ),
          )
        );
      }
    ),
  );
}