import 'package:e_scan/trasient.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepository {

  static setUserData(UserData userData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("username", userData.username);
    prefs.setString("database", userData.database);
    prefs.setString("secretToken", userData.secretToken);
  }

  static Future<UserData> getUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return UserData(
        prefs.getString("username")!,
        prefs.getString("database")!,
        prefs.getString("secretToken")!
    );
  }

  static Future<ConfigData> getConfigData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return ConfigData(
        prefs.getBool("sendCodeAutomatically")!,
        prefs.getString("urlSendCode")!,
        prefs.getBool("isWithToken")!,
        prefs.getString("urlHeader")!,
        prefs.getString("urlGetToken")!
    );
  }

  static setConfigData(ConfigData configData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("sendCodeAutomatically", configData.sendCodeAutomatically);
    prefs.setString("urlSendCode", configData.urlSendCode);
    prefs.setBool("isWithToken", configData.isWithToken);
    prefs.setString("urlHeader", configData.urlHeader);
    prefs.setString("urlGetToken", configData.urlGetToken);
  }

  static Future<String> getUserSecretToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("secretToken")!;
  }

  static Future<String> getUserUrlHeader() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("urlHeader") ?? 'egob_scan_token';
  }

  static Future<String?> getConfigUrlSendCode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("urlSendCode");
  }

  static Future<bool> getConfigIsWithToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("isWithToken") ?? false;
  }

  static Future<bool> getConfigSendCodeAutomatically() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("sendCodeAutomatically") ?? false;
  }

  static Future<String?> getConfigUrlGetToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("urlGetToken");
  }
}

