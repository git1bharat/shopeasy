// lib/screens/login_screen.dart
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luxe_loft/bloc/auth/auth_bloc.dart';
import 'package:luxe_loft/bloc/auth/auth_event.dart';
import 'package:luxe_loft/bloc/auth/auth_state.dart';
import 'package:luxe_loft/utill/luxe_color.dart';
import 'package:luxe_loft/utill/luxe_typography.dart';
import 'package:luxe_loft/widgets/submit_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      context.read<AuthBloc>().add(EmailSignInRequested(email, password));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.error)),
                );
              } else if (state is Authenticated) {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/homeScreen', (route) => false);
              }
            },
            builder: (context, state) {
              if (state is AuthLoading) {
                return CircularProgressIndicator();
              }

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 45.h,
                      ),
                      Center(
                        child: Image.asset('assets/images/logo.png'),
                      ),
                      SizedBox(
                        height: 44.h,
                      ),
                      const Text(
                        'Welcome Back!',
                        style: LuxeTypo.displayLarge,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      const Text(
                        'Login to continue',
                        style: LuxeTypo.titleSmall,
                      ),
                      SizedBox(
                        height: 37.h,
                      ),
                      _buildLoginForm(),
                      SizedBox(
                        height: 30.h,
                      ),
                      SubmitButton(
                        buttonName: 'Login',
                        onTap: _login,
                      ),
                      SizedBox(
                        height: 40.h,
                      ),
                      const Text(
                        'or continue with ',
                        style: LuxeTypo.titleSmall,
                      ),
                      SizedBox(
                        height: 40.h,
                      ),
                      // Optionally, you can keep social sign-in buttons
                      // or remove them if not needed.
                      SizedBox(
                        height: 140.h,
                      ),
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            const TextSpan(
                              text: "Don't have an account? ",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                            TextSpan(
                              text: 'SIGN UP',
                              style: const TextStyle(
                                color: LuxeColors.brandPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushNamed(context, '/signUpScreen');
                                },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.email),
              labelText: 'Email',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              // Simple email validation
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          SizedBox(
            height: 20.h,
          ),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.lock),
              labelText: 'Password',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          SizedBox(
            height: 10.h,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/resetPasswordScreen');
              },
              child: const Text(
                'Forgot Password?',
                style: TextStyle(
                  color: LuxeColors.brandPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
