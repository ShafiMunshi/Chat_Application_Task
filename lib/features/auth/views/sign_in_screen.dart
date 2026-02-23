import 'package:chat_application_task/core/constants/dimens.dart';
import 'package:chat_application_task/core/style/text_styles.dart';
import 'package:chat_application_task/features/auth/views/widgets/app_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validator/form_validator.dart';
import 'package:gap/gap.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  final _formKey = GlobalKey<FormState>();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(Dimens.mediumPadding),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const FlutterLogo(size: 100),
                    const Gap(40),
                    const Text(
                      'Welcome Back',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(30),
                    emailAddressField(),
                    const Gap(16),
                    passwordField(),
                    const Gap(24),
                    signInButton(context),
                    const Gap(20),
                    signUpSections(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Column emailAddressField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text("Email Address", style: AppTextStyles.labelLarge),
        AppTextField(
          controller: _emailController,
          hintText: 'Enter your email',
          validator: ValidationBuilder().email().build(),
        ),
      ],
    );
  }

  Column passwordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text("Password", style: AppTextStyles.labelLarge),
        AppTextField(
          controller: _passwordController,
          hintText: 'Enter your password',
          isPassword: true,
          validator: ValidationBuilder().minLength(6).build(),
        ),
      ],
    );
  }

  Row signUpSections() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account? "),
        TextButton(
          onPressed: () {
            // Navigate to sign up screen
          },
          child: const Text('Sign Up'),
        ),
      ],
    );
  }

  SizedBox signInButton(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Sign In Successful')));
          }
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: const Text('Sign In', style: TextStyle(fontSize: 16)),
      ),
    );
  }
}
