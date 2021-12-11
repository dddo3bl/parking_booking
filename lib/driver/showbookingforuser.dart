import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ShowBookingsOfUser extends StatelessWidget {
  const ShowBookingsOfUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("الحجوزات السابقة"),
      ),
      body: Bookings(size: size),
    );
  }
}

class Bookings extends StatelessWidget {
  const Bookings({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  // set id(String? id) {}

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height,
      width: size.width,
      child: Column(
        children: [
          Padding(padding: EdgeInsets.only(top: 30)),
          Container(
            height: size.height / 1.3,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  FutureBuilder(
                      future: getBookings(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, i) {
                                return Container(
                                  height: 250,
                                  child: Card(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Text("رقم الحجز"),
                                          Text(snapshot.data[i]['bokkings']
                                              .toString()),
                                          Padding(
                                              padding:
                                                  EdgeInsets.only(top: 10)),
                                          Text("بداية الحجز"),
                                          Text(snapshot.data[i]['start_date']
                                              .toString()),
                                          Padding(
                                              padding:
                                                  EdgeInsets.only(top: 10)),
                                          Text("نهاية الحجز"),
                                          Text(snapshot.data[i]['end_date']
                                              .toString()),
                                          Center(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(snapshot.data[i]
                                                        ['totalprice']
                                                    .toString()),
                                                Text(" : السعر "),
                                              ],
                                            ),
                                          ),
                                          Center(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(snapshot.data[i]
                                                        ['totalhours']
                                                    .toString()),
                                                Text(" : عدد الساعات"),
                                              ],
                                            ),
                                          ),
                                          Divider(),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              });
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      })
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  final bookingsOfUser = "http://10.0.2.2:3000/booking/userbookings";
  Future getBookings() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var id = pref.getString("id");
    var response = await http.post(Uri.parse(bookingsOfUser),
        body: jsonEncode({"userId": id}),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json'
        });
    var responsbody = jsonDecode(response.body);
    List jsonData = responsbody['result'];
    if (response.statusCode == 200) {
      print(jsonData);
      return jsonData;
    } else {
      print("chick the connection");
    }
  }
}
