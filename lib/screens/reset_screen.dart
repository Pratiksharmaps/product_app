import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/auth_cubit.dart';
import '../components/button.dart';
import '../components/defField.dart';
import '../components/colors.dart';

class ResetScreen extends StatefulWidget {
  const ResetScreen({super.key});

  @override
  State<ResetScreen> createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  const Column(
                    children: [
                      SizedBox(height: 38),
                      Text(
                        "Reset Password",
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
                      SizedBox(height: 30),
                      Image(
                        image: AssetImage("assets/icons/forgotimg.png"),
                        height: 180,
                        width: 310,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                  Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 25),
                        Form(
                          key: _formKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: DefField(
                            controller: _emailController,
                            hint: "Enter your email",
                            obsecure: false,
                            lable: "Email",
                            iconName: Icons.lock,
                            inputtype: TextInputType.emailAddress,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Field cannot be empty';
                              } else if (!value.contains(
                                  RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'))) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        BlocConsumer<AuthCubit, AuthState>(
                          listener: (context, state) {
                            if (state.status == AuthStatus.error) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(state.error!)),
                              );
                            } else if (state.status == AuthStatus.unauthenticated) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Password reset email sent')),
                              );
                              Navigator.pop(context);
                            }
                          },
                          builder: (context, state) {
                            return Button(
                              buttonText: "Reset",
                              buttonFunction: () {
                                if (_formKey.currentState!.validate()) {
                                  // context.read<AuthCubit>().resetPassword(_emailController.text)
                                }
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}