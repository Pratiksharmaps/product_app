import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_app/features/auth/screens/SignUp.dart';
import '../cubits/auth_cubit.dart';
import '../../../core/components/button.dart';
import '../../../core/components/defField.dart';
import '../../../core/components/colors.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _showPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Column(
                  children: [
                    SizedBox(height: 18),
                    Text(
                      "Welcome Back! ",
                      style: TextStyle(
                        fontSize: 25,
                        decorationThickness: 8,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Please login to continue",
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                InteractiveViewer(
                  minScale: 0.2,
                  maxScale: 5.0,
                  child: const Image(
                    image: AssetImage("assets/icons/login.png"),
                    height: 180,
                    width: 310,
                    fit: BoxFit.contain,
                  ),
                ),
                Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 19),
                      Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          children: [
                            DefField(
                              controller: _emailController,
                              hint: "Enter your email",
                              obsecure: false,
                              lable: "Email",
                              iconName: Icons.lock,
                              inputtype: TextInputType.emailAddress,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Field cannot be empty';
                                } else if (!value.contains(RegExp(
                                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'))) {
                                  return 'Please enter a valid Email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 18),
                            DefField(
                              controller: _passwordController,
                              hint: "Enter your password",
                              obsecure: _showPassword,
                              lable: "Password",
                              iconName: _showPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              iconFunction: () {
                                setState(() {
                                  _showPassword = !_showPassword;
                                });
                              },
                              inputtype: TextInputType.visiblePassword,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      BlocConsumer<AuthCubit, AuthState>(
                        listener: (context, state) {
                          if (state.status == AuthStatus.error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.error!)),
                            );
                          } else if (state.status == AuthStatus.authenticated) {
                            Navigator.pushReplacementNamed(
                                context, '/products');
                          }
                        },
                        builder: (context, state) {
                          return Button(
                            buttonText: "Log In",
                            buttonFunction: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<AuthCubit>().login(
                                      _emailController.text,
                                      _passwordController.text,
                                    );
                              }
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 38),
                    const Text(
                      "Don't have an Account ?",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 133, 133, 133),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpScreen()),
                      ),
                      child: const Text(
                        "Register",
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
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
