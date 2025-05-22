import 'package:flutter/material.dart';
import 'package:gausampada/backend/auth/auth_methods.dart';
import 'package:gausampada/backend/providers/user_provider.dart';
import 'package:gausampada/const/colors.dart';
import 'package:gausampada/screens/auth/login.dart';
import 'package:gausampada/screens/breed/breed_info_screen.dart';
import 'package:gausampada/screens/breed/widgets/ai_breed_chat.dart';
import 'package:gausampada/screens/chat_bot/ai_assistance.dart';
import 'package:gausampada/screens/feed/widgets/bookings_swiper.dart';
import 'package:gausampada/screens/feed/widgets/breed_info_card.dart';
import 'package:gausampada/screens/feed/widgets/custom_headings.dart';
import 'package:gausampada/screens/feed/widgets/info_main.dart';
import 'package:gausampada/screens/feed/widgets/products.dart';
import 'package:gausampada/screens/home/home_screen.dart';
import 'package:gausampada/screens/home/widgets/nav_bar_items.dart';
import 'package:gausampada/screens/maps/maps.dart';
import 'package:gausampada/screens/market/market_screen.dart';
import 'package:gausampada/screens/notifications/notification.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gausampada/screens/profile/user_profile.dart';
import 'package:gausampada/screens/settings/settings.dart';
import 'package:gausampada/screens/widgets/dialogs/logout_dialog.dart';
import 'package:provider/provider.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      extendBody: true,
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Theme.of(context).primaryColor,
      //   elevation: 6,
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(30),
      //   ),
      //   child: const Icon(
      //     Icons.chat_bubble_rounded,
      //     color: Colors.white,
      //   ),
      //   onPressed: () {
      //     Navigator.of(context).push(
      //       MaterialPageRoute(
      //         builder: (context) => const ChatScreen(),
      //       ),
      //     );
      //   },
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => const AiBreedChat()));
        },
        backgroundColor: Colors.white,
        tooltip: "AI Breed Info",
        child: const Icon(
          Icons.chat,
          color: Colors.green,
        ),
      ),
      drawer: customNavigationBar(provider: Provider.of<UserProvider>(context)),
      appBar: AppBar(
        backgroundColor: themeColor,
        toolbarHeight: 70,
        title: Text(
          AppLocalizations.of(context)!.gauSampada,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.location_on,
              color: Colors.white,
            ),
            tooltip: 'Location',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const MapScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.chat,
              color: Colors.white,
            ),
            tooltip: 'Notifications',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const NotificationScreen(),
                ),
              );
            },
          ),
          const SizedBox(width: 15),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Hero section with gradient overlay
            const SizedBox(
              height: 8,
            ),
            SizedBox(
                height: screenHeight * 0.24,
                width: screenWidth,
                child: const InfoMainScreen()),
            const SizedBox(
              height: 10,
            ),

            // Breed Information Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  CustomHeadingsScreen(
                    label: AppLocalizations.of(context)!.breedInformation,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const BreadInfoScreen(),
                        ),
                      );
                    },
                    icon: Icons.pets_rounded,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const BreedInfoCardScreen(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Products Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  CustomHeadingsScreen(
                    label: AppLocalizations.of(context)!.dairyProducts,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const MarketAccessScreen(),
                        ),
                      );
                    },
                    icon: Icons.shopping_basket_rounded,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const DairyProductsCardScreen(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),
            // My Orders Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  CustomHeadingsScreen(
                    label: AppLocalizations.of(context)!.dairyProducts,
                    onPressed: () {},
                    icon: Icons.shopping_bag_rounded,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const SwiperBuilder(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Drawer customNavigationBar({required UserProvider provider}) {
    return Drawer(
      backgroundColor: backgroundColor,
      child: SingleChildScrollView(
        child: Column(
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const UserProfileScreen()));
              },
              child: UserAccountsDrawerHeader(
                decoration: const BoxDecoration(color: themeColor),
                accountName: Text(
                  AppLocalizations.of(context)!.userName(provider.user.name),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                accountEmail: Text(
                  provider.user.email,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
                currentAccountPicture: provider.user.photoURL != ''
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(provider.user.photoURL!),
                      )
                    : CircleAvatar(
                        child: Text(
                          provider.user.name[0],
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 10),
            Navbaritems(
              icon: Icons.home,
              label: AppLocalizations.of(context)!.home,
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const HomeScreen()));
              },
            ),
            Navbaritems(
              icon: Icons.notifications,
              label: AppLocalizations.of(context)!.notifications,
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const NotificationScreen()));
              },
            ),
            Navbaritems(
              icon: Icons.settings,
              label: AppLocalizations.of(context)!.settings,
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const SettingsScreen()));
              },
            ),
            Navbaritems(
              icon: Icons.logout,
              label: AppLocalizations.of(context)!.signOut,
              onTap: () {
                const CustomDialog().showLogoutDialog(
                  context: context,
                  label: AppLocalizations.of(context)!.logOut,
                  message: AppLocalizations.of(context)!.confirmLogout,
                  option2: AppLocalizations.of(context)!.cancel,
                  onPressed2: () {
                    Navigator.of(context).pop();
                  },
                  option1: AppLocalizations.of(context)!.yes,
                  onPressed1: () {
                    AuthService().logout();
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
                  },
                );
              },
              labelColor: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
