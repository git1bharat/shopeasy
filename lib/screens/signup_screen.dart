import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:luxe_loft/bloc/auth/auth_bloc.dart';
import 'package:luxe_loft/bloc/auth/auth_event.dart';
import 'package:luxe_loft/bloc/auth/auth_state.dart';
import 'package:luxe_loft/utill/luxe_typography.dart';
import 'package:luxe_loft/widgets/submit_button.dart';
import 'package:luxe_loft/widgets/social_icon_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  PhoneNumber _phoneNumber = PhoneNumber(isoCode: 'NG');

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _register() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      final phoneNumber = _phoneNumber.phoneNumber ?? '';

      context.read<AuthBloc>().add(
            EmailSignUpRequested(
              name: name,
              email: email,
              password: password,
              phoneNumber: phoneNumber,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(left: 30.w, right: 30.w, top: 50.h),
        child: SingleChildScrollView(
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
                return const Center(child: CircularProgressIndicator());
              }

              return Column(
                children: [
                  const Center(
                    child: Text(
                      'Create Account',
                      style: LuxeTypo.displayLarge,
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  const Text(
                    'Sign Up',
                    style: LuxeTypo.displaySmall,
                  ),
                  SizedBox(
                    height: 50.h,
                  ),
                  _buildSignUpForm(),
                  SizedBox(
                    height: 20.h,
                  ),
                  SubmitButton(
                    buttonName: 'NEXT',
                    onTap: _register,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  const Text(
                    'or continue with ',
                    style: LuxeTypo.titleSmall,
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SocialIconButton(
                          image: 'assets/images/google.webp',
                          buttonName: 'Google'),
                      SizedBox(width: 10.w),
                      const SocialIconButton(
                          image: 'assets/images/facebook.png',
                          buttonName: 'Facebook'),
                      SizedBox(width: 10.w),
                      const SocialIconButton(
                          image: 'assets/images/apple.png',
                          buttonName: 'Apple'),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Name Field
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.person),
              labelText: 'Name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
          SizedBox(
            height: 20.h,
          ),
          // Email Field
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.email_outlined),
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
          // Password Field
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.lock_open_rounded),
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
            height: 20.h,
          ),
          // Confirm Password Field
          TextFormField(
            controller: _confirmPasswordController,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.lock_open_rounded),
              labelText: 'Confirm Password',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm your password';
              }
              if (value != _passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          SizedBox(
            height: 20.h,
          ),
          // Phone Number Input
          PhoneNumberInput(
            controller: _phoneController,
            onInputChanged: (PhoneNumber number) {
              setState(() {
                _phoneNumber = number;
              });
            },
          ),
        ],
      ),
    );
  }
}

class PhoneNumberInput extends StatefulWidget {
  const PhoneNumberInput({
    required this.controller,
    required this.onInputChanged,
    super.key,
  });

  final TextEditingController controller;
  final void Function(PhoneNumber) onInputChanged;

  @override
  State<PhoneNumberInput> createState() => _PhoneNumberInputState();
}

class _PhoneNumberInputState extends State<PhoneNumberInput> {
  String initialCountry = 'IN';
  PhoneNumber _phoneNumber = PhoneNumber(isoCode: 'IN');

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color.fromARGB(255, 146, 136, 136)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: InternationalPhoneNumberInput(
        onInputChanged: widget.onInputChanged,
        onInputValidated: (bool value) {
          // Optionally handle input validation
        },
        selectorConfig: const SelectorConfig(
          selectorType: PhoneInputSelectorType.DROPDOWN,
          setSelectorButtonAsPrefixIcon: true,
          useBottomSheetSafeArea: true,
        ),
        ignoreBlank: false,
        autoValidateMode: AutovalidateMode.disabled,
        selectorTextStyle: const TextStyle(color: Colors.black),
        initialValue: _phoneNumber,
        textFieldController: widget.controller,
        formatInput: true,
        keyboardType:
            const TextInputType.numberWithOptions(signed: true, decimal: true),
        inputDecoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Enter phone number',
          contentPadding: EdgeInsets.zero,
        ),
        onSaved: (PhoneNumber number) {
          _phoneNumber = number;
        },
        countries: const ['US', 'IN', 'NG'],
      ),
    );
  }
}
