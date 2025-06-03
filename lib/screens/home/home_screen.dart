import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:gausampada/backend/enums/user_type.dart';
import 'package:gausampada/backend/providers/user_provider.dart';
import 'package:gausampada/const/colors.dart';
import 'package:gausampada/screens/breed/breed_info_screen.dart';
import 'package:gausampada/const/toast.dart';
import 'package:gausampada/screens/DiseasePrediction/disease_prediction.dart';
import 'package:gausampada/screens/communication/connect.dart';
import 'package:gausampada/screens/feed/feed_screen.dart';
import 'package:gausampada/screens/market/market_screen.dart';
import 'package:gausampada/screens/profile/user_profile.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  final bool isLoginOrSignUp;
  const HomeScreen({super.key, this.isLoginOrSignUp = false});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  UserProvider? userProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    userProvider ??= Provider.of<UserProvider>(context, listen: false);

    if (widget.isLoginOrSignUp) {
      toastMessage(
        context: context,
        message: AppLocalizations.of(context)!.welcomeBack,
        leadingIcon: const Icon(Icons.emoji_emotions),
        position: DelightSnackbarPosition.top,
      );
    }

    fetchData();
  }

  void fetchData() async {
    await userProvider?.fetchUser();
    setState(() {});
  }

  List<Widget> getScreensList(UserProvider userProvider) {
    return [
      const FeedScreen(),
      const MarketAccessScreen(),
      DiseasePredictionScreen(),
      const BreadInfoScreen(),
      (userProvider.user.userType == UserType.doctor ||
              userProvider.user.userType == UserType.farmer)
          ? const AppointmentScreen()
          : const UserProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, userProvider, _) {
      if (userProvider.isLoading) {
        return const Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: CircularProgressIndicator(
              color: themeColor,
            ),
          ),
        );
      }

      final screens = getScreensList(userProvider);

      return Scaffold(
        key: _scaffoldKey,
        body: screens[currentIndex],
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(0, Icons.home, AppLocalizations.of(context)!.home),
              _buildNavItem(
                  1, Icons.shopping_bag, AppLocalizations.of(context)!.market),
              _buildNavItem(2, Icons.smart_toy_outlined,
                  AppLocalizations.of(context)!.aiDiagnosis),
              _buildNavItem(
                  3, Icons.pets, AppLocalizations.of(context)!.breedInfo),
              _buildNavItem(
                4,
                Icons.person_pin,
                (userProvider.user.userType == UserType.doctor ||
                        userProvider.user.userType == UserType.farmer)
                    ? AppLocalizations.of(context)!.farmVet
                    : AppLocalizations.of(context)!.profile,
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    bool isSelected = currentIndex == index;
    return InkWell(
      onTap: () {
        setState(() {
          currentIndex = index;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFF0A7643) : Colors.grey,
              size: 30,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                fontSize: isSelected ? 12 : 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? themeColor : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
