import 'package:flutter/material.dart';
import 'package:parking_booking/driver/booking/new_user_booking.dart';
import 'package:parking_booking/driver/driver_main_page.dart';
import 'package:parking_booking/owner/add_parking.dart';
import 'package:parking_booking/owner/owner_main_page.dart';
import 'package:parking_booking/singin_singup/singin.dart';
import 'package:parking_booking/singin_singup/singup.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        'login': (context) => SingIn(),
        'singup': (context) => SingUp(),
        'onermainpage': (context) => OwnerMainPage(),
        'drivermainpage': (context) => DriverMainPage(),
        'addpaking': (context) => AddParkingPage(),
        'newuserbooking': (context) => NewBooking(),
      },
      home: SingIn(),
    );
  }
}
