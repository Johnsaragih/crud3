import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:crudmysql3/home.dart';
import 'package:http/http.dart' as http;
import 'package:crudmysql3/modal/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(),
  ));
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

enum LoginStatus { notSignin, SignIn}

class _LoginState extends State<Login> {

LoginStatus _loginStatus = LoginStatus.notSignin;
String username, password; 
  
  final _key = new GlobalKey<FormState>();
  bool _secureText = true;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  check() {
    final form = _key.currentState;
    if(form.validate()) {
      form.save();
      login();
    }
  }

  login() async {
    final response = await http.post(BaseUrl.login,body: {"username":username, "password":password});
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    String usernameAPI = data['username'];
    String namaAPI = data['nama'];
    String id = data['id'];

    if(value ==1) {
      setState(() {
        _loginStatus =LoginStatus.SignIn;
        savePref(value, usernameAPI,namaAPI, id);          
      });
      print(pesan);
    } else {
      print(pesan);
    }


  }

  savePref(int value, String username, String nama, String id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", value);
      preferences.setString("nama", nama);
      preferences.setString("username", username);
      preferences.setString("id", id);

    });
  }

  var value ;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getInt("value");
      _loginStatus = value == 1 ? LoginStatus.SignIn : LoginStatus.notSignin;
    });

  }

  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", null);
      preferences.commit();
      _loginStatus = LoginStatus.notSignin;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  
  @override
  Widget build(BuildContext context) {

    switch (_loginStatus) {
    case LoginStatus.notSignin:
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _key,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            TextFormField(
              validator: (e) {
                if(e.isEmpty) {
                  return "Please insert";
                }
              },
              onSaved: (e) => username=e,
              decoration: InputDecoration(
                labelText: "Username",
              ),
            ),
            TextFormField(
              obscureText: _secureText,
              onSaved: (e)=> password=e,
              decoration: InputDecoration(
                labelText: "Password",
                suffixIcon: IconButton(
                  onPressed: showHide,
                  icon: Icon(_secureText ? Icons.visibility_off : Icons.visibility),
                )
              ),
            ),
            MaterialButton(
              onPressed: () {
                check();
              },
              child: Text("Login"),

            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)));
              },
              child: Text(
                "Create new account",
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),


    );
    break; 
    case LoginStatus.SignIn:
    
    
    }  
  }
}

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
String username, password, nama;
final _key = new GlobalKey<FormState>();
bool _securedText = true;

showHide() {
  setState(() {
    _securedText = !_securedText;
  });
}

check() {
  final form = _key.currentState;
  if(form.validate()) {
    form.save();
    save();
  }
}

save() async {
  final response = await http.post(BaseUrl.login,
  body: {"nama": nama, "username": username, "password":password});
  final data = jsonDecode(response.body);
  int value = data['value'];
  String pesan = data['message'];
  if(value ==1) {
    setState(() {
      Navigator.pop(context);
    });
  }else {
    print(pesan);
  }
}

 @override
 Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _key,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            TextFormField(
              validator: (e) {
                if(e.isEmpty) {
                  return "please fulnane";
                }
              },
              onSaved: (e) =>nama=e,
              decoration: InputDecoration(
                labelText: 
              ),
            )
          ],
        ),
      ),     
    );
  }


}