import 'package:direct_caller_sim_choice/direct_caller_sim_choice.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> makePhoneCall(BuildContext context, String phoneNumber) async {
  var status = await Permission.phone.request();
  if (status.isGranted) {
    bool? result = await DirectCaller().makePhoneCall(phoneNumber);
    if (result != true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Failed to make the call. Please try again.")),
      );
    }
  } else if (status.isDenied) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Permission denied. Cannot make a call.")),
    );
  } else if (status.isPermanentlyDenied) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Permission permanently denied. Enable in settings."),
      ),
    );
  }
}

void generateGoogleMeetLink(BuildContext context) async {
  const meetUrl = 'https://meet.google.com/pzm-woon-pok';
  debugPrint('Attempting to launch: $meetUrl');

  try {
    final canLaunch = await canLaunchUrl(Uri.parse(meetUrl));
    debugPrint('Can launch $meetUrl: $canLaunch');
    if (canLaunch) {
      await launchUrl(
        Uri.parse(meetUrl),
        mode:
            LaunchMode.externalNonBrowserApplication, // Prefer Google Meet app
      );
    } else {
      // Fallback: Try launching in browser
      debugPrint('Falling back to in-app browser for $meetUrl');
      await launchUrl(
        Uri.parse(meetUrl),
        mode: LaunchMode.inAppBrowserView,
      );
      // Show fallback option to copy URL
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Could not open Google Meet. Copy link?'),
          action: SnackBarAction(
            label: 'Copy',
            onPressed: () {
              Clipboard.setData(const ClipboardData(text: meetUrl));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Link copied to clipboard')),
              );
            },
          ),
        ),
      );
    }
  } catch (e) {
    debugPrint('Error launching $meetUrl: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error launching Google Meet: $e'),
        action: SnackBarAction(
          label: 'Copy',
          onPressed: () {
            Clipboard.setData(const ClipboardData(text: meetUrl));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Link copied to clipboard')),
            );
          },
        ),
      ),
    );
  }
}
