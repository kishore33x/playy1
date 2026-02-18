import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/app_providers.dart';
import '../utils/constants.dart';
import '../widgets/auth_ui.dart';

/// User login screen
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Handle user login
  void _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    final authNotifier = ref.read(authNotifierProvider.notifier);
    await authNotifier.signIn(email: email, password: password);

    // Navigate after successful login
    if (mounted) {
      Navigator.of(context).pushReplacementNamed(AppConstants.homeRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthGradientBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final horizontalPadding =
                  constraints.maxWidth > 700 ? 48.0 : 24.0;
              return Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: 28,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 460),
                    child: GlassCard(
                      child: Padding(
                        padding: const EdgeInsets.all(28),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Center(child: AuthLogo()),
                            const SizedBox(height: 24),
                            Text(
                              'Welcome Back',
                              style: GoogleFonts.poppins(
                                fontSize: 26,
                                fontWeight: FontWeight.w600,
                                color: authInk,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Sign in to continue to PlayOn',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: authInk.withOpacity(0.6),
                              ),
                            ),
                            const SizedBox(height: 28),
                            AuthTextField(
                              controller: _emailController,
                              label: 'Email',
                              hint: 'Enter your email',
                              icon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 16),
                            AuthTextField(
                              controller: _passwordController,
                              label: 'Password',
                              hint: 'Enter your password',
                              icon: Icons.lock_outline,
                              obscureText: true,
                            ),
                            const SizedBox(height: 24),
                            AnimatedPrimaryButton(
                              label: 'Sign In',
                              onPressed: _handleLogin,
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Don't have an account?",
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: authInk.withOpacity(0.7),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                AuthTextButton(
                                  label: 'Sign Up',
                                  color: authBlue,
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushNamed(AppConstants.signupRoute);
                                  },
                                ),
                              ],
                            ),
                            Center(
                              child: AuthTextButton(
                                label: 'Admin Login',
                                color: const Color(0xFFFFB454),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed(AppConstants.adminLoginRoute);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
