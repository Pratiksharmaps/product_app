import 'package:dio/dio.dart';
import 'package:product_app/features/product/models/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://bb3-api.ashwinsrivastava.com'; // Replace with your API base URL

  ApiClient() {
    _dio.options.baseUrl = _baseUrl;
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('access_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException error, handler) async {
        if (error.response?.statusCode == 401) {
          if (await _refreshToken()) {
            return handler.resolve(await _retry(error.requestOptions));
          }
        }
        return handler.next(error);
      },
    ));
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return _dio.request<dynamic>(requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options);
  }

  Future<bool> _refreshToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString('refresh_token');
      if (refreshToken == null) return false;

      final response = await _dio.post('/refresh-token', data: {'refresh_token': refreshToken});
      if (response.statusCode == 200) {
        final newAccessToken = response.data['access_token'];
        final newRefreshToken = response.data['refresh_token'];
        await prefs.setString('access_token', newAccessToken);
        await prefs.setString('refresh_token', newRefreshToken);
        return true;
      }
    } catch (e) {
      print('Error refreshing token: $e');
    }
    return false;
  }
  

  Future<List<Product>> getProducts({int page = 1, int limit = 10}) async {
    try {
      final response = await _dio.get('/store/product', queryParameters: {
        'page': page,
        'limit': limit,
      });
      final List<dynamic> productsJson = response.data['data'];
      return productsJson.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<Product>> searchProducts(String query, {int page = 1, int limit = 10}) async {
    try {
      final response = await _dio.get('/store/product', queryParameters: {
        'page': page,
        'limit': limit,
        'search': query,
      });
      final List<dynamic> productsJson = response.data['data'];
      return productsJson.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return response;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> post(String path, {dynamic data}) async {
    try {
      final response = await _dio.post(path, data: data);
      return response;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(dynamic error) {
    if (error is DioException) {
      if (error.response != null) {
        return Exception('API Error: ${error.response!.statusCode} - ${error.response!.statusMessage}');
      }
      return Exception('Network Error: ${error.message}');
    }
    return Exception('Unexpected Error: $error');
  }
}

