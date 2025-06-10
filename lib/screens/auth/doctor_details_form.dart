import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:gausampada/backend/models/user_model.dart';
import 'package:gausampada/const/colors.dart';
import 'package:gausampada/const/toast.dart';
import 'package:gausampada/screens/auth/widgets/customtextformfield.dart';
import 'package:gausampada/screens/home/home_screen.dart';
import 'package:gausampada/screens/widgets/buttons/elevated.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DoctorDetailsFormScreen extends StatefulWidget {
  final UserModel user;
  const DoctorDetailsFormScreen({super.key, required this.user});

  @override
  State<DoctorDetailsFormScreen> createState() =>
      _DoctorDetailsFormScreenState();
}

class _DoctorDetailsFormScreenState extends State<DoctorDetailsFormScreen> {
  final TextEditingController specializationController =
      TextEditingController();
  final TextEditingController yearsOfExperienceController =
      TextEditingController();
  final TextEditingController qualificationController = TextEditingController();
  final TextEditingController consultationFeeController =
      TextEditingController();
  List<String> availability = [];
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  final List<String> days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  @override
  void dispose() {
    specializationController.dispose();
    yearsOfExperienceController.dispose();
    qualificationController.dispose();
    consultationFeeController.dispose();
    super.dispose();
  }

  Future<void> saveDoctorDetails() async {
    if (!formKey.currentState!.validate() || availability.isEmpty) {
      toastMessage(
        context: context,
        message: availability.isEmpty
            ? 'Please select at least one availability day'
            : AppLocalizations.of(context)!.signupFillAllFields,
        leadingIcon: const Icon(Icons.error),
        toastColor: Colors.red[200],
        borderColor: Colors.red,
        position: DelightSnackbarPosition.top,
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final doctorDetails = {
        'specialization': specializationController.text.trim(),
        'yearsOfExperience': int.parse(yearsOfExperienceController.text.trim()),
        'availability': availability,
        'qualification': qualificationController.text.trim(),
        'consultationFee': int.parse(consultationFeeController.text.trim()),
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user.uid)
          .update({'doctorDetails': doctorDetails});

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(isLoginOrSignUp: true),
        ),
      );
    } catch (e) {
      toastMessage(
        context: context,
        message: 'Error saving doctor details: $e',
        leadingIcon: const Icon(Icons.error),
        toastColor: Colors.red[200],
        borderColor: Colors.red,
        position: DelightSnackbarPosition.top,
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.doctorDetailsTitle),
        backgroundColor: themeColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                CustomTextFormField(
                  controller: specializationController,
                  label:
                      AppLocalizations.of(context)!.doctorSpecializationLabel,
                  hinttext: 'e.g., Veterinary Medicine',
                  prefixicon: Icons.medical_services,
                  validator: (value) => value == null || value.isEmpty
                      ? AppLocalizations.of(context)!.signupFieldRequired
                      : null,
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  controller: yearsOfExperienceController,
                  label: AppLocalizations.of(context)!.doctorExperienceLabel,
                  hinttext: 'e.g., 5',
                  prefixicon: Icons.work_history,
                  keyboard: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.signupFieldRequired;
                    }
                    if (int.tryParse(value) == null || int.parse(value) < 0) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  controller: qualificationController,
                  label: AppLocalizations.of(context)!.doctorQualificationLabel,
                  hinttext: 'e.g., MVSc',
                  prefixicon: Icons.school,
                  validator: (value) => value == null || value.isEmpty
                      ? AppLocalizations.of(context)!.signupFieldRequired
                      : null,
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  controller: consultationFeeController,
                  label:
                      AppLocalizations.of(context)!.doctorConsultationFeeLabel,
                  hinttext: 'e.g., 500',
                  prefixicon: Icons.attach_money,
                  keyboard: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.signupFieldRequired;
                    }
                    if (int.tryParse(value) == null || int.parse(value) <= 0) {
                      return 'Please enter a valid fee';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppLocalizations.of(context)!.doctorAvailabilityLabel,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: days.map((day) {
                    final isSelected = availability.contains(day);
                    return ChoiceChip(
                      label: Text(day),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            availability.add(day);
                          } else {
                            availability.remove(day);
                          }
                        });
                      },
                      selectedColor: Colors.green[300],
                      backgroundColor: Colors.grey[200],
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                CustomElevatedButton(
                  text: AppLocalizations.of(context)!.saveButton,
                  backgroundColor: Colors.green[500],
                  foregroundColor: Colors.white,
                  onPressed: saveDoctorDetails,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
