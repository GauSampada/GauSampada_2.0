import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:gausampada/backend/auth/auth_methods.dart';
import 'package:gausampada/const/colors.dart';
import 'package:gausampada/const/toast.dart';
import 'package:gausampada/screens/auth/forgot_password.dart';
import 'package:gausampada/screens/auth/signup.dart';
import 'package:gausampada/screens/auth/userTyoeSelection.dart';
import 'package:gausampada/screens/auth/widgets/custom_auth_buttons.dart';
import 'package:gausampada/screens/auth/widgets/customtextformfield.dart';
import 'package:gausampada/screens/home/home_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool obscureText = true;
  Widget hashing = const Icon(Icons.visibility);
  bool isLoading = false;
  bool isgoogleLoading = false;
  final formKey = GlobalKey<FormState>();
  final AuthService authService = AuthService();

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  void loginWithEmail() async {
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
    String res = await authService.handleLoginWithEmail(
        email: email.text, password: password.text);
    if (res == "success") {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const HomeScreen(
                isLoginOrSignUp: true,
              )));
    } else {
      toastMessage(
          context: context,
          message: AppLocalizations.of(context)!.invalidEmailOrPassword,
          leadingIcon: const Icon(Icons.error),
          toastColor: Colors.red[200],
          borderColor: Colors.red,
          position: DelightSnackbarPosition.top);
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> loginWithGoogle() async {
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
    setState(() {
      isgoogleLoading = false;
    });
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
                  SizedBox(height: screenHeight * 0.03),
                  Padding(
                    padding: const EdgeInsets.only(left: 13),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              AppLocalizations.of(context)!
                                  .signupScreenTitle[0],
                              style: const TextStyle(
                                  fontSize: 50.0, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              AppLocalizations.of(context)!
                                  .signupScreenTitle
                                  .substring(1),
                              style: const TextStyle(
                                  fontSize: 30.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Transform.translate(
                          offset: const Offset(0, -14),
                          child: Text(
                            AppLocalizations.of(context)!.accessYourAccount,
                            style: const TextStyle(
                              fontSize: 16.5,
                              fontWeight: FontWeight.bold,
                              color: themeColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Image.asset(
                    "assets/auth/login.jpg",
                    width: screenWidth * 0.7,
                    height: screenHeight * 0.25,
                  ),

                  SizedBox(height: screenHeight * 0.02),

                  CustomTextFormField(
                    label: AppLocalizations.of(context)!.signupEmailLabel,
                    hinttext: AppLocalizations.of(context)!.signupEmailHint,
                    controller: email,
                    prefixicon: Icons.email_rounded,
                    keyboard: TextInputType.emailAddress,
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

                  SizedBox(height: screenHeight * 0.01),
                  LoginSignupButtons(
                    label: AppLocalizations.of(context)!.login,
                    onTap: loginWithEmail,
                    isLoading: isLoading,
                    backgroundColor: Colors.green[500],
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                        onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const ForgotPassword())),
                        child: Text(
                          AppLocalizations.of(context)!.forgotPassword,
                          style:
                              const TextStyle(color: Colors.red, fontSize: 15),
                        )),
                  ),

                  Text(
                    AppLocalizations.of(context)!.or,
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: screenHeight * 0.01),
                  LoginSignupButtons(
                    imagepath: "assets/auth/google.jpg",
                    label: AppLocalizations.of(context)!.loginWithGoogle,
                    onTap: loginWithGoogle,
                  ),

                  // SizedBox(height: screenHeight*0.02,),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                const UserTypeSelectionScreen()));
                      },
                      child: Text(
                        AppLocalizations.of(context)!.dontHaveAccount,
                        style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
