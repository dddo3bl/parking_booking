import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersonalInfoOwner extends StatefulWidget {
  const PersonalInfoOwner({Key? key}) : super(key: key);

  @override
  _PersonalInfoOwnerState createState() => _PersonalInfoOwnerState();
}

class _PersonalInfoOwnerState extends State<PersonalInfoOwner> {
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  List? tttt;

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
    return Scaffold(
      appBar: AppBar(
        title: Text("البيانات الشخصية"),
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
                  // obscureText: false,
                  keyboardType: TextInputType.name,
                  controller: username,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18)),
                    hintText: "لتعديل الاسم ",
                    suffixIcon: IconButton(
                      onPressed: username.clear,
                      icon: Icon(Icons.clear),
                    ),
                  ),
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
                  keyboardType: TextInputType.emailAddress,
                  controller: email,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18)),
                    hintText: "لتعديل البريد الالكتروني ",
                    suffixIcon: IconButton(
                      onPressed: email.clear,
                      icon: Icon(Icons.clear),
                    ),
                  ),
                )),
            Padding(padding: EdgeInsets.only(top: 10)),
            Text("كلمة المرور  ", style: TextStyle(fontSize: 20)),
            Container(
                width: 400,
                child: TextFormField(
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  controller: password,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18)),
                    hintText: "لتعديل كلمة المرور ",
                    suffixIcon: IconButton(
                      onPressed: password.clear,
                      icon: Icon(Icons.clear),
                    ),
                  ),
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
      password.clear();
      email.clear();
      username.clear();
    } else {
      print("not oky");
    }
  }
}
