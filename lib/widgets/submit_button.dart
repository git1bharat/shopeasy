import 'package:flutter/material.dart';
import 'package:luxe_loft/utill/luxe_color.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton(
      {super.key, required this.buttonName, required this.onTap});
  final String buttonName;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onTap();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: LuxeColors.brandPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 126, vertical: 20),
      ),
      child: Text(
        buttonName,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
