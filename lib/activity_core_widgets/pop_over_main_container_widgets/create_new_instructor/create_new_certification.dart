part of check_in_presentation;

class CreateNewCertificateForm extends StatefulWidget {

  final CertificateOption? certificateOption;
  final DashboardModel model;
  final Function(CertificateOption) savedCertificate;

  const CreateNewCertificateForm({Key? key, required this.certificateOption, required this.model, required this.savedCertificate}) : super(key: key);

  @override
  State<CreateNewCertificateForm> createState() => _CreateNewCertificateFormState();
}

class _CreateNewCertificateFormState extends State<CreateNewCertificateForm> {

  late TextEditingController? certificateTextController;
  late CertificateOption certificateOption = CertificateOption(certificateType: CertificateType.Skilled, dateReceived: DateTime.now(), certificateTitle: FirstLastName(''));

  @override
  void initState() {
    certificateTextController = TextEditingController();
    if (widget.certificateOption != null) {
      certificateOption = widget.certificateOption!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final bool isValidCertificate = certificateOption.certificateTitle.isValid();

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleTextStyle: TextStyle(color: widget.model.paletteColor),
        title: Text('Add Your Certificate'),
        toolbarHeight: 100,
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        actions: [
          Column(
            children: [
              SizedBox(height: 30),
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.cancel_outlined, color: widget.model.paletteColor, size: 40),
                padding: EdgeInsets.all(1),
              ),
            ],
          ),
          SizedBox(width: 40)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 230,
                    child: Text(AppLocalizations.of(context)!.activityClassesBackgroundMoreType, style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                  ),
                  Expanded(
                    child: Text(AppLocalizations.of(context)!.activityClassesBackgroundMoreCertificateSub, style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                  )
                ],
              ),
            ),

            const SizedBox(height: 10),
            Row(
              children: [
                Container(
                  width: 210,
                  child: DropdownButtonHideUnderline(
                      child: DropdownButton2(
                          // offset: const Offset(-10,-15),
                          isDense: true,
                          // buttonElevation: 0,
                          // buttonDecoration: BoxDecoration(
                          //   color: Colors.transparent,
                          //   borderRadius: BorderRadius.circular(35),
                          // ),
                          customButton: Container(
                            decoration: BoxDecoration(
                              color: widget.model.accentColor,
                              borderRadius: BorderRadius.circular(35),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(2.5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(getCertificateName(context, certificateOption!.certificateType), style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Icon(Icons.keyboard_arrow_down_rounded, size: 45, color: widget.model.disabledTextColor),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          onChanged: (Object? navItem) {
                          },
                          // buttonWidth: 80,
                          // buttonHeight: 70,
                          // dropdownElevation: 1,
                          // dropdownPadding: const EdgeInsets.all(1),
                          // dropdownDecoration: BoxDecoration(
                          //     boxShadow: [BoxShadow(
                          //         color: Colors.black.withOpacity(0.11),
                          //         spreadRadius: 1,
                          //         blurRadius: 15,
                          //         offset: Offset(0, 2)
                          //     )
                          //     ],
                          //     color: widget.model.cardColor,
                          //     borderRadius: BorderRadius.circular(14)),
                          // itemHeight: 50,
                          // dropdownWidth: MediaQuery.of(context).size.width,
                          // focusColor: Colors.grey.shade100,
                          items: CertificateType.values.map(
                                  (e) => DropdownMenuItem<CertificateType>(
                                  onTap: () {
                                    setState(() {
                                      certificateOption = certificateOption.copyWith(
                                          certificateType: e
                                      );
                                    });
                                  },
                                  value: e,
                                  child: Text(getCertificateName(context, e), style: TextStyle(color: widget.model.disabledTextColor)
                                  )
                              )
                          ).toList()
                      )
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: getDescriptionTextField(
                      context,
                      widget.model,
                      certificateTextController!,
                      '',
                      1,
                      32,
                      updateText: (value) {
                        setState(() {
                          certificateOption = certificateOption.copyWith(
                              certificateTitle: FirstLastName(value)
                          );
                      });
                    }
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            /// save
            InkWell(
              onTap: () {
                if (isValidCertificate) {
                  widget.savedCertificate(certificateOption);
                  Navigator.of(context).pop();
                }
              },
              child: Container(
                width: 675,
                height: 60,
                decoration: BoxDecoration(
                  color: (isValidCertificate) ? widget.model.paletteColor : widget.model.webBackgroundColor,
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                ),
                child: Align(
                  child: Text('Save Certificate', style: TextStyle(color: (isValidCertificate) ? widget.model.accentColor : widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}