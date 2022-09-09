import 'package:jwt_decoder/jwt_decoder.dart';

class UserData {

  String _username;
  String _database;
  String _secretToken;

  UserData(this._username, this._database, this._secretToken);

  bool isTokenVlid(){
    return JwtDecoder.isExpired(this._secretToken);
  }

  factory UserData.decodeToken(String secretToken){
      Map<String, dynamic> decodedToken = JwtDecoder.decode(secretToken);
      return UserData(
        decodedToken['login'],
        decodedToken['database'],
        secretToken,
      );
  }

  String get secretToken => _secretToken;

  set secretToken(String value) {
    _secretToken = value;
  }

  String get database => _database;

  set database(String value) {
    _database = value;
  }

  String get username => _username;

  set username(String value) {
    _username = value;
  }
}

class ConfigData {

  String _urlSendCode;
  bool _isWithToken;
  String _urlHeader;
  String _urlGetToken;
  bool _sendCodeAutomatically;

  ConfigData(this._sendCodeAutomatically,
             this._urlSendCode,
             this._isWithToken,
             this._urlHeader,
             this._urlGetToken);

  bool get sendCodeAutomatically => _sendCodeAutomatically;

  set sendCodeAutomatically(bool value) {
    _sendCodeAutomatically = value;
  }

  String get urlGetToken => _urlGetToken;

  set urlGetToken(String value) {
    _urlGetToken = value;
  }

  String get urlHeader => _urlHeader;

  set urlHeader(String value) {
    _urlHeader = value;
  }

  bool get isWithToken => _isWithToken;

  set isWithToken(bool value) {
    _isWithToken = value;
  }

  String get urlSendCode => _urlSendCode;

  set urlSendCode(String value) {
    _urlSendCode = value;
  }

}

class CodeData {

  int id;
  String codigo;
  String dataOtenida;

  CodeData(this.id, this.codigo, this.dataOtenida);

  CodeData.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    codigo = map['codigo'];
    dataOtenida = map['dataOtenida'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{'codigo': codigo, 'dataOtenida': dataOtenida};
    if (id != null) map['id'] = id;
    return map;
  }

}