import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_client.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthState extends Equatable {
  final AuthStatus status;
  final String? error;

  const AuthState({required this.status, this.error});

  @override
  List<Object?> get props => [status, error];
}

class AuthCubit extends Cubit<AuthState> {
  final ApiClient _apiClient;

  AuthCubit(this._apiClient) : super(const AuthState(status: AuthStatus.initial));

  Future<void> checkAuthStatus() async {
    emit(const AuthState(status: AuthStatus.loading));
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    if (token != null) {
      emit(const AuthState(status: AuthStatus.authenticated));
    } else {
      emit(const AuthState(status: AuthStatus.unauthenticated));
    }
  }

  Future<void> login(String email, String password) async {
    emit(const AuthState(status: AuthStatus.loading));
    try {
      final response = await _apiClient.post('/admin/auth/login', data: {
        'email': email,
        'password': password,
      });
      await _saveTokens(response.data['data']['tokens']['accessToken'], response.data['data']['tokens']['refreshToken']);
      emit(const AuthState(status: AuthStatus.authenticated));
    } catch (e) {
      emit(AuthState(status: AuthStatus.error, error: e.toString()));
    }
  }

  Future<void> signup(String name, String email, String password) async {
    emit(const AuthState(status: AuthStatus.loading));
    try {
      final response = await _apiClient.post('/signup', data: {
        'name': name,
        'email': email,
        'password': password,
      });
      await _saveTokens(response.data['access_token'], response.data['refresh_token']);
      emit(const AuthState(status: AuthStatus.authenticated));
    } catch (e) {
      emit(AuthState(status: AuthStatus.error, error: e.toString()));
    }
  }

  Future<void> logout() async {
    emit(const AuthState(status: AuthStatus.loading));
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
    emit(const AuthState(status: AuthStatus.unauthenticated));
    
  }

  Future<void> _saveTokens(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', accessToken);
    await prefs.setString('refresh_token', refreshToken);
  }
}

