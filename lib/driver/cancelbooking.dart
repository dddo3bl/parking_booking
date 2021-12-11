import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CancelBooking extends StatelessWidget {
  const CancelBooking({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("الغاء الحجوزات"),
      ),
      body: ShowBookgings(size: size),
    );
  }
}

class ShowBookgings extends StatelessWidget {
  const ShowBookgings({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      height: size.height,
      width: size.width,
      child: Column(
        children: [
          Container(
            color: Colors.amberAccent,
            height: size.height / 1.3,
            child: SingleChildScrollView(
              child: FutureBuilder(
                future: getBookings(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, i) {
                          return InkWell(
                            onTap: () {
                              _showDialog(
                                  context, snapshot.data[i]['bokkings']);
                              print("ok");
                            },
                            child: Card(
                              child: Container(
                                child: Column(
                                  children: [
                                    Text("رقم الحجز"),
                                    Text(snapshot.data[i]['bokkings']
                                        .toString()),
                                    Padding(padding: EdgeInsets.only(top: 10)),
                                    Text("بداية الحجز"),
                                    Text(snapshot.data[i]['start_date']
                                        .toString()),
                                    Padding(padding: EdgeInsets.only(top: 10)),
                                    Text("نهاية الحجز"),
                                    Text(snapshot.data[i]['end_date']
                                        .toString()),
                                    Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(snapshot.data[i]['totalprice']
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
                                          Text(snapshot.data[i]['totalhours']
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
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDialog(BuildContext context, var iid) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: new Text("Alert!!"),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                deleteBooking(iid);
                Navigator.of(context).pop();
              },
              child: Text('الغاء الحجز'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('تراجع'),
            ),
          ],
        );
      },
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

  final cancelBooking = "http://10.0.2.2:3000/booking/cancelbooking";
  Future deleteBooking(var bookingnum) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var id = pref.getString("id");
    var response = await http.post(Uri.parse(cancelBooking),
        body: jsonEncode({"bookingnum": bookingnum}),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json'
        });

    var responsbody = jsonDecode(response.body);
    print(responsbody);
  }
}
