import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:gausampada/backend/auth/auth_methods.dart';
import 'package:gausampada/const/colors.dart';
import 'package:gausampada/const/toast.dart';
import 'package:gausampada/screens/auth/widgets/custom_auth_buttons.dart';
import 'package:gausampada/screens/auth/widgets/customtextformfield.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ForgotPassword extends StatefulWidget {
  final String? email;
  const ForgotPassword({super.key, this.email});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  late TextEditingController emailController;
  bool isLoading = false;
  @override
  void initState() {
    emailController = TextEditingController(text: widget.email);
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void resetPassword() async {
    if (emailController.text.isEmpty) {
      message(AppLocalizations.of(context)!.signupEmailRequired,
          navigate: false);
      return;
    }
    setState(() {
      isLoading = true;
    });

    String res = await AuthService().resetPassword(emailController.text.trim());
    message(res);

    setState(() {
      isLoading = false;
    });
  }

  void message(String res, {bool navigate = true}) {
    toastMessage(
        context: context, message: res, position: DelightSnackbarPosition.top);
    if (navigate) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 40,
                ),
                Image.asset(
                  'assets/auth/forgot_password.jpg',
                  height: 270,
                  width: 370,
                ),
                const SizedBox(
                  height: 40,
                ),
                Text(
                  textAlign: TextAlign.center,
                  AppLocalizations.of(context)!.receiveEmailToResetPassword,
                  maxLines: 2,
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: themeColor),
                ),
                const SizedBox(
                  height: 40,
                ),
                CustomTextFormField(
                  controller: emailController,
                  label: AppLocalizations.of(context)!.signupEmailLabel,
                  hinttext: AppLocalizations.of(context)!.signupEmailHint,
                  prefixicon: Icons.email,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.signupEmailRequired;
                    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                        .hasMatch(value)) {
                      return AppLocalizations.of(context)!.signupEmailInvalid;
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                LoginSignupButtons(
                  onTap: () => resetPassword(),
                  label: AppLocalizations.of(context)!.resetPassword,
                  backgroundColor: Colors.blue,
                  isLoading: isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
