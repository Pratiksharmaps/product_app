import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_app/cubits/product_cubit.dart';
import 'package:product_app/screens/SignUp.dart';
import 'package:product_app/screens/product_list_screen.dart';
import 'package:product_app/screens/signin.dart';
import 'cubits/auth_cubit.dart';
import 'cubits/search_cubit.dart';
import 'services/api_client.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ApiClient _apiClient = ApiClient();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(_apiClient)..checkAuthStatus(),
        ),
        BlocProvider<SearchCubit>(
          create: (context) => SearchCubit(_apiClient),
        ),
        BlocProvider<ProductCubit>(
          create: (context) => ProductCubit(_apiClient),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Cubit App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state.status == AuthStatus.authenticated) {
              return  const  ProductListScreen();
            } else {
              return const SignInScreen();
            }
          },
        ),
        routes: {
          '/login': (context) => const SignInScreen(),
          '/signup': (context) => const SignUpScreen(),
          '/products': (context) => const ProductListScreen(),
        },
      ),
    );
  }
}

