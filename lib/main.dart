import 'package:flutter/material.dart';
import 'package:flutter_app/services.dart';
import 'package:flutter_app/trasient.dart';
import 'package:flutter_app/user_preferences.dart';
import 'package:qrscan/qrscan.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'e-Scan Code',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'e-Scan Code'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<CodeData> _listCodes = [];

  @override
  void initState() {
    super.initState();

  }

  void clickOptions(int item) async {
    switch (item) {
      case 0:
        String urlGetToken = await SettingsRepository.getConfigUrlGetToken();
        if (urlGetToken != null ) {
          scan().then((tempSoketCode) {
            urlGetToken = urlGetToken.replaceAll('{tempCode}', tempSoketCode);
            connectDeviceScanner(urlGetToken)
                .then((userData) {
                  SettingsRepository.setUserData(userData);
                }).catchError((error) => showToast(error.toString(), Colors.red));
          });
        }else{
          showToast("Falta configurar el campo UrlGetToken", Colors.red);
        }
        break;
      case 1:
        setState(() {
          _listCodes.clear();
        });
        showToast("Codigos eliminados", Colors.grey);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          PopupMenuButton<int>(
            onSelected: (item) => clickOptions(item),
            itemBuilder: (context) => [
              PopupMenuItem<int>(value: 0, child: Text('Scan token')),
              PopupMenuItem<int>(value: 1, child: Text('Delete all')),
            ],
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _listViewCodes(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          String urlSendCode = await SettingsRepository.getConfigUrlSendCode();
          bool sendCodeAutomatically = await SettingsRepository.getConfigSendCodeAutomatically();
          scan().then((codeScanned) {
            setState((){
              _listCodes.insert(0, CodeData(null, codeScanned, ""));
            });
            if (sendCodeAutomatically) {
              urlSendCode = urlSendCode.replaceAll("{code}", codeScanned);
              sendCodeScanned(urlSendCode).then((result) {
                setState((){
                  _listCodes[0].dataOtenida = result;
                });
              }).catchError((error) => showToast(error.toString(), Colors.red));
            }
          });
      },
        tooltip: 'Code Sacan',
        label: Text('SCAN CODE'),
        icon: Icon(Icons.fullscreen),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      persistentFooterButtons: <Widget>[
          IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.of(context).push(_createRoute());
              }),
      ],// This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _listViewCodes() => Expanded(
    child: Card( child: ListView.builder(
      itemCount: _listCodes.length,
      itemBuilder: (context, index) => Card(
        elevation: 6,
        margin: EdgeInsets.all(10),
        child: ListTile(
              leading: Icon(Icons.view_week, size: 40.0,),
              title: Text(_listCodes[index].codigo),
              subtitle: Text(_listCodes[index].dataOtenida),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    _listCodes.removeAt(index);
                  });
                },
          ),
        ),
      ),
    )
    ),
  );
}

class MyConfigPage extends StatefulWidget {
  MyConfigPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _FromConfigData createState() => _FromConfigData();
}

class _FromConfigData extends State<MyConfigPage> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController urlSendCode = new TextEditingController();
  TextEditingController urlHeader = new TextEditingController();
  TextEditingController urlGetToken = new TextEditingController();
  bool _isTokenAcess = false;
  bool _sendCodeAutomatically = false;

  @override
  void initState() {
    _obtenerConfiguracionActual();
  }

  _obtenerConfiguracionActual() async {
    var configData = await SettingsRepository.getConfigData();
    this.urlSendCode.text = configData.urlSendCode;
    this.urlHeader.text = configData.urlHeader;
    this.urlGetToken.text = configData.urlGetToken;
    setState(() {
      if (configData.isWithToken != null)
        this._isTokenAcess = configData.isWithToken;
      if (configData.sendCodeAutomatically != null)
        this._sendCodeAutomatically = configData.sendCodeAutomatically;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Configuracion"),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(5.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                formItemsDesign(
                  null,
                  CheckboxListTile(
                    value: _sendCodeAutomatically,
                    title: Text("Enivar Codigo Automaticamente"),
                    onChanged: (bool value) {
                      setState(() {
                        _sendCodeAutomatically = value;
                      });
                    },
                  ),
                ),
                formItemsDesign(
                    Icons.link,
                    TextFormField(
                      controller: urlSendCode,
                      decoration: new InputDecoration(
                        labelText: 'Url Send Code',
                        counterText: "EJ: https://territoriosinteligentes.net/{code}"
                      ),
                      keyboardType: TextInputType.url,
                      validator: validateSendCode,
                    )
                ),
                formItemsDesign(
                  null,
                  CheckboxListTile(
                    value: _isTokenAcess,
                    title: Text("Tiene Scan Token"),
                    onChanged: (bool value) {
                       setState(() {
                         _isTokenAcess = value;
                       });
                    },
                  ),
                ),
                formItemsDesign(
                    Icons.link,
                    TextFormField(
                        controller: urlGetToken,
                        decoration: new InputDecoration(
                            labelText: 'Url Get Token',
                            counterText: "GET METHOD"
                        ),
                        keyboardType: TextInputType.url,
                        validator: validateFiledToken,
                    )
                ),
                formItemsDesign(
                    Icons.link,
                    TextFormField(
                        controller: urlHeader,
                        decoration: new InputDecoration(
                            labelText: 'Url Custom Header',
                            counterText: "EJ: egob_scan_token"
                        ),
                        keyboardType: TextInputType.text,
                        validator: validateFiledToken,
                    )
                ),
                Center(child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        SettingsRepository.setConfigData(ConfigData(
                            _sendCodeAutomatically,
                            urlSendCode.text,
                            _isTokenAcess,
                            urlHeader.text,
                            urlGetToken.text
                        ));
                        Navigator.pop(context);
                        showToast("Configuracion guardada", Colors.grey);
                      }
                    },
                    child: Text('GUARDAR CONFIGURACION'),
                  ),
                ),),
              ],
            ),
          ),
    )));
  }

  String validateSendCode(String value) {
    if (_sendCodeAutomatically && value.length == 0) {
      return "";
    } else {
      return null;
    }
  }

  String validateFiledToken(String value) {
    if (_isTokenAcess && value.length == 0) {
      return "";
    } else {
      return null;
    }
  }

  formItemsDesign(icon, item) {
    if(icon != null){
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 2),
        child: Card(child: ListTile(leading: Icon(icon), title: item)),
      );
    }else{
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 2),
        child: Card(child: item),
      );
    }
  }
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => MyConfigPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

showToast(msg, color) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: color,
      textColor: Colors.black,
      fontSize: 16.0
  );
}
