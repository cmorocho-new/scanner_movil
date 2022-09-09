import 'package:flutter_app/trasient.dart';
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
        prefs.getString("username"),
        prefs.getString("database"),
        prefs.getString("secretToken"),
    );
  }

  static Future<ConfigData> getConfigData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return ConfigData(
        prefs.getBool("sendCodeAutomatically"),
        prefs.getString("urlSendCode"),
        prefs.getBool("isWithToken"),
        prefs.getString("urlHeader"),
        prefs.getString("urlGetToken")
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
    return prefs.getString("secretToken");
  }

  static Future<String> getUserUrlHeader() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String customHeader = prefs.getString("urlHeader");
    if(customHeader == null){
      customHeader = 'egob_scan_token';
    }
    return customHeader;
  }

  static Future<String> getConfigUrlSendCode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("urlSendCode");
  }

  static Future<bool> getConfigIsWithToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isWithToken = prefs.getBool("isWithToken");
    if (isWithToken == null){
      isWithToken = false;
    }
    return isWithToken;
  }

  static Future<bool> getConfigSendCodeAutomatically() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool sendCodeAutomatically = prefs.getBool("sendCodeAutomatically");
    if (sendCodeAutomatically == null){
      sendCodeAutomatically = false;
    }
    return sendCodeAutomatically;
  }

  static Future<String> getConfigUrlGetToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("urlGetToken");
  }
}

