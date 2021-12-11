import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SingUp extends StatefulWidget {
  const SingUp({Key? key}) : super(key: key);

  @override
  _SingUpState createState() => _SingUpState();
}

class _SingUpState extends State<SingUp> {
  var value;
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController repassController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  setprefs(String id, String name, String email, String owner) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("id", id);
    await pref.setString("name", name);
    await pref.setString("email", email);
    await pref.setString("owner", owner);
  }

  final singUpinfo = "http://10.0.2.2:3000/users/singup";
  Future singUp() async {
    if (passController.text == repassController.text) {
      var response = await http.post(Uri.parse(singUpinfo),
          body: jsonEncode({
            "name": nameController.text,
            "email": emailController.text,
            "password": passController.text,
            "usertype": value
          }),
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json'
          });
      var responsbody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        try {
          await setprefs(responsbody['result']['insertId'].toString(),
              nameController.text, emailController.text, value.toString());
        } catch (e) {
          print(e);
        }
        print(value);
        if (value.toString() == "0") {
          print(value);
          Navigator.pushReplacementNamed(context, "drivermainpage");
        } else {
          print(value);
          Navigator.pushReplacementNamed(context, "onermainpage");
        }
      } else {
        print("error");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.only(top: 70),
                // width: size.width,
                height: size.height / 10,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: Colors.brown.withOpacity(.3),
                ),
                child: Center(
                    child: Text(
                  " انشاء حساب جديد  ",
                  style: TextStyle(fontSize: 25),
                )),
              ),
              Container(
                width: size.width,
                margin: EdgeInsets.only(top: 200),
                child: Column(
                  children: [
                    Center(
                      child: Container(
                        width: size.width / 1.2,
                        child: TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2, color: Colors.redAccent),
                                  borderRadius: BorderRadius.circular(20)),
                              icon: Icon(Icons.person),
                              hintText: "اسم المستخدم",
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2, color: Colors.redAccent),
                                  borderRadius: BorderRadius.circular(20))),
                          keyboardType: TextInputType.name,
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 30)),
                    Container(
                      width: size.width / 1.2,
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 2, color: Colors.redAccent),
                                borderRadius: BorderRadius.circular(20)),
                            icon: Icon(Icons.email),
                            hintText: "البريد الالكتروني ",
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
                        controller: passController,
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
                    Padding(padding: EdgeInsets.only(top: 30)),
                    Container(
                      width: size.width / 1.2,
                      child: TextFormField(
                        controller: repassController,
                        obscureText: true,
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 2, color: Colors.redAccent),
                                borderRadius: BorderRadius.circular(20)),
                            icon: Icon(Icons.lock),
                            hintText: " اعد كلمة المرور ",
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 2, color: Colors.redAccent),
                                borderRadius: BorderRadius.circular(20))),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 30)),
                    Container(
                      width: size.width / 2.8,

                      decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.circular(20)),
                      // margin: EdgeInsets.only(right: 20),
                      height: 50,
                      child: Center(
                        child: DropdownButton<String>(
                          onChanged: (_value) => {
                            // print(_value.toString()),
                            setState(() {
                              value = null;
                              value = _value;
                              print(value);
                            })
                          },
                          items: [
                            DropdownMenuItem<String>(
                              value: "1",
                              child: Center(
                                child: Text(' مالك '),
                              ),
                            ),
                            DropdownMenuItem<String>(
                              value: "0",
                              child: Center(
                                child: Text(" حاجز "),
                              ),
                            ),
                          ],
                          hint: Text(" نوع الحساب "),
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 20)),
                    Container(
                        width: 200,
                        height: 50,
                        child: OutlinedButton.icon(
                          onPressed: singUp,
                          icon: Icon(
                            Icons.login,
                          ),
                          label: Text("تسجيل الدخول"),
                        )),
                    Padding(padding: EdgeInsets.only(top: 20)),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, 'login'),
                      child: Container(
                        child: Text(
                          "LogIn ",
                          style:
                              TextStyle(fontSize: 25, color: Colors.blueGrey),
                        ),
                        decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(width: 1))),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 20)),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
