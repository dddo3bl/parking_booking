import 'package:flutter/material.dart';
import 'package:parking_booking/owner/bookingslist.dart';
import 'package:parking_booking/owner/updatepersonalinfoowner.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OwnerMainPage extends StatefulWidget {
  const OwnerMainPage({Key? key}) : super(key: key);

  @override
  _OwnerMainPageState createState() => _OwnerMainPageState();
}

class _OwnerMainPageState extends State<OwnerMainPage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.person),
        title: Text("المالك"),
        centerTitle: true,
      ),
      body: Container(
        width: size.width,
        height: size.height,
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        width: 200,
                        height: 50,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, 'addpaking');
                          },
                          child: Text("اضافة موقف"),
                        )),
                    Padding(padding: EdgeInsets.only(top: 30)),
                    Container(
                        width: 200,
                        height: 50,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return BookingsList();
                            }));
                          },
                          child: Text("قائمة الحجوزات "),
                        )),
                    Padding(padding: EdgeInsets.only(top: 30)),
                    Container(
                        width: 200,
                        height: 50,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return PersonalInfoOwner();
                            }));
                          },
                          child: Text("تعديل البيانات الشخصية "),
                        )),
                    Padding(padding: EdgeInsets.only(top: 30)),
                    Container(
                        width: 200,
                        height: 50,
                        child: OutlinedButton(
                          onPressed: () async {
                            Navigator.pushReplacementNamed(context, 'login');
                            SharedPreferences pref =
                                await SharedPreferences.getInstance();
                            pref.clear();
                          },
                          child: Text(" تسجيل الخروج "),
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
