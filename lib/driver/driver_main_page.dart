import 'package:flutter/material.dart';
import 'package:parking_booking/driver/cancelbooking.dart';
import 'package:parking_booking/driver/showbookingforuser.dart';
// import 'package:parking_booking/driver/showbookingforuser.dart';
import 'package:parking_booking/driver/updatepersonalinfo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DriverMainPage extends StatelessWidget {
  const DriverMainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("السايق"),
        leading: Icon(Icons.person),
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
                            Navigator.pushNamed(context, 'newuserbooking');
                          },
                          child: Text(" حجز  "),
                        )),
                    Padding(padding: EdgeInsets.only(top: 30)),
                    Container(
                        width: 200,
                        height: 50,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return ShowBookingsOfUser();
                            }));
                          },
                          child: Text(" الحجوزات السابقة "),
                        )),
                    Padding(padding: EdgeInsets.only(top: 30)),
                    Container(
                        width: 200,
                        height: 50,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return CancelBooking();
                            }));
                          },
                          child: Text(" الغاء حجز  "),
                        )),
                    Padding(padding: EdgeInsets.only(top: 30)),
                    Container(
                        width: 200,
                        height: 50,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return UpDatePersonalInfo();
                            }));
                          },
                          child: Text(" تعديل البيانات الشخصية "),
                        )),
                    Padding(padding: EdgeInsets.only(top: 30)),
                    Container(
                        width: 200,
                        height: 50,
                        child: OutlinedButton(
                          onPressed: () async {
                            SharedPreferences pref =
                                await SharedPreferences.getInstance();
                            pref.clear();
                            Navigator.pushReplacementNamed(context, 'login');
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
