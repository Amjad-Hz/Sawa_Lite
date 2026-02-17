import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../models/wallet_model.dart';
import '../user_prefs.dart';
import '../../../main.dart';

class ApiService {
  static final ApiService instance = ApiService._internal();

  late final Dio dio;

  static const String baseUrl = 'http://127.0.0.1:8000';
  // static const String baseUrl = 'http://10.0.2.2:8000';

  String? _token;

  ApiService._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            await UserPrefs.clearToken();
            await UserPrefs.clearUser();
            setToken(null);

            final context = navigatorKey.currentContext;
            if (context != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("انتهت الجلسة، يرجى تسجيل الدخول من جديد"),
                  duration: Duration(seconds: 3),
                ),
              );
            }

            navigatorKey.currentState?.pushNamedAndRemoveUntil(
              "/login",
                  (route) => false,
            );
          }

          return handler.next(e);
        },
      ),
    );
  }

  void setToken(String? token) {
    _token = token;
    if (token != null) {
      dio.options.headers['Authorization'] = 'Bearer $token';
    } else {
      dio.options.headers.remove('Authorization');
    }
  }

  // ============================
  // Auth
  // ============================

  Future<String> login({
    required String phone,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        '/users/login',
        data: {
          'username': phone,
          'password': password,
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      final token = response.data['access_token'];
      if (token == null) throw Exception("بيانات الدخول غير صحيحة");

      setToken(token);
      return token;
    } on DioException catch (e) {
      final detail = e.response?.data['detail'] ?? "فشل تسجيل الدخول";
      throw Exception(detail);
    }
  }

  Future<void> register({
    required String phone,
    required String email,
    required String fullName,
    required String password,
  }) async {
    await dio.post(
      '/users/register',
      data: {
        "phone": phone,
        "email": email,
        "full_name": fullName,
        "password": password,
      },
    );
  }

  Future<Map<String, dynamic>> getMe() async {
    final response = await dio.get('/users/me');
    return response.data;
  }

  Future<void> updateUser({
    required String fullName,
    required String phone,
    required String email,
  }) async {
    await dio.put(
      '/users/update',
      data: {
        "full_name": fullName,
        "phone": phone,
        "email": email,
      },
    );
  }

  Future<void> changePassword({
    required String newPassword,
  }) async {
    await dio.post(
      '/users/change-password',
      data: {
        "new_password": newPassword,
      },
    );
  }

  // ============================
  // Services (User)
  // ============================

  Future<List<dynamic>> getServices() async {
    final response = await dio.get('/services/');
    return response.data;
  }

  // ============================
  // Orders
  // ============================

  Future<Map<String, dynamic>> createOrder({
    required int serviceId,
    String? notes,
  }) async {
    final response = await dio.post(
      '/orders/',
      data: {
        "service_id": serviceId,
        "notes": notes,
      },
    );
    return response.data;
  }

  Future<List<dynamic>> getMyOrders() async {
    final response = await dio.get('/orders/');
    return response.data;
  }

  Future<Map<String, dynamic>> getOrderById(int id) async {
    final response = await dio.get('/orders/$id');
    return response.data;
  }

  // ============================
  // Wallet
  // ============================

  Future<WalletModel> getWallet() async {
    final balanceRes = await dio.get('/wallet/balance');
    final txRes = await dio.get('/wallet/transactions');

    final balance = (balanceRes.data['balance'] as num).toDouble();

    final transactions = (txRes.data as List)
        .map((t) => WalletTransaction.fromJson(t))
        .toList();

    return WalletModel(
      balance: balance,
      transactions: transactions,
    );
  }

  Future<void> rechargeWallet(double amount) async {
    await dio.post('/wallet/charge', data: {"amount": amount});
  }

  Future<WalletTransaction> payForOrder(int orderId) async {
    final response = await dio.post('/wallet/pay/$orderId');
    return WalletTransaction.fromJson(response.data);
  }

  // ============================
  // Community
  // ============================

  Future<List<dynamic>> getExperiences() async {
    final response = await dio.get('/community/experiences');
    return response.data;
  }

  Future<void> addExperience({
    required int serviceId,
    required int rating,
    required String content,
  }) async {
    await dio.post(
      '/community/experiences',
      data: {
        "service_id": serviceId,
        "rating": rating,
        "content": content,
      },
    );
  }

  // ============================
  // Admin — Orders
  // ============================

  Future<List<dynamic>> adminGetAllOrders() async {
    final response = await dio.get('/admin/orders');
    return response.data;
  }

  Future<Map<String, dynamic>> adminUpdateOrderStatus(int id, String status) async {
    final response = await dio.patch(
      '/admin/orders/$id/status',
      data: {"status": status},
    );
    return response.data;
  }

  // ============================
  // Admin — Users
  // ============================

  Future<List<dynamic>> adminGetAllUsers() async {
    final response = await dio.get('/admin/users');
    return response.data;
  }

  Future<Map<String, dynamic>> adminUpdateUserRole(int id, String role) async {
    final response = await dio.patch(
      '/admin/users/$id/role',
      data: {"role": role},
    );
    return response.data;
  }

  // ============================
  // Admin — Services (عرض فقط)
  // ============================

  Future<List<dynamic>> adminGetAllServices() async {
    final response = await dio.get('/services/');
    return response.data;
  }
}
