import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SingIn extends StatefulWidget {
  const SingIn({Key? key}) : super(key: key);

  @override
  _SingInState createState() => _SingInState();
}

class _SingInState extends State<SingIn> {
  String? singemail;
  String? singowner;
  bool isSing = false;
  getpref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    singemail = pref.getString("email");
    singowner = pref.getString("owner");
    print("ok");
    if (singemail != null) {
      if (singowner == "1") {
        Navigator.pushReplacementNamed(context, "onermainpage");
      } else {
        Navigator.pushReplacementNamed(context, "drivermainpage");
      }
    }
  }

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  setprefs(String id, String name, String email, String owner) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("id", id);
    await pref.setString("name", name);
    await pref.setString("email", email);
    await pref.setString("owner", owner);
  }

  final String logInuri = "http://10.0.2.2:3000/users/login";
  Future login() async {
    try {
      var response = await http.post(Uri.parse(logInuri),
          body: jsonEncode({"email": email.text, "password": password.text}),
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json'
          });
      var responsbody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        setprefs(
            responsbody['result'][0]['user_id'].toString(),
            responsbody['result'][0]['user_name'],
            responsbody['result'][0]['email'],
            responsbody['result'][0]['user_type'].toString());
      }
      if (responsbody['result'][0]['user_type'].toString() == "1") {
        Navigator.pushReplacementNamed(context, "onermainpage");
      } else {
        Navigator.pushReplacementNamed(context, "drivermainpage");
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getpref();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
      width: size.width,
      height: size.height,
      child: SingleChildScrollView(
        child: Stack(children: [
          Container(
            margin: EdgeInsets.only(top: 70),
            width: size.width,
            height: size.height / 10,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: Colors.brown.withOpacity(.3),
            ),
            child: Center(
                child: Text(
              " تسجيل الدخول ",
              style: TextStyle(
                fontSize: 25,
              ),
            )),
          ),
          Column(
            children: [
              Stack(children: [
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: size.height / 2.4),
                    width: size.width,
                    height: size.height / 3,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: size.width / 1.2,
                            child: TextFormField(
                              controller: email,
                              // obscureText: true,
                              decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 2, color: Colors.redAccent),
                                      borderRadius: BorderRadius.circular(20)),
                                  icon: Icon(Icons.person),
                                  hintText: " E-mail ",
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 2, color: Colors.redAccent),
                                      borderRadius: BorderRadius.circular(20))),
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(top: 30)),
                          Container(
                            width: size.width / 1.2,
                            child: TextFormField(
                              controller: password,
                              obscureText: true,
                              decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 2, color: Colors.redAccent),
                                      borderRadius: BorderRadius.circular(20)),
                                  icon: Icon(Icons.lock),
                                  hintText: "كلمة المرور ",
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 2, color: Colors.redAccent),
                                      borderRadius: BorderRadius.circular(20))),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ]),
              Container(
                  width: 200,
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: login,
                    icon: Icon(
                      Icons.login,
                    ),
                    label: Text("تسجيل الدخول"),
                  )),
              SizedBox(width: 100, height: 50),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, 'singup'),
                child: Container(
                  child: Text(
                    "Create Account",
                    style: TextStyle(fontSize: 25, color: Colors.blueGrey),
                  ),
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(width: 1))),
                ),
              ),
            ],
          ),
        ]),
      ),
    ));
  }
}
