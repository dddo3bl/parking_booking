import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UpDatePersonalInfo extends StatefulWidget {
  const UpDatePersonalInfo({Key? key}) : super(key: key);

  @override
  _UpDatePersonalInfoState createState() => _UpDatePersonalInfoState();
}

List? tttt;
TextEditingController username = TextEditingController();
TextEditingController email = TextEditingController();
TextEditingController password = TextEditingController();

class _UpDatePersonalInfoState extends State<UpDatePersonalInfo> {
  final personalInfoUri = "http://10.0.2.2:3000/booking/getpersonalinfo";
  String? id;
  Future getPersonalInfo() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    id = pref.getString("id");
    var respons = await http.post(Uri.parse(personalInfoUri),
        body: jsonEncode({"userId": id}),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json'
        });
    var responsbody = jsonDecode(respons.body);
    List data = responsbody['row'] as List;
    print(data.runtimeType);
    if (respons.statusCode == 200) {
      setState(() {
        tttt = data;
      });
      return data;
    } else {
      print("problem");
    }
  }

  @override
  void initState() {
    getPersonalInfo();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    print(tttt);
    return Scaffold(
      appBar: AppBar(
        title: Text("البيانات الشخصية"),
        centerTitle: true,
      ),
      body: tttt == null
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : personalInformation(size),
    );
  }

  Container personalInformation(Size size) {
    return Container(
      height: size.height,
      width: size.width,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: size.width / 3),
              child: Center(
                child: Row(
                  children: [
                    Text(
                      tttt?[0]['user_name'],
                      style: TextStyle(fontSize: 20),
                    ),
                    Padding(padding: EdgeInsets.only(left: 20)),
                    Text(
                      "اسم السائق",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
            Container(
                width: 400,
                child: TextFormField(
                  controller: username,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18)),
                      hintText: "لتعديل الاسم "),
                )),
            Padding(padding: EdgeInsets.only(top: 10)),
            Container(
              margin: EdgeInsets.only(left: size.width / 8),
              child: Center(
                child: Row(
                  children: [
                    Text(
                      tttt?[0]['email'],
                      style: TextStyle(fontSize: 20),
                    ),
                    Padding(padding: EdgeInsets.only(left: 20)),
                    Text(
                      "البريد الاكتروني",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
            Container(
                width: 400,
                child: TextFormField(
                  controller: email,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18)),
                      hintText: "لتعديل البريد الالكتروني "),
                )),
            Padding(padding: EdgeInsets.only(top: 10)),
            Text("كلمة المرور  ", style: TextStyle(fontSize: 20)),
            Container(
                width: 400,
                child: TextFormField(
                  controller: password,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18)),
                      hintText: "لتعديل كلمة المرور "),
                )),
            Padding(padding: EdgeInsets.only(top: 100)),
            OutlinedButton.icon(
              label: Text(
                "حفظ",
                style: TextStyle(fontSize: 30),
              ),
              onPressed: () {
                print(email.text);
                print(password.text);
                upDateInfo();
              },
              icon: Icon(Icons.save),
            )
          ],
        ),
      ),
    );
  }

  final UpdateInfoUri = "http://10.0.2.2:3000/booking/upDateInfo";
  Future upDateInfo() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    id = pref.getString("id");

    var respons = await http.post(Uri.parse(UpdateInfoUri),
        body: jsonEncode({
          "userId": id,
          "username":
              username.text != "" ? username.text : tttt?[0]['user_name'],
          "email": email.text != "" ? email.text : tttt?[0]['email'],
          "password": password.text != "" ? password.text : tttt?[0]['password']
        }),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json'
        });
    if (respons.statusCode == 200) {
      print("ok");
    } else {
      print("not oky");
    }
  }
}
