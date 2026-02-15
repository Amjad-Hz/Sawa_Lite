import 'package:dio/dio.dart';
import '../models/wallet_model.dart';

class ApiService {
  static final ApiService instance = ApiService._internal();

  late final Dio dio;

  static const String baseUrl = 'http://10.0.2.2:8000';

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
  }

  // -----------------------------
  // 🔐 إدارة التوكن
  // -----------------------------
  void setToken(String? token) {
    _token = token;
    if (token != null) {
      dio.options.headers['Authorization'] = 'Bearer $token';
    } else {
      dio.options.headers.remove('Authorization');
    }
  }

  // -----------------------------
  // 🔐 تسجيل الدخول
  // -----------------------------
  Future<String> login({
    required String phone,
    required String password,
  }) async {
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
    setToken(token);
    return token;
  }

  // -----------------------------
  // 🆕 إنشاء حساب
  // -----------------------------
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

  // -----------------------------
  // 👤 بيانات المستخدم
  // -----------------------------
  Future<Map<String, dynamic>> getMe() async {
    final response = await dio.get('/users/me');
    return response.data;
  }

  // -----------------------------
  // 🧾 الخدمات
  // -----------------------------
  Future<List<dynamic>> getServices() async {
    final response = await dio.get('/services/');
    return response.data;
  }

  // -----------------------------
  // 📝 الطلبات
  // -----------------------------
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

  // -----------------------------
  // 💰 المحفظة
  // -----------------------------

  // جلب الرصيد + سجل العمليات
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

  // دفع طلب من المحفظة
  Future<WalletTransaction> payForOrder(int orderId) async {
    final response = await dio.post('/wallet/pay/$orderId');
    return WalletTransaction.fromJson(response.data);
  }
}
