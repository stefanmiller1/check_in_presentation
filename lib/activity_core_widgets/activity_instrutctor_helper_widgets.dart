part of check_in_presentation;

Widget instructorWidgetCard(ClassesInstructorProfile instructor, BuildContext context, DashboardModel model) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Text('years of experience: '),
          Text(instructor.numberOfYearsInExperience.toString()),
        ],
      ),
      /// add certificates
      if (instructor.certificates.isNotEmpty) Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          const Text('Certificates:'),
          const SizedBox(height: 8),
          ...instructor.certificates.map(
                  (e) => Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: model.accentColor
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child:
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(e.certificateTitle.value.fold((l) => 'Add Certificate Title', (r) => r)),
                          Text(getCertificateName(context, e.certificateType), style: TextStyle(color: model.disabledTextColor)),
                        ],
                        ),
                      ),
                      Text(DateFormat.yMMM().format(e.dateReceived), style: TextStyle(color: model.disabledTextColor, overflow: TextOverflow.ellipsis), maxLines: 1,)
                  ],
                ),
              )
            )
          ).toList() ?? [],
        ],
      ),
      if (instructor.certificates.isEmpty) const Text('Add Your Certificates'),
      /// add experience
      if (instructor.experience.isNotEmpty) Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          const Text('Experience:'),
          const SizedBox(height: 8),
          ...instructor.experience.map(
                  (e) => Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: model.accentColor
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(e.experienceTitle.value.fold((l) => 'Add Experience', (r) => r), maxLines: 1, )),
                      Text('${DateFormat.y().format(e.experiencePeriod.start)} - ${DateFormat.y().format(e.experiencePeriod.end)}', style: TextStyle(color: model.disabledTextColor)),
                    ],
                  ),
                ),
              )
          ).toList(),
        ],
      ),
    ],
  );
}