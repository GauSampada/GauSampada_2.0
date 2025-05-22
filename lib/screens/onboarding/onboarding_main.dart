import 'package:flutter/material.dart';
import 'package:gausampada/const/colors.dart';
import 'package:gausampada/screens/auth/login.dart';
import 'package:gausampada/screens/onboarding/widgets/onboarding_sub.dart';
import 'package:gausampada/screens/widgets/buttons/elevated.dart';
import 'package:gausampada/screens/widgets/buttons/textfield.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OnboardingMainScreen extends StatefulWidget {
  const OnboardingMainScreen({super.key});

  @override
  State<OnboardingMainScreen> createState() => OnboardingMainScreenState();
}

class OnboardingMainScreenState extends State<OnboardingMainScreen> {
  final PageController controller = PageController(initialPage: 0);
  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: PageView(
              controller: controller,
              onPageChanged: (index) {
                setState(() {
                  isLastPage = index == 4;
                });
              },
              children: [
                OnboardingSubScreen(
                  title: AppLocalizations.of(context)!.onboardingScreen1Title,
                  isLottie: false,
                  address: "assets/feed/cow_info.jpg",
                  description:
                      AppLocalizations.of(context)!.onboardingScreen1Desc,
                ),
                OnboardingSubScreen(
                  title: AppLocalizations.of(context)!.onboardingScreen2Title,
                  isLottie: false,
                  address: "assets/feed/ai_assist.jpg",
                  description:
                      AppLocalizations.of(context)!.onboardingScreen2Desc,
                ),
                OnboardingSubScreen(
                  title: AppLocalizations.of(context)!.onboardingScreen3Title,
                  isLottie: false,
                  address: "assets/feed/farmers.jpg",
                  description:
                      AppLocalizations.of(context)!.onboardingScreen3Desc,
                ),
                OnboardingSubScreen(
                  title: AppLocalizations.of(context)!.onboardingScreen4Title,
                  isLottie: false,
                  address: "assets/feed/products.jpg",
                  description:
                      AppLocalizations.of(context)!.onboardingScreen4Desc,
                ),
                OnboardingSubScreen(
                  title: AppLocalizations.of(context)!.onboardingScreen5Title,
                  isLottie: false,
                  address: "assets/feed/vetenary.jpg",
                  description:
                      AppLocalizations.of(context)!.onboardingScreen5Desc,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 90,
            left: screenWidth * 0.37,
            child: SmoothPageIndicator(
              controller: controller,
              count: 5,
              effect: const ExpandingDotsEffect(
                dotWidth: 10.0,
                dotHeight: 10.0,
              ),
              onDotClicked: (index) {
                controller.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              },
            ),
          ),
          isLastPage
              ? Positioned(
                  bottom: 25,
                  left: screenWidth * 0.33,
                  child: CustomElevatedButton(
                    backgroundColor: themeColor,
                    foregroundColor: backgroundColor,
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    text: AppLocalizations.of(context)!.getStartedBtn,
                  ),
                )
              : Positioned(
                  bottom: 25,
                  left: 20,
                  right: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomTextButton(
                        backgroundColor: themeColor,
                        foregroundColor: backgroundColor,
                        text: AppLocalizations.of(context)!.skipBtn,
                        onPressed: () {
                          controller.jumpToPage(4);
                        },
                      ),
                      CustomTextButton(
                        backgroundColor: themeColor,
                        foregroundColor: backgroundColor,
                        text: AppLocalizations.of(context)!.nextBtn,
                        onPressed: () {
                          controller.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                          );
                        },
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
