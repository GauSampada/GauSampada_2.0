import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class InfoSubScreen extends StatelessWidget {
  final String title;
  final Color? backgroundColor;
  final String address;
  final double? width;

  final void Function()? onTap;

  const InfoSubScreen(
      {super.key,
      required this.title,
      required this.address,
      this.backgroundColor,
      this.width,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: backgroundColor ?? Colors.white,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                  width: screenWidth * 0.4,
                  height: screenWidth * 0.4,
                  child: Image.asset(address!))
            ],
          ),
        ),
      ),
    );
  }
}
