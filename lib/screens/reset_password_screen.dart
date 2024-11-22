// lib/screens/reset_password_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luxe_loft/bloc/auth/auth_bloc.dart';
import 'package:luxe_loft/bloc/auth/auth_event.dart';
import 'package:luxe_loft/bloc/auth/auth_state.dart';
import 'package:luxe_loft/utill/luxe_color.dart';
import 'package:luxe_loft/utill/luxe_typography.dart';
import 'package:luxe_loft/widgets/submit_button.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _resetPassword() {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      context.read<AuthBloc>().add(PasswordResetRequested(email));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // Optionally, add an AppBar
        appBar: AppBar(
          title: const Text('Reset Password'),
        ),
        body: Center(
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.error)),
                );
              } else if (state is PasswordResetEmailSent) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                          'Password reset email has been sent to ${state.email}')),
                );
                Navigator.pop(context);
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
                        'Reset Password',
                        style: LuxeTypo.displayLarge,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      const Text(
                        'Enter your email to receive a password reset link',
                        style: LuxeTypo.titleSmall,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 37.h,
                      ),
                      _buildResetForm(),
                      SizedBox(
                        height: 30.h,
                      ),
                      SubmitButton(
                        buttonName: 'Send Reset Link',
                        onTap: _resetPassword,
                      ),
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

  Widget _buildResetForm() {
    return Form(
      key: _formKey,
      child: TextFormField(
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
    );
  }
}
