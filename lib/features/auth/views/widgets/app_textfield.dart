import 'package:chat_application_task/core/constants/app_colors.dart';
import 'package:chat_application_task/core/style/outline_border.dart';
import 'package:flutter/material.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.labelText,
    this.validator,
    this.isPassword = false,
  });

  final TextEditingController controller;
  final String? hintText;
  final String? labelText;
  final String? Function(String?)? validator;
  final bool isPassword;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.isPassword ? _obscureText : false,

        decoration: InputDecoration(
          labelText: widget.labelText,
          hintText: widget.hintText,
          labelStyle: const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
          maintainHintSize: true,
          suffixIcon: widget.isPassword
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },

                  child: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.grey,
                  ),
                )
              : null,
          hintStyle: const TextStyle(
            color: AppColors.greyShade400,
            fontSize: 14,
          ),
          filled: true,
          fillColor: AppColors.greyShade50,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          border: kOutLineBorder,
          enabledBorder: kOutLineBorder,
          focusedBorder: kOutLineBorder.copyWith(
            borderSide: const BorderSide(color: AppColors.blue, width: 2),
          ),
          errorBorder: kOutLineBorder.copyWith(
            borderSide: const BorderSide(color: AppColors.red, width: 2),
          ),
          focusedErrorBorder: kOutLineBorder.copyWith(
            borderSide: const BorderSide(color: AppColors.red, width: 2),
          ),
        ),
        validator: widget.validator,
      ),
    );
  }
}
