import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_app/features/auth/screens/signin.dart';
import '../cubits/auth_cubit.dart';
import '../../../core/components/button.dart';
import '../../../core/components/defField.dart';
import '../../../core/components/colors.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _showPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Column(
                  children: [
                    SizedBox(width: 30),
                    Text(
                      "Create Account",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    Text(
                      "Please Enter your Information",
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 10),
                    Image(
                      image: AssetImage("assets/icons/signup.png"),
                      height: 150,
                      width: 280,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
                Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      DefField(
                        controller: _nameController,
                        hint: "Enter your Name",
                        obsecure: false,
                        lable: " Name",
                        inputtype: TextInputType.name,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter First name';
                          } else if (!value.contains(RegExp(r'^[a-zA-Z\- ]+$'))) {
                            return 'Invalid First name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      DefField(
                        controller: _emailController,
                        hint: "Enter your email",
                        obsecure: false,
                        lable: "Email",
                        inputtype: TextInputType.emailAddress,
                        iconName: Icons.lock,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Field cannot be empty';
                          } else if (!value.contains(RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'))) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      DefField(
                        controller: _passwordController,
                        hint: "Enter your password",
                        obsecure: _showPassword,
                        lable: "Password",
                        inputtype: TextInputType.visiblePassword,
                        iconName: _showPassword ? Icons.visibility_off : Icons.visibility,
                        iconFunction: () {
                          setState(() {
                            _showPassword = !_showPassword;
                          });
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a password';
                          } else if (!value.contains(RegExp(
                              r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$'))) {
                            return 'Requires at least 8 characters,\nAt least one uppercase letter [A-Z],\nAt least one lowercase letter [a-z],\nAt least one number [0-9].';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      DefField(
                        controller: _confirmPasswordController,
                        lable: 'Confirm Password',
                        hint: 're-enter password',
                        obsecure: _showPassword,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please re-enter password';
                          } else if (value != _passwordController.text) {
                            return 'Confirm password does not match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                BlocConsumer<AuthCubit, AuthState>(
                  listener: (context, state) {
                    if (state.status == AuthStatus.error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.error!)),
                      );
                    } else if (state.status == AuthStatus.authenticated) {
                      Navigator.pushReplacementNamed(context, '/search');
                    }
                  },
                  builder: (context, state) {
                    return Button(
                      buttonText: "Sign up",
                      buttonFunction: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<AuthCubit>().signup(
                            _nameController.text,
                            _emailController.text,
                            _passwordController.text,
                          );
                        }
                      },
                    );
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 38),
                    const Text(
                      "Already registered?",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 133, 133, 133),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const SignInScreen()),
                      ),
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}