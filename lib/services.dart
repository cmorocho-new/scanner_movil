import 'package:flutter_app/trasient.dart';
import 'package:flutter_app/user_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<UserData> connectDeviceScanner(urlGetToken) async {
  print(urlGetToken);
  final response = await http.get(urlGetToken)
      .timeout(Duration(seconds: 10));
  if (response.statusCode == 200){
    var secretToken = json.decode(response.body)['secret_token'];
    if(secretToken != null){
      return UserData.decodeToken(secretToken);
    }
  }
  throw Exception("Error al intentar obtener el Scan Token");
}

Future<String> sendCodeScanned(urlSendCode) async {
  // verifica si tiene token
  Map<String, String> headers = {};
  bool isWithToken = await SettingsRepository.getConfigIsWithToken();
  if (isWithToken){
      String customHeader = await SettingsRepository.getUserUrlHeader();
      String secretSoket = await SettingsRepository.getUserSecretToken();
      headers[customHeader] = secretSoket;
  }
  final response = await http.get(urlSendCode, headers: headers)
      .timeout(Duration(seconds: 10));
  if (response.statusCode == 200){
    return response.body;
  }
  throw Exception(response.body);
}