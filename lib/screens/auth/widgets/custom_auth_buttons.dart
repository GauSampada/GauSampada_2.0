// import 'package:flutter/material.dart';
// import 'package:gausampada/const/colors.dart';

// class LoginSignupButtons extends StatelessWidget {
//   final String? imagepath;
//   final String label;
//   final void Function()? onTap;
//   final bool isLoading;
//   final Color? backgroundColor;

//   const LoginSignupButtons(
//       {super.key,
//       this.imagepath,
//       required this.label,
//       required this.onTap,
//       this.isLoading = false,
//       this.backgroundColor});

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double buttonWidth = screenWidth * 0.45;
//     double buttonHeight = screenWidth * 0.12;
//     return ElevatedButton(
//         onPressed: isLoading ? null : onTap,
//         style: ElevatedButton.styleFrom(
//           side: const BorderSide(color: themeColor, width: 2),
//           backgroundColor: backgroundColor ?? Colors.white,
//         ),
//         child: SizedBox(
//           width: buttonWidth,
//           height: buttonHeight,
//           child: isLoading
//               ? Center(
//                   child: CircularProgressIndicator(
//                     color: Colors.green[800],
//                     strokeWidth: 2.0,
//                   ),
//                 )
//               : imagepath == null
//                   ? Center(
//                       child: Text(label,
//                           style: const TextStyle(
//                               fontSize: 16, color: Colors.white)))
//                   : Row(
//                       children: [
//                         ClipOval(
//                             child: Image.asset(imagepath!,
//                                 height: buttonHeight * 0.7)),
//                         SizedBox(width: buttonWidth * 0.025),
//                         Text(
//                           label,
//                           style:
//                               TextStyle(fontSize: 13, color: Colors.green[800]),
//                         )
//                       ],
//                     ),
//         ));
//   }
// }

import 'package:flutter/material.dart';
import 'package:gausampada/const/colors.dart';

class LoginSignupButtons extends StatelessWidget {
  final String? imagepath;
  final String label;
  final void Function()? onTap;
  final bool isLoading;
  final Color? backgroundColor;

  const LoginSignupButtons({
    super.key,
    this.imagepath,
    required this.label,
    required this.onTap,
    this.isLoading = false,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onTap,
      style: ElevatedButton.styleFrom(
        side: const BorderSide(color: themeColor, width: 2),
        backgroundColor: backgroundColor ?? Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        minimumSize:
            const Size(120, 48), // Minimum size to prevent too small buttons
      ),
      child: isLoading
          ? SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                color: Colors.green[800],
                strokeWidth: 2.0,
              ),
            )
          : imagepath == null
              ? Text(
                  label,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min, // Important for sizing
                  children: [
                    ClipOval(
                      child: Image.asset(
                        imagepath!,
                        height: 32, // Fixed size for the image
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      label,
                      style: TextStyle(fontSize: 13, color: Colors.green[800]),
                    ),
                  ],
                ),
    );
  }
}
