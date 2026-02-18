import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';
import 'config/theme.dart';
import 'config/routes.dart';
import 'utils/constants.dart';
import 'providers/app_providers.dart';

/// Main entry point of the PlayTrack application
void main() async {
  // Initialize Flutter bindings
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Run the app with Riverpod
  runApp(
    const ProviderScope(
      child: PlayTrackApp(),
    ),
  );
}

/// Main application widget
class PlayTrackApp extends StatelessWidget {
  const PlayTrackApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const SplashScreenLoader(),
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}

/// Splash screen loader - checks auth state and navigates
class SplashScreenLoader extends ConsumerWidget {
  const SplashScreenLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(firebaseUserProvider);

    return authState.when(
      data: (user) {
        // Navigate based on auth state after initial load
        Future.microtask(() {
          if (user != null) {
            Navigator.of(context).pushReplacementNamed(AppConstants.homeRoute);
          } else {
            Navigator.of(context)
                .pushReplacementNamed(AppConstants.loginRoute);
          }
        });
        return const SplashScreenWidget();
      },
      loading: () => const SplashScreenWidget(),
      error: (err, stack) {
        // On error, go to login
        Future.microtask(() {
          Navigator.of(context).pushReplacementNamed(AppConstants.loginRoute);
        });
        return const SplashScreenWidget();
      },
    );
  }
}

/// Splash screen UI widget
class SplashScreenWidget extends StatelessWidget {
  const SplashScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFF1976D2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
                child: Text(
                  'PT',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // App Name
            const Text(
              AppConstants.appName,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF212121),
              ),
            ),
            const SizedBox(height: 8),

            // Tagline
            Text(
              'Live Sports, Real Competition',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 48),

            // Loading indicator
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                const Color(0xFF1976D2).withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

