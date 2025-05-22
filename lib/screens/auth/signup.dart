import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gausampada/backend/enums/user_type.dart';
import 'package:gausampada/const/colors.dart';
import 'package:gausampada/const/toast.dart';
import 'package:gausampada/screens/auth/login.dart';
import 'package:gausampada/screens/auth/widgets/custom_auth_buttons.dart';
import 'package:gausampada/screens/auth/widgets/customtextformfield.dart';
import 'package:gausampada/backend/auth/auth_methods.dart';
import 'package:gausampada/screens/home/home_screen.dart';

class SignupScreen extends StatefulWidget {
  final UserType? userType;
  const SignupScreen({super.key, required this.userType});

  @override
  State<SignupScreen> createState() => SignupScreenState();
}

class SignupScreenState extends State<SignupScreen> {
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController phonenum = TextEditingController();

  final formKey = GlobalKey<FormState>();
  final AuthService authService = AuthService();

  bool obscureText = true;
  bool isLoading = false;
  bool isgoogleLoading = false;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    phonenum.dispose();
    name.dispose();
    super.dispose();
  }

  void signUpEmail() async {
    if (!formKey.currentState!.validate()) {
      toastMessage(
          context: context,
          message: AppLocalizations.of(context)!.signupFillAllFields,
          leadingIcon: const Icon(Icons.message),
          toastColor: Colors.yellow[300],
          borderColor: Colors.orange,
          position: DelightSnackbarPosition.top);
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      String res = await authService.handleSignUpWithEmail(
        email: email.text.trim(),
        password: password.text.trim(),
        name: name.text.trim(),
        phoneNumber: phonenum.text.trim(),
        userType: widget.userType ?? UserType.user,
      );

      if (res == "success") {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) => const HomeScreen(
                    isLoginOrSignUp: true,
                  )),
        );
      } else {
        toastMessage(
            context: context,
            message: res,
            leadingIcon: const Icon(Icons.message),
            toastColor: Colors.yellow[300],
            borderColor: Colors.orange,
            position: DelightSnackbarPosition.top);
      }
    } catch (e) {
      toastMessage(
          context: context,
          message: e.toString(),
          leadingIcon: const Icon(Icons.error),
          toastColor: Colors.red[200],
          borderColor: Colors.red,
          position: DelightSnackbarPosition.top);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> signUpWithGoogle() async {
    setState(() {
      isgoogleLoading = true;
    });
    try {
      String res = await authService.handleSignUpWithGoogle();

      if (res == "success") {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        toastMessage(
            context: context,
            message: res,
            leadingIcon: const Icon(Icons.error),
            toastColor: Colors.red[200],
            borderColor: Colors.red,
            position: DelightSnackbarPosition.top);
      }
    } catch (e) {
      toastMessage(
          context: context,
          message: e.toString(),
          leadingIcon: const Icon(Icons.error),
          toastColor: Colors.red[200],
          borderColor: Colors.red,
          position: DelightSnackbarPosition.top);
    } finally {
      setState(() {
        isgoogleLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 13.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: screenHeight * 0.03,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.onboard[0],
                              style: const TextStyle(
                                fontSize: 60.0,
                              ),
                            ),
                            Transform.translate(
                              offset: const Offset(0, -4),
                              child: Text(
                                AppLocalizations.of(context)!
                                    .onboard
                                    .substring(1),
                                style: const TextStyle(
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        Transform.translate(
                          offset: const Offset(0, -22),
                          child: Text(
                            AppLocalizations.of(context)!.signupScreenSubtitle,
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: themeColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Image.asset(
                    "assets/auth/signup.jpg",
                    width: screenWidth * 0.65,
                    height: screenHeight * .25,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextFormField(
                    label: AppLocalizations.of(context)!.signupNameLabel,
                    hinttext: AppLocalizations.of(context)!.signupNameHint,
                    controller: name,
                    prefixicon: Icons.person_2,
                    validator: (value) => value == null || value.isEmpty
                        ? AppLocalizations.of(context)!.signupNameRequired
                        : null,
                  ),
                  CustomTextFormField(
                    label: AppLocalizations.of(context)!.signupEmailLabel,
                    hinttext: AppLocalizations.of(context)!.signupEmailHint,
                    controller: email,
                    prefixicon: Icons.email_rounded,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!
                            .signupEmailRequired;
                      } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                          .hasMatch(value)) {
                        return AppLocalizations.of(context)!.signupEmailInvalid;
                      }
                      return null;
                    },
                  ),
                  CustomTextFormField(
                    label: AppLocalizations.of(context)!.signupPasswordLabel,
                    hinttext: AppLocalizations.of(context)!.signupPasswordHint,
                    controller: password,
                    prefixicon: Icons.lock,
                    isobsure: obscureText,
                    suffixicon: IconButton(
                      onPressed: () {
                        setState(() {
                          obscureText = !obscureText;
                        });
                      },
                      icon: Icon(obscureText
                          ? Icons.visibility
                          : Icons.visibility_off),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!
                            .signupPasswordRequired;
                      }
                      return null;
                    },
                  ),
                  CustomTextFormField(
                    label: AppLocalizations.of(context)!.signupPhoneLabel,
                    hinttext: AppLocalizations.of(context)!.signupPhoneHint,
                    controller: phonenum,
                    prefixicon: Icons.phone,
                    keyboard: TextInputType.phone,
                    validator: (value) =>
                        value == null || value.isEmpty || value.length < 10
                            ? AppLocalizations.of(context)!.signupPhoneRequired
                            : null,
                  ),
                  SizedBox(
                    height: screenHeight * .01,
                  ),
                  LoginSignupButtons(
                    label: AppLocalizations.of(context)!.signupButton,
                    onTap: signUpEmail,
                    isLoading: isLoading,
                    backgroundColor: Colors.green[500],
                  ),
                  SizedBox(
                    height: screenHeight * .015,
                  ),
                  const Text(
                    "Or",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: screenHeight * .015,
                  ),
                  LoginSignupButtons(
                    imagepath: "assets/auth/google.jpg",
                    label: AppLocalizations.of(context)!.signupGoogleButton,
                    onTap: signUpWithGoogle,
                    isLoading: isgoogleLoading,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                    },
                    child: Text(
                      AppLocalizations.of(context)!.signupAlreadyHaveAccount,
                      style: const TextStyle(color: Colors.red, fontSize: 15),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * .05,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
