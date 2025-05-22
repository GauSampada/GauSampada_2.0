import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class OnboardingSubScreen extends StatelessWidget {
  final String title;
  final bool isLottie;
  final String address;
  final String description;
  final Color? backgroundColor;

  const OnboardingSubScreen({
    super.key,
    required this.title,
    required this.isLottie,
    required this.address,
    required this.description,
    this.backgroundColor,
  });
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          isLottie
              ? Lottie.asset(
                  address,
                  height: screenHeight * 0.4,
                  width: 420,
                )
              : Column(
                  children: [
                    Image.asset(
                      address,
                      height: screenHeight * 0.38,
                      width: screenWidth * 0.85,
                      fit: BoxFit.fitWidth,
                    ),
                  ],
                ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
