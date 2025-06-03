import 'package:flutter/material.dart';
import 'package:gausampada/backend/providers/booking_provider.dart';
import 'package:gausampada/const/colors.dart';
import 'package:provider/provider.dart';

class AppooinmentCallScreen extends StatelessWidget {
  final String appointmentId;
  final String callType;

  const AppooinmentCallScreen(
      {super.key, required this.appointmentId, required this.callType});

  @override
  Widget build(BuildContext context) {
    final appointment = Provider.of<AppointmentProvider>(context)
        .currentAppointments
        .firstWhere((a) => a.id == appointmentId);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: themeColor,
        title: Text(
          '${callType.capitalize()} Call with ${appointment.doctorName}',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Implementing ${callType.capitalize()} call with WebRTC',
              style: const TextStyle(fontSize: 20, color: blackColor),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: themeColor),
              onPressed: () => Navigator.pop(context),
              child:
                  const Text('End Call', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
