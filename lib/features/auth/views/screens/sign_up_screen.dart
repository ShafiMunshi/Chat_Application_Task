import 'package:chat_application_task/core/constants/dimens.dart';
import 'package:chat_application_task/core/style/text_styles.dart';
import 'package:chat_application_task/features/auth/views/provider/sign_up_provider.dart';
import 'package:chat_application_task/features/auth/views/screens/sign_in_screen.dart';
import 'package:chat_application_task/features/auth/views/widgets/app_textfield.dart';
import 'package:chat_application_task/features/chat/views/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validator/form_validator.dart';
import 'package:gap/gap.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    ref.listenManual(signUpProvider, (previous, next) {
      switch (next) {
        case AsyncData(:final value) when value != null:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const ChatScreen()),
          );
        case AsyncError(:final error):
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(error.toString())));

        default:
        // Do nothing
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
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
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(Dimens.mediumPadding),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const FlutterLogo(size: 100),
                    const Gap(40),
                    const Text('Create Account', style: AppTextStyles.heading2),
                    const Gap(30),
                    nameField(),
                    const Gap(10),
                    emailAddressField(),
                    const Gap(10),
                    passwordField(),
                    const Gap(24),
                    signUpButton(context),
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

  Column nameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text("Full Name", style: AppTextStyles.labelLarge),
        AppTextField(
          controller: _nameController,
          hintText: 'Enter your full name',
          validator: ValidationBuilder().minLength(2).build(),
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
        const Text("Already have an account? "),
        TextButton(
          onPressed: () {
            // Navigate to sign in screen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SignInScreen()),
            );
          },
          child: const Text('Sign In'),
        ),
      ],
    );
  }

  SizedBox signUpButton(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            ref
                .read(signUpProvider.notifier)
                .signUp(
                  name: _nameController.text.trim(),
                  email: _emailController.text.trim(),
                  password: _passwordController.text.trim(),
                );
          }
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: const Text('Sign Up', style: TextStyle(fontSize: 16)),
      ),
    );
  }
}
