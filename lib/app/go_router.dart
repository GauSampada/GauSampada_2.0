// import 'package:flutter/material.dart';
// import 'package:gausampada/app/error.dart';
// import 'package:gausampada/backend/enums/user_type.dart';
// import 'package:gausampada/screens/auth/login.dart';
// import 'package:gausampada/screens/auth/signup.dart';
// import 'package:gausampada/screens/communication/chat.dart';
// import 'package:gausampada/screens/communication/connect.dart';
// import 'package:gausampada/screens/communication/widgets/call.dart';
// import 'package:go_router/go_router.dart';
// import 'package:gausampada/screens/home/home_screen.dart';
// import 'package:gausampada/screens/onboarding/onboarding_main.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class AuthenticatedScaffold extends StatelessWidget {
//   final Widget child;

//   const AuthenticatedScaffold({super.key, required this.child});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: child,
//       // Add bottom navigation bar or other persistent UI elements here
//       // Example:
//       // bottomNavigationBar: BottomNavigationBar(
//       //   items: [
//       //     BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//       //     BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Appointments'),
//       //   ],
//       //   onTap: (index) {
//       //     if (index == 0) context.go('/home');
//       //     if (index == 1) context.go('/appointments');
//       //   },
//       // ),
//     );
//   }
// }

// final GoRouter router = GoRouter(
//   initialLocation: '/onboarding',
//   errorBuilder: (context, state) => const ErrorScreen(error: 'Page not found'),
//   redirect: (context, state) async {
//     try {
//       final user = FirebaseAuth.instance.currentUser;
//       final isAuthenticated = user != null;

//       // If user is not authenticated and trying to access protected routes
//       if (!isAuthenticated && state.fullPath?.startsWith('/home') == true) {
//         return '/login';
//       }

//       // If user is authenticated and trying to access auth routes
//       if (isAuthenticated &&
//           (state.fullPath == '/login' ||
//               state.fullPath == '/signup' ||
//               state.fullPath == '/onboarding')) {
//         return '/home';
//       }

//       // Handle invalid routes or other navigation issues
//       if (state.fullPath != null &&
//           ![
//             '/onboarding',
//             '/login',
//             '/signup',
//             '/home',
//             '/appointments',
//             '/chat/:appointmentId',
//             '/call/:appointmentId/:callType',
//             '/error'
//           ].any((route) => state.fullPath!.startsWith(route))) {
//         return '/error';
//       }

//       return null;
//     } catch (e) {
//       // Redirect to error page if any exception occurs during redirect
//       print('Navigation error: $e');
//       return '/error';
//     }
//   },
//   routes: [
//     GoRoute(
//       path: '/onboarding',
//       builder: (context, state) => const OnboardingMainScreen(),
//     ),
//     GoRoute(
//       path: '/login',
//       builder: (context, state) => const LoginScreen(),
//     ),
//     GoRoute(
//       path: '/signup',
//       builder: (context, state) {
//         final userTypeString = state.uri.queryParameters['userType'] ?? 'user';
//         final success = fromStringToEnum(userTypeString);
//         return SignupScreen(userType: success);
//       },
//     ),
//     GoRoute(
//       path: '/error',
//       builder: (context, state) => ErrorScreen(
//         error: state.extra as String? ?? 'An unexpected error occurred',
//       ),
//     ),
//     ShellRoute(
//       builder: (context, state, child) => AuthenticatedScaffold(child: child),
//       routes: [
//         GoRoute(
//           path: '/home',
//           builder: (context, state) => const HomeScreen(),
//         ),
//         GoRoute(
//           path: '/appointments',
//           builder: (context, state) => const AppointmentScreen(),
//         ),
//         GoRoute(
//           path: '/chat/:appointmentId',
//           builder: (context, state) => AppointmentChatScreen(
//             appointmentId: state.pathParameters['appointmentId']!,
//           ),
//         ),
//         GoRoute(
//           path: '/call/:appointmentId/:callType',
//           builder: (context, state) => CallScreen(
//             appointmentId: state.pathParameters['appointmentId']!,
//             callType: state.pathParameters['callType']!,
//           ),
//         ),
//       ],
//     ),
//   ],
// );
