import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class BookingsList extends StatelessWidget {
  const BookingsList({Key? key}) : super(key: key);

  @override
  final bookingsListInfoUrl = "http://10.0.2.2:3000/booking/getBookingsList";
  Future getBookingsList() async {
    String? id;
    SharedPreferences pref = await SharedPreferences.getInstance();
    id = pref.getString("id");
    print(id);
    var respons = await http.post(Uri.parse(bookingsListInfoUrl),
        body: jsonEncode({"userId": id}),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json'
        });
    var responsbody = jsonDecode(respons.body);
    List jsondata = responsbody['result'];
    List rowdate = responsbody['row'];
    print(jsondata);
    print([jsondata, rowdate]);
    // print(responsbody);
    if (respons.statusCode == 200) {
      print("ok");
      return jsondata;
    } else {
      print("error connction");
    }
  }

  converdatetime(String starttime) {
    DateTime dateTime = DateTime.parse(starttime);
    return dateTime.toString();
  }

  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("قائمة الحجوزات"),
      ),
      body: Container(
        height: size.height,
        width: size.width,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: size.height / 1.2,
                  width: size.width,
                  color: Colors.amberAccent,
                  margin: EdgeInsets.only(top: 30),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        FutureBuilder(
                            future: getBookingsList(),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                return ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (context, i) {
                                      return Container(
                                        height: 200,
                                        // width: 400,
                                        child: Card(
                                          child: Column(
                                            children: [
                                              Container(
                                                margin:
                                                    EdgeInsets.only(right: 10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      snapshot.data[i]
                                                              ['parking_num_id']
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 20),
                                                    ),
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 20)),
                                                    Text(
                                                      "رقم الموقف",
                                                      style: TextStyle(
                                                          fontSize: 20),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                margin:
                                                    EdgeInsets.only(right: 10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      converdatetime(
                                                          snapshot.data[i]
                                                              ['start_date']),
                                                      style: TextStyle(
                                                          fontSize: 15),
                                                    ),
                                                    Text(
                                                      " : بداية الحجز",
                                                      style: TextStyle(
                                                          fontSize: 20),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                margin:
                                                    EdgeInsets.only(right: 10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      converdatetime(snapshot
                                                          .data[i]['end_date']),
                                                      style: TextStyle(
                                                          fontSize: 15),
                                                    ),
                                                    Text(
                                                      " : نهاية الحجز",
                                                      style: TextStyle(
                                                          fontSize: 20),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                margin:
                                                    EdgeInsets.only(right: 10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      snapshot.data[i]
                                                              ['totalhours']
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 15),
                                                    ),
                                                    Text(
                                                      " : عدد الساعات ",
                                                      style: TextStyle(
                                                          fontSize: 20),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                margin:
                                                    EdgeInsets.only(right: 10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      snapshot.data[i]
                                                              ['totalprice']
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 15),
                                                    ),
                                                    Text(
                                                      " : المبلغ الاجمالي  ",
                                                      style: TextStyle(
                                                          fontSize: 20),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
