import 'package:shared_preferences/shared_preferences.dart';

class SpService {
  static final SpService _instance = SpService._internal();

  factory SpService() => _instance;

  SpService._internal();
  Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('x-auth-token', token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('x-auth-token');
  }
}
