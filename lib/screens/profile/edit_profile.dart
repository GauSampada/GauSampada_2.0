import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gausampada/backend/enums/user_type.dart';
import 'package:gausampada/backend/providers/user_provider.dart';
import 'package:gausampada/const/colors.dart';
import 'package:gausampada/screens/widgets/dialogs/profile_imagepicker_dialog.dart';
import 'package:gausampada/const/toast.dart';
import 'package:gausampada/screens/auth/widgets/customtextformfield.dart';
import 'package:gausampada/screens/widgets/buttons/elevated.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController specializationController =
      TextEditingController();
  final TextEditingController yearsOfExperienceController =
      TextEditingController();
  final TextEditingController qualificationController = TextEditingController();
  final TextEditingController consultationFeeController =
      TextEditingController();
  List<String> availability = [];
  final formKey = GlobalKey<FormState>();

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
  void initState() {
    super.initState();
    // Initialize controllers with user data
    final provider = Provider.of<UserProvider>(context, listen: false);
    nameController.text = provider.user.name;
    emailController.text = provider.user.email;
    phoneNumberController.text = provider.user.phonenumber;
    locationController.text = provider.user.location ?? '';
    if (provider.user.userType == UserType.doctor &&
        provider.user.doctorDetails != null) {
      specializationController.text =
          provider.user.doctorDetails!['specialization']?.toString() ?? '';
      yearsOfExperienceController.text =
          provider.user.doctorDetails!['yearsOfExperience']?.toString() ?? '';
      qualificationController.text =
          provider.user.doctorDetails!['qualification']?.toString() ?? '';
      consultationFeeController.text =
          provider.user.doctorDetails!['consultationFee']?.toString() ?? '';
      availability =
          List<String>.from(provider.user.doctorDetails!['availability'] ?? []);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    locationController.dispose();
    specializationController.dispose();
    yearsOfExperienceController.dispose();
    qualificationController.dispose();
    consultationFeeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, provider, child) {
        return provider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : Scaffold(
                appBar: AppBar(
                  backgroundColor: themeColor,
                  title: Text(
                    AppLocalizations.of(context)!.editProfile,
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          Stack(
                            children: [
                              provider.isLoading
                                  ? const CircularProgressIndicator(
                                      color: themeColor)
                                  : provider.photoURL == ""
                                      ? CircleAvatar(
                                          radius: 60,
                                          backgroundColor: Colors.lightGreen,
                                          child: Text(
                                            provider.user.name[0],
                                            style: const TextStyle(
                                                fontSize: 40,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      : CircleAvatar(
                                          radius: 60,
                                          backgroundImage:
                                              NetworkImage(provider.photoURL!),
                                        ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: IconButton(
                                    onPressed: () {
                                      ImagepickerDialog()
                                          .showImagePicker(context);
                                    },
                                    icon: const Icon(Icons.edit),
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 20),
                          CustomTextFormField(
                            controller: nameController,
                            label:
                                AppLocalizations.of(context)!.signupNameLabel,
                            hinttext: provider.user.name,
                            prefixicon: Icons.person,
                            validator: (value) => value == null || value.isEmpty
                                ? AppLocalizations.of(context)!
                                    .signupNameRequired
                                : null,
                          ),
                          const SizedBox(height: 20),
                          CustomTextFormField(
                            controller: emailController,
                            label:
                                AppLocalizations.of(context)!.signupEmailLabel,
                            hinttext: provider.user.email,
                            prefixicon: Icons.email,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppLocalizations.of(context)!
                                    .signupEmailRequired;
                              } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                  .hasMatch(value)) {
                                return AppLocalizations.of(context)!
                                    .signupEmailInvalid;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          CustomTextFormField(
                            controller: phoneNumberController,
                            label:
                                AppLocalizations.of(context)!.signupPhoneLabel,
                            hinttext: provider.user.phonenumber,
                            prefixicon: Icons.phone,
                            keyboard: TextInputType.phone,
                            validator: (value) => value == null ||
                                    value.isEmpty ||
                                    value.length < 10
                                ? AppLocalizations.of(context)!
                                    .signupPhoneRequired
                                : null,
                          ),
                          const SizedBox(height: 20),
                          CustomTextFormField(
                            controller: locationController,
                            label: AppLocalizations.of(context)!.location,
                            hinttext:
                                provider.user.location ?? 'Enter location',
                            prefixicon: Icons.location_on,
                          ),
                          if (provider.user.userType == UserType.doctor) ...[
                            const SizedBox(height: 20),
                            CustomTextFormField(
                              controller: specializationController,
                              label: AppLocalizations.of(context)!
                                  .doctorSpecializationLabel,
                              hinttext: 'e.g., Veterinary Medicine',
                              prefixicon: Icons.medical_services,
                              validator: (value) =>
                                  value == null || value.isEmpty
                                      ? AppLocalizations.of(context)!
                                          .signupFieldRequired
                                      : null,
                            ),
                            const SizedBox(height: 20),
                            CustomTextFormField(
                              controller: yearsOfExperienceController,
                              label: AppLocalizations.of(context)!
                                  .doctorExperienceLabel,
                              hinttext: 'e.g., 5',
                              prefixicon: Icons.work_history,
                              keyboard: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppLocalizations.of(context)!
                                      .signupFieldRequired;
                                }
                                if (int.tryParse(value) == null ||
                                    int.parse(value) < 0) {
                                  return 'Please enter a valid number';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            CustomTextFormField(
                              controller: qualificationController,
                              label: AppLocalizations.of(context)!
                                  .doctorQualificationLabel,
                              hinttext: 'e.g., MVSc',
                              prefixicon: Icons.school,
                              validator: (value) =>
                                  value == null || value.isEmpty
                                      ? AppLocalizations.of(context)!
                                          .signupFieldRequired
                                      : null,
                            ),
                            const SizedBox(height: 20),
                            CustomTextFormField(
                              controller: consultationFeeController,
                              label: AppLocalizations.of(context)!
                                  .doctorConsultationFeeLabel,
                              hinttext: 'e.g., 500',
                              prefixicon: Icons.attach_money,
                              keyboard: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppLocalizations.of(context)!
                                      .signupFieldRequired;
                                }
                                if (int.tryParse(value) == null ||
                                    int.parse(value) <= 0) {
                                  return 'Please enter a valid fee';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                AppLocalizations.of(context)!
                                    .doctorAvailabilityLabel,
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
                          ],
                          const SizedBox(height: 20),
                          SizedBox(
                            width: 180,
                            child: provider.isUpdate
                                ? const Center(
                                    child: CupertinoActivityIndicator())
                                : CustomElevatedButton(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.blue,
                                    text: AppLocalizations.of(context)!
                                        .saveButton,
                                    onPressed: () async {
                                      if (!formKey.currentState!.validate()) {
                                        toastMessage(
                                          context: context,
                                          message: AppLocalizations.of(context)!
                                              .signupFillAllFields,
                                          position: DelightSnackbarPosition.top,
                                          toastColor: Colors.yellow[300],
                                          borderColor: Colors.orange,
                                        );
                                        return;
                                      }
                                      if (provider.user.userType ==
                                              UserType.doctor &&
                                          availability.isEmpty) {
                                        toastMessage(
                                          context: context,
                                          message:
                                              'Please select at least one availability day',
                                          position: DelightSnackbarPosition.top,
                                          toastColor: Colors.red[200],
                                          borderColor: Colors.red,
                                        );
                                        return;
                                      }

                                      String res =
                                          await provider.updateUserDetails(
                                        userType: provider.user.userType,
                                        name: nameController.text,
                                        email: emailController.text,
                                        phonenumber: phoneNumberController.text,
                                        location: locationController.text,
                                        doctorDetails: provider.user.userType ==
                                                UserType.doctor
                                            ? {
                                                'specialization':
                                                    specializationController
                                                        .text,
                                                'yearsOfExperience': int.parse(
                                                    yearsOfExperienceController
                                                        .text),
                                                'availability': availability,
                                                'qualification':
                                                    qualificationController
                                                        .text,
                                                'consultationFee': int.parse(
                                                    consultationFeeController
                                                        .text),
                                              }
                                            : null,
                                      );

                                      if (res == 'update') {
                                        toastMessage(
                                          context: context,
                                          message: AppLocalizations.of(context)!
                                              .profileUpdatedSuccess,
                                          position: DelightSnackbarPosition.top,
                                        );
                                      } else {
                                        toastMessage(
                                          context: context,
                                          message: AppLocalizations.of(context)!
                                              .profileUpdateFailed,
                                          position: DelightSnackbarPosition.top,
                                          toastColor: Colors.red[200],
                                          borderColor: Colors.red,
                                        );
                                      }
                                    },
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
      },
    );
  }
}
