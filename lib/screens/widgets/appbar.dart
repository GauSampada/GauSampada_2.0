import 'package:flutter/material.dart';

import 'package:gausampada/backend/providers/user_provider.dart';
import 'package:gausampada/const/colors.dart';
import 'package:provider/provider.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String label;
  final TextStyle? style;

  const CustomAppbar({
    super.key,
    required this.label,
    this.style,
  });

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, provider, _) {
        return AppBar(
          backgroundColor: themeColor,
          toolbarHeight: 70,
          // leading: Builder(
          //   builder: (context) => IconButton(
          //     icon: const Icon(Icons.menu),
          //     tooltip: 'Open Menu',
          //     onPressed: () {
          //       Scaffold.of(context).openDrawer();
          //     },
          //   ),
          // ),
          title: Text(
            label,
            style: style ??
                const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
          ),
          // actions: [
          // IconButton(
          //   icon: const Icon(Icons.help_outline_sharp),
          //   tooltip: 'Help',
          //   onPressed: () {
          //     Navigator.of(context).push(
          //       MaterialPageRoute(
          //         builder: (context) => const SupportHelpScreen(),
          //       ),
          //     );
          //   },
          // ),
          // IconButton(
          //   icon: const Icon(
          //     Icons.location_on,
          //     color: Colors.white,
          //   ),
          //   tooltip: 'Location',
          //   onPressed: () {
          //     Navigator.of(context).push(
          //       MaterialPageRoute(
          //         builder: (context) => const MapScreen(),
          //       ),
          //     );
          //   },
          // ),
          // IconButton(
          //   icon: const Icon(
          //     Icons.notifications,
          //     color: Colors.white,
          //   ),
          //   tooltip: 'Notifications',
          //   onPressed: () {
          //     Navigator.of(context).push(
          //       MaterialPageRoute(
          //         builder: (context) => const NotificationScreen(),
          //       ),
          //     );
          //   },
          // ),
          // IconButton(
          //   icon: provider.user.photoURL != ''
          //       ? CircleAvatar(
          //           backgroundImage: NetworkImage(provider.user.photoURL!),
          //         )
          //       : CircleAvatar(
          //           radius: 15,
          //           backgroundColor: Colors.white,
          //           child: Text(
          //             provider.user.name[0].toUpperCase(),
          //             style: const TextStyle(
          //                 color: themeColor, fontWeight: FontWeight.bold),
          //           ),
          //         ),
          //   onPressed: () {
          //     Navigator.of(context).push(
          //       MaterialPageRoute(
          //           builder: (context) => const UserProfileScreen()),
          //     );
          //   },
          // ),
          // const SizedBox(width: 15),
          // ],
        );
      },
    );
  }
}
