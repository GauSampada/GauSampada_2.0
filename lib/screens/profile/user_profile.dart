import 'package:flutter/material.dart';
import 'package:gausampada/backend/auth/auth_methods.dart';
import 'package:gausampada/backend/providers/user_provider.dart';
import 'package:gausampada/const/colors.dart';
import 'package:gausampada/screens/settings/change_language.dart';
import 'package:gausampada/screens/widgets/dialogs/logout_dialog.dart';
import 'package:gausampada/screens/auth/login.dart';
import 'package:gausampada/screens/notifications/notification.dart';
import 'package:gausampada/screens/profile/edit_profile.dart';
import 'package:gausampada/screens/settings/settings.dart';
import 'package:gausampada/screens/support&help/help.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserProfileScreen extends StatelessWidget {
  final Function()? onTap;
  const UserProfileScreen({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, provider, _) {
      return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.profile),
          backgroundColor: themeColor,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                color: Colors.white.withOpacity(0.6),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        provider.user.photoURL == ''
                            ? CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.lightGreen,
                                child: Text(
                                  provider.user.name[0],
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            : CircleAvatar(
                                radius: 60,
                                backgroundImage:
                                    NetworkImage(provider.user.photoURL!),
                                backgroundColor: Colors.green,
                              ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const EditProfileScreen(
                                            // userProvider: provider,
                                            ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.edit),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      provider.user.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      provider.user.phonenumber,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  children: [
                    ProfileMenuItem(
                      icon: Icons.person,
                      text: AppLocalizations.of(context)!.editProfile,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EditProfileScreen(
                                // userProvider: provider,
                                ),
                          ),
                        );
                      },
                    ),
                    ProfileMenuItem(
                      icon: Icons.translate,
                      text: AppLocalizations.of(context)!.changeLanguage,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const LanguageSelectionScreen(),
                          ),
                        );
                      },
                    ),
                    ProfileMenuItem(
                      icon: Icons.notifications,
                      text: AppLocalizations.of(context)!.notifications,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NotificationScreen(),
                          ),
                        );
                      },
                    ),
                    ProfileMenuItem(
                      icon: Icons.settings,
                      text: AppLocalizations.of(context)!.settings,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingsScreen(),
                          ),
                        );
                      },
                    ),
                    ProfileMenuItem(
                      icon: Icons.help,
                      text: AppLocalizations.of(context)!.help,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SupportHelpScreen(),
                          ),
                        );
                      },
                    ),
                    // const SizedBox(height: 10),
                    ProfileMenuItem(
                      icon: Icons.logout,
                      text: AppLocalizations.of(context)!.logOut,
                      onTap: () {
                        const CustomDialog().showLogoutDialog(
                          context: context,
                          label: AppLocalizations.of(context)!.logOut,
                          message:
                              AppLocalizations.of(context)!.logoutConfirmation,
                          option2: AppLocalizations.of(context)!.cancel,
                          onPressed2: () {
                            Navigator.of(context).pop();
                          },
                          option1: AppLocalizations.of(context)!.yes,
                          onPressed1: () {
                            AuthService().logout();
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()));
                          },
                        );
                      },
                      textColor: Colors.red,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;
  final Color? textColor;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 6,
              spreadRadius: 2,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.green),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: textColor ?? Colors.black,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.green, size: 16),
          ],
        ),
      ),
    );
  }
}
