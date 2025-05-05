part of check_in_presentation;

class OnBoardingActivitiesProfile extends StatefulWidget {

  final DashboardModel model;
  final Function() didSelectSkip;
  final Function() didSelectComplete;

  const OnBoardingActivitiesProfile({super.key, required this.model, required this.didSelectSkip, required this.didSelectComplete});

  @override
  State<OnBoardingActivitiesProfile> createState() => _OnBoardingActivitiesProfileState();
}

class _OnBoardingActivitiesProfileState extends State<OnBoardingActivitiesProfile> {

  late bool isLoading = false;
  late PageController? pageController = PageController(initialPage: 0);
  late bool? isVendor = null;
  late bool isVendorProfileCreated = false;
  int _currentPage = 0;


  List<Widget> mainContainer() =>
    [
      SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50),
            Transform.scale(
              scale: 8,
              child: lottie.Lottie.asset(
                  height: 200,
                  repeat: true,
                  'assets/lottie_animations/rPNHNLuaDn.json'
              ),
            ),
            const SizedBox(height: 100),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text('Ok, Let\'s get Started!', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize), textAlign: TextAlign.center),
            ),
            const SizedBox(height: 5),
            Text('Your\'ve joined a circle - Welcome, before you get going we have a few questions - this won\'t take long we promise.', style: TextStyle(color: widget.model.paletteColor, ), textAlign: TextAlign.center),
          ]
        )
      ),

      /// ask if they're a vendor (or small business)?
      SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                 Transform.scale(
                    scale: 1,
                    child: lottie.Lottie.asset(
                        height: 215,
                        repeat: true,
                        'assets/lottie_animations/htd2FoseT7.json'
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('Are You a Vendor or Small Business?', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize), textAlign: TextAlign.center),
                ),
                const SizedBox(height: 5),
                Text('Are you here to explore and enjoy markets or are you looking to set up and sell at your own booth? Your choice will customize your experience to better suit your needs.', style: TextStyle(color: widget.model.disabledTextColor, ), textAlign: TextAlign.center),

                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            isVendor = false;
                          });
                        },
                        child: Container(
                          height: 45,
                          decoration: BoxDecoration(
                            color: (isVendor == false) ? widget.model.paletteColor : widget.model.accentColor,
                            borderRadius: const BorderRadius.all(Radius.circular(40)),
                          ),
                          child: Center(
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Not Yet', style: TextStyle(color: (isVendor == false) ? widget.model.accentColor : widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis, maxLines: 1)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            isVendor = true;
                          });
                        },
                        child: Container(
                          
                          height: 45,
                          decoration: BoxDecoration(
                            color: (isVendor == true) ? widget.model.paletteColor : widget.model.accentColor,
                            borderRadius: const BorderRadius.all(Radius.circular(40)),
                          ),
                          child: Center(
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Yes, I am!', style: TextStyle(color: (isVendor == true) ? widget.model.accentColor : widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis, maxLines: 1)),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 90),
          ]
        )
      ),

      if (isVendor == true) SingleChildScrollView(
        child: Column(
            children: [
              const SizedBox(height: 28),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text('Create Your Profile', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize), textAlign: TextAlign.center),
              ),

              const SizedBox(height: 15),
              /// create profile

              if (isVendorProfileCreated == false)  VendorProfileCreatorEditor(
                model: widget.model,
                didSaveSuccessfully: () {
                  setState(() {
                    isVendorProfileCreated = true;
                    // isVendorMerchProfileEditorVisible = false;
                  });
                },
                didCancel: () {
                  setState(() {
                      isLoading = true;
                      Future.delayed(const Duration(milliseconds: 800), () {
                        setState(() {
                          isLoading = false;
                        });
                      });
                      pageController?.animateToPage(_currentPage - 1, duration: const Duration(milliseconds: 800), curve: Curves.easeInOut);
                  });
                },
                selectedVendorProfile: null,
              ),

              /// new profile created success
              if (isVendorProfileCreated == true) Column(
                children: [
                  /// saved!
                  Icon(Icons.check_circle_outline_rounded, size: 70, color: Colors.green),
                  const SizedBox(height: 25),
                  Text('Profile Saved!', style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize))
                  /// Select Next to Continue
                ],
              ),

              const SizedBox(height: 90),

            ]
        ),
      ),


      if (isVendor == false) SingleChildScrollView(
          child: Column(
              children: [
                Transform.scale(
                  scale: 4,
                  child: lottie.Lottie.asset(
                      height: 300,
                      repeat: true,
                      'assets/lottie_animations/animation_700434682245.json'
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('Thanks for Joining!', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize), textAlign: TextAlign.center),
                ),
                const SizedBox(height: 5),
                Text('Explore a wide range of markets, favorite your top picks, and stay updated with the latest events!', style: TextStyle(color: widget.model.disabledTextColor, ), textAlign: TextAlign.center),
                const SizedBox(height: 20),
                /// let's go button
                InkWell(
                  onTap: () {
                    setState(() {
                      widget.didSelectComplete();
                    });
                  },
                  child: Container(
                    constraints: BoxConstraints(
                        maxWidth: 200
                    ),
                    height: 45,
                    width: 185,
                    decoration: BoxDecoration(
                      color: widget.model.paletteColor,
                      borderRadius: const BorderRadius.all(Radius.circular(40)),
                    ),
                    child: Center(
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Let\'s Go', style: TextStyle(color: widget.model.accentColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis, maxLines: 1)),
                    ),
                  ),
                ),
                const SizedBox(height: 110),
            ]
          )
      ),

      /// explain how to manage/pay/edit applications
      if (isVendor == true)  SingleChildScrollView(
          child: Column(
              children: [
                Transform.scale(
                  scale: 1,
                  child: lottie.Lottie.asset(
                      height: 200,
                      repeat: true,
                      'assets/lottie_animations/8z46mK9a5Y.json'
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('How to Vend..', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize), textAlign: TextAlign.center),
                ),
                const SizedBox(height: 5),
                Text('Perks of Being a vendor - We want to help vendors maximize their potential at markets with tools designed for you based on your feedback.', style: TextStyle(color: widget.model.disabledTextColor, ), textAlign: TextAlign.center),

                ListTile(
                  leading: Icon(Icons.note_alt_outlined, color: widget.model.paletteColor),
                  title: Text('Market Applications:', style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
                  subtitle: Text('Browse and apply directly to markets created by market organizers with integrated search and filtering.', style: TextStyle(color: widget.model.paletteColor)),
                ),
                ListTile(
                  leading: Icon(Icons.settings_applications_outlined, color: widget.model.paletteColor),
                  title: Text('Application Management:', style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
                  subtitle: Text('Cancel, Request and Track application statuses in real time from your profile dashboard.', style: TextStyle(color: widget.model.paletteColor)),
                ),
                ListTile(
                  leading: Icon(Icons.payments_outlined, color: widget.model.paletteColor),
                  title: Text('Secure Payments:', style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
                  subtitle: Text('ay for booth spaces securely using multiple payment methods with instant confirmations.', style: TextStyle(color: widget.model.paletteColor)),
                ),
                ListTile(
                  leading: Icon(Icons.chat_outlined, color: widget.model.paletteColor),
                  title: Text('Communication Tools:', style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
                  subtitle: Text('Direct in-app messaging with market organizers, organized by topic.', style: TextStyle(color: widget.model.paletteColor)),
                ),
                const SizedBox(height: 100),

          ]
        )
      ),

      if (isVendor == true) SingleChildScrollView(
          child: Column(
              children: [
                Transform.scale(
                  scale: 4,
                  child: lottie.Lottie.asset(
                      height: 300,
                      repeat: true,
                      'assets/lottie_animations/animation_700434682245.json'
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('You\'re All Set!', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize), textAlign: TextAlign.center),
                ),
                const SizedBox(height: 5),
                Text('Join our community of vendors, apply to markets, and start selling your products!', style: TextStyle(color: widget.model.disabledTextColor, ), textAlign: TextAlign.center),
                const SizedBox(height: 20),
                /// let's go button
                InkWell(
                  onTap: () {
                    setState(() {
                      widget.didSelectComplete();
                    });
                  },
                  child: Container(
                    constraints: BoxConstraints(
                        maxWidth: 200
                    ),
                    height: 45,
                    width: 185,
                    decoration: BoxDecoration(
                      color: widget.model.paletteColor,
                      borderRadius: const BorderRadius.all(Radius.circular(40)),
                    ),
                    child: Center(
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Let\'s Go', style: TextStyle(color: widget.model.accentColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis, maxLines: 1)),
                ),
              ),
            ),
                const SizedBox(height: 110),
          ]
        )
      ),
    ];

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),

          CreateNewMain(
            isPreviewer: false,
            model: widget.model,
            isLoading: isLoading,
            pageController: pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            child: mainContainer().toList()
          ),


          ClipRRect(
            child: BackdropFilter(
              filter: UI.ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                height: 90,
                width: MediaQuery.of(context).size.width,
                color: widget.model.accentColor.withOpacity(0.5),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Visibility(
                              visible: _currentPage != 0,
                              child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      if (_currentPage == 0) {
                                        Navigator.of(context).pop();
                                      } else {
                                        isLoading = true;
                                        Future.delayed(const Duration(milliseconds: 800), () {
                                          setState(() {
                                            isLoading = false;
                                          });
                                        });
                                        pageController?.animateToPage(_currentPage - 1, duration: const Duration(milliseconds: 800), curve: Curves.easeInOut);
                                      }
                                    });
                                  },
                                  icon: Icon(Icons.arrow_back_ios, color: widget.model.paletteColor)
                              ),
                            ),
                          ],
                        ),
                      ),

                      Visibility(
                        visible: showNextButton(_currentPage),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                isLoading = true;
                                Future.delayed(const Duration(milliseconds: 800), () {
                                  setState(() {
                                    isLoading = false;
                                  });
                                });
                                // if (_currentPage == (mainContainer().length + 1)) {
                                pageController?.animateToPage(_currentPage + 1, duration: const Duration(milliseconds: 800), curve: Curves.easeInOut);
                              });
                            },
                          child: Container(
                            constraints: BoxConstraints(
                                maxWidth: 200
                            ),
                            height: 45,
                            width: 185,
                            decoration: BoxDecoration(
                              color: widget.model.paletteColor,
                              borderRadius: const BorderRadius.all(Radius.circular(40)),
                            ),
                            child: Center(
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Next', style: TextStyle(color: widget.model.accentColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis, maxLines: 1)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          if (_currentPage >= 2) Positioned(
            top: 5,
            right: 10,
            child: InkWell(
              onTap: () {
                setState(() {
                  widget.didSelectComplete();
                });
              },
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Skip', style: TextStyle(color: widget.model.paletteColor, decoration: TextDecoration.underline), overflow: TextOverflow.ellipsis, maxLines: 1)),
            ),
          ),
        ],
      ),
    );
  }


  bool showNextButton(int currentPage) {
    switch (currentPage) {
      case 0:
        return true;
      case 1:
        return isVendor != null;
      case 2:
        if (isVendor == true) {
          return isVendorProfileCreated == true;
        }
        return false;
      default:
        return ((currentPage + 1) < mainContainer().length);
    }
  }


}