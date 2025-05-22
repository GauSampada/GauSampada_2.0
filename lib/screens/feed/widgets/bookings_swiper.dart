import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SwiperBuilder extends StatelessWidget {
  const SwiperBuilder({super.key});

  static final List<Map<String, dynamic>> myBookings = [
    {
      "bookingId": "B12345",
      "date": "2025-02-22",
      "service": "Veterinary Checkup",
      "status": "Confirmed",
      "farmerName": "Ramesh Kumar",
      "animalType": "Cow",
      "issueType": "Fever"
    },
    {
      "bookingId": "B12346",
      "date": "2025-02-26",
      "service": "Milk",
      "status": "Pending",
      "farmerName": "Suresh Patil",
      "animalType": "Buffalo",
      "issueType": "Breeding"
    },
    {
      "bookingId": "B12347",
      "date": "2025-02-28",
      "service": "Deworming",
      "status": "Completed",
      "farmerName": "Anita Sharma",
      "animalType": "Cow",
      "issueType": "Parasitic Infection"
    }
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: 180,
      child: Swiper(
        itemWidth: width * 0.9,
        itemHeight: 180,
        loop: true,
        itemCount: myBookings.isEmpty ? 1 : myBookings.length,
        axisDirection: AxisDirection.right,
        duration: 1200,
        scrollDirection: Axis.horizontal,
        layout: SwiperLayout.TINDER,
        viewportFraction: 0.85,
        itemBuilder: (context, index) {
          return myBookings.isEmpty
              ? const NoBookingCard()
              : MyBookingCard(serviceBooking: myBookings[index]);
        },
      ),
    );
  }
}

class NoBookingCard extends StatelessWidget {
  const NoBookingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Container(
        height: 170,
        decoration: BoxDecoration(
          color: Colors.lightGreen.shade50,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 2),
              spreadRadius: 3,
              blurRadius: 3,
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/not_found/no_booking.json',
                height: 70, repeat: true),
            const SizedBox(height: 12),
            const Text(
              'No Current Bookings',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'You have no bookings at the moment. Book a service now.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyBookingCard extends StatelessWidget {
  final Map<String, dynamic> serviceBooking;

  const MyBookingCard({super.key, required this.serviceBooking});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Container(
        height: 170,
        width: screenWidth * 1.5,
        decoration: BoxDecoration(
          color: Colors.lightGreen.shade100,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 2),
              spreadRadius: 3,
              blurRadius: 3,
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Farmer: ${serviceBooking["farmerName"]}",
                style: const TextStyle(
                    fontSize: 18,
                    color: Colors.green,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5.0),
              Text("Animal Type: ${serviceBooking["animalType"]}",
                  style: const TextStyle(
                      fontSize: 16.0, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5.0),
              Text("Date: ${serviceBooking["date"]}",
                  style: const TextStyle(
                      fontSize: 16.0, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5.0),
              Text("Service: ${serviceBooking["service"]}",
                  style: const TextStyle(
                      fontSize: 16.0, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5.0),
              Text(
                "Issue Type: ${serviceBooking["issueType"] ?? "Not Known"}",
                style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
