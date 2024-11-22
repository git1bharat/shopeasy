// import 'package:animated_splash_screen/animated_splash_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:luxe_loft/screens/home_screen.dart';
// import 'package:luxe_loft/screens/login_screen.dart';
// import 'package:luxe_loft/screens/onboarding_screen.dart';
// import 'package:luxe_loft/screens/otp_screen.dart';
// import 'package:luxe_loft/screens/signup_screen.dart';

// void main() {
//   runApp(const MyApp());import 'package:animated_splash_screen/animated_splash_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:luxe_loft/screens/home_screen.dart';
// import 'package:luxe_loft/screens/login_screen.dart';
// import 'package:luxe_loft/screens/onboarding_screen.dart';
// import 'package:luxe_loft/screens/otp_screen.dart';
// import 'package:luxe_loft/screens/signup_screen.dart';
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ScreenUtilInit(
//       designSize: const Size(
//         designSizeWidth,
//         designSizeHeight,
//       ),
//       minTextAdapt: true,
//       splitScreenMode: true,
//       child: MaterialApp(
//         title: 'Flutter Demo',
//         theme: ThemeData(
//           colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//           useMaterial3: true,
//         ),
//         home: AnimatedSplashScreen(
//           duration: 300,
//           splash: Image.asset('assets/images/logo.png'),
//           splashTransition: SplashTransition.fadeTransition,
//           nextScreen: const OnBoardingScreen(),
//         ),
//         // initialRoute: 'splashScreen',
//         routes: {
//           // 'splashScreen': (context) => const SplashScreen(),
//           '/onBoardingScreen': (context) => const OnBoardingScreen(),
//           '/loginScreen': (context) => const LoginScreen(),
//           '/otpScreen': (context) => const OtpScreen(),
//           '/signUpScreen': (context) => const SignUpScreen(),
//           '/homeScreen': (context) => const HomeScreen(),
//         },
//       ),
//     );
//   }
// }
// lib/main.dart
// lib/main.dart
// lib/main.dart
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luxe_loft/bloc/auth/auth_bloc.dart';
import 'package:luxe_loft/bloc/auth/auth_event.dart';
import 'package:luxe_loft/bloc/auth/auth_repository.dart';
import 'package:luxe_loft/bloc/auth/auth_state.dart';
import 'package:luxe_loft/bloc/product/bloc/product_bloc.dart';
import 'package:luxe_loft/bloc/product/bloc/product_event.dart';
import 'package:luxe_loft/screens/onboarding_screen.dart';
import 'package:luxe_loft/screens/signup_screen.dart';
import 'package:onboarding/onboarding.dart';

import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/reset_password_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthRepository authRepository = AuthRepository();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: authRepository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) =>
                AuthBloc(authRepository: authRepository)..add(AppStarted()),
          ),
          BlocProvider(
            create: (_) => ProductBloc()
              ..add(LoadProductsEvent()), // Provide ProductBloc here
          ),
        ],
        child: ScreenUtilInit(
          designSize: const Size(375, 812), // Adjust based on your design
          builder: (context, child) => MaterialApp(
            title: 'Firebase Email Bloc Auth',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            initialRoute: '/',
            routes: {
              '/': (context) => const AppNavigator(),
              '/loginScreen': (context) => const LoginScreen(),
              '/signUpScreen': (context) => const SignUpScreen(),
              '/resetPasswordScreen': (context) => const ResetPasswordScreen(),
              '/homeScreen': (context) =>
                  HomeScreen(), // HomeScreen can now access ProductBloc
              // Add other routes as needed
            },
          ),
        ),
      ),
    );
  }
}

class AppNavigator extends StatelessWidget {
  const AppNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          return HomeScreen();
        } else if (state is AuthLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          return AnimatedSplashScreen(
            duration: 300,
            splash: Image.asset('assets/images/logo.png'),
            splashTransition: SplashTransition.fadeTransition,
            nextScreen: const OnBoardingScreen(),
          );
        }
      },
    );
  }
}






// RepositoryProvider.value(
//       value: authRepository,
//       child: MultiBlocProvider(
//         providers: [
//           BlocProvider(
//             create: (_) =>
//                 AuthBloc(authRepository: authRepository)..add(AppStarted()),
//           ),
//           BlocProvider(
//             create: (_) => ProductBloc()
//               ..add(LoadProductsEvent()), // Provide ProductBloc here
//           ),
//         ],
//         child: ScreenUtilInit(
//           designSize: const Size(375, 812), // Adjust based on your design
//           builder: (context, child) => MaterialApp(
//             home: AnimatedSplashScreen(
//               duration: 300,
//               splash: Image.asset('assets/images/logo.png'),
//               splashTransition: SplashTransition.fadeTransition,
//               nextScreen: const OnBoardingScreen(),
//             ),
//             theme: ThemeData(
//               primarySwatch: Colors.blue,
//             ),
//             initialRoute: '/',
//             routes: {
//               '/': (context) => const SplashScreen(),
//               '/loginScreen': (context) => const LoginScreen(),
//               '/signUpScreen': (context) => const SignUpScreen(),
//               '/resetPasswordScreen': (context) => const ResetPasswordScreen(),
//               '/homeScreen': (context) =>
//                   HomeScreen(), // HomeScreen can now access ProductBloc
//               // Add other routes as needed
//             },
//           ),
//         ),
//       ),
//     );