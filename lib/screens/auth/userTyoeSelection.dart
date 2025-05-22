import 'package:flutter/material.dart';
import 'package:gausampada/backend/enums/user_type.dart';
import 'package:gausampada/screens/auth/signup.dart';
import 'package:google_fonts/google_fonts.dart';

class UserTypeSelectionScreen extends StatefulWidget {
  const UserTypeSelectionScreen({super.key});

  @override
  _UserTypeSelectionScreenState createState() =>
      _UserTypeSelectionScreenState();
}

class _UserTypeSelectionScreenState extends State<UserTypeSelectionScreen> {
  UserType? selectedUserType;

  // Green color for selected state
  final Color selectGreen = const Color(0xFF2E7D32);

  // User type data
  final List<Map<String, dynamic>> userTypes = [
    {
      'type': UserType.user,
      'title': 'Regular User',
      'subtitle': 'Access general features and services',
      'image_path': "assets/icon/user.png",
    },
    {
      'type': UserType.doctor,
      'title': 'Doctor',
      'subtitle': 'Provide medical services and consultation',
      'image_path': "assets/icon/doctor.png",
    },
    {
      'type': UserType.farmer,
      'title': 'Farmer',
      'subtitle': 'Access agricultural tools and resources',
      'image_path': "assets/icon/farmer.png",
    },
  ];

  void _navigateToSignup() {
    if (selectedUserType != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SignupScreen(userType: selectedUserType!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          '',
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Who are you?',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Select your user type to continue',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Expanded(
              child: ListView.builder(
                itemCount: userTypes.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final userTypeData = userTypes[index];
                  final isSelected = selectedUserType == userTypeData['type'];

                  return UserTypeOption(
                    title: userTypeData['title'],
                    subtitle: userTypeData['subtitle'],
                    image_path: userTypeData['image_path'],
                    isSelected: isSelected,
                    selectColor: selectGreen,
                    onTap: () {
                      setState(() {
                        selectedUserType = userTypeData['type'];
                      });
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: selectedUserType != null ? _navigateToSignup : null,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    selectedUserType != null ? selectGreen : Colors.grey[300],
                foregroundColor: Colors.white,
                elevation: selectedUserType != null ? 2 : 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: Text(
                'Continue to Signup',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserTypeOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final String image_path;
  final bool isSelected;
  final VoidCallback onTap;
  final Color selectColor;

  const UserTypeOption({
    super.key,
    required this.title,
    required this.subtitle,
    required this.image_path,
    required this.isSelected,
    required this.onTap,
    required this.selectColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                color: isSelected ? selectColor.withOpacity(0.1) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color:
                      isSelected ? selectColor : Colors.grey.withOpacity(0.3),
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isSelected
                        ? selectColor.withOpacity(0.2)
                        : Colors.grey.withOpacity(0.1),
                    blurRadius: 8,
                    spreadRadius: 1,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Container(
                        width: 65,
                        height: 65,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? selectColor.withOpacity(0.1)
                              : Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color:
                                isSelected ? selectColor : Colors.grey.shade300,
                            width: isSelected ? 2 : 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isSelected
                                  ? selectColor.withOpacity(0.2)
                                  : Colors.grey.withOpacity(0.1),
                              blurRadius: 6,
                              spreadRadius: 1,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: CircleAvatar(
                            backgroundImage: AssetImage(image_path),
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color:
                                    isSelected ? selectColor : Colors.black87,
                                letterSpacing: 0.2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              subtitle,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: isSelected
                                    ? selectColor.withOpacity(0.7)
                                    : Colors.black54,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: isSelected ? 32 : 24,
                        height: isSelected ? 32 : 24,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? selectColor.withOpacity(0.15)
                              : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            isSelected
                                ? Icons.check_circle
                                : Icons.circle_outlined,
                            color:
                                isSelected ? selectColor : Colors.grey.shade400,
                            size: isSelected ? 28 : 24,
                          ),
                        ),
                      ),
                    ],
                  ))),
        ),
      ),
    );
  }
}
