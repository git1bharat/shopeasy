// lib/screens/otp_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luxe_loft/bloc/auth/auth_bloc.dart';
import 'package:luxe_loft/bloc/auth/auth_event.dart';
import 'package:luxe_loft/bloc/auth/auth_state.dart';
import 'package:luxe_loft/utill/luxe_typography.dart';
import 'package:luxe_loft/widgets/submit_button.dart';
import 'package:pinput/pinput.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String? _verificationId;
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args != null && args is String) {
      _verificationId = args;
    }
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _verifyOtp() {
    if (_formKey.currentState!.validate()) {
      final otp = _otpController.text.trim();
      if (_verificationId != null) {
        // context
        //     .read<AuthBloc>()
        //     .add(OtpSubmitted(otp: otp, verificationId: _verificationId!));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Verification ID is missing')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: Padding(
            padding: const EdgeInsets.only(top: 15.0, left: 8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 155, 207, 216),
                  shape: BoxShape.circle,
                ),
                width: 30.w,
                height: 30.h,
                child: const Center(
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 16,
                  ),
                ),
              ),
            ),
          )),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
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
              return Center(child: CircularProgressIndicator());
            }

            return Column(
              children: [
                SizedBox(
                  height: 18.h,
                ),
                const Text(
                  'OTP Verification',
                  style: LuxeTypo.displayLarge,
                ),
                SizedBox(
                  height: 15.h,
                ),
                const Text(
                  textAlign: TextAlign.center,
                  'Enter the verification code we just sent to your phone number',
                  style: LuxeTypo.titleSmall,
                ),
                SizedBox(
                  height: 34.h,
                ),
                Form(
                  key: _formKey,
                  child: Pinput(
                    controller: _otpController,
                    length: 6,
                    defaultPinTheme: PinTheme(
                      width: 56,
                      height: 56,
                      textStyle: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the OTP';
                      }
                      if (value.length < 6) {
                        return 'OTP must be 6 digits';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: 34.h,
                ),
                SubmitButton(
                  buttonName: 'VERIFY',
                  onTap: _verifyOtp,
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
