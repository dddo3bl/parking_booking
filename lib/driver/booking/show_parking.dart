import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ShowParking extends StatelessWidget {
  final parkingId;
  final startdate;
  final starttime;
  final enddate;
  final endtime;
  ShowParking(
      {Key? key,
      this.parkingId,
      this.startdate,
      this.starttime,
      this.enddate,
      this.endtime})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    print(parkingId);
    return Scaffold(
      appBar: AppBar(
        title: Text("المواقف"),
        centerTitle: true,
      ),
      body: Container(
        height: size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 500,
                child: SingleChildScrollView(
                  child: FutureBuilder(
                    future: showParking(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        return GridView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: snapshot.data.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisSpacing: 1,
                              crossAxisSpacing: 3,
                              crossAxisCount: 2,
                            ),
                            itemBuilder: (context, i) {
                              return InkWell(
                                onTap: () async {
                                  print(startdate);
                                  var invo = await getprice();
                                  await confirmDialog(
                                      context,
                                      invo[1],
                                      invo[0],
                                      invo[2],
                                      invo[3],
                                      snapshot.data[i]['parking_num_id'],
                                      snapshot.data[i]['parking_index']);
                                },
                                child: Card(
                                  child: Column(children: [
                                    Text(snapshot.data[i]['parking_num_id']
                                        .toString()),
                                    Text(snapshot.data[i]['price_of_parking']
                                        .toString()),
                                  ]),
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
        ),
      ),
    );
  }

  Future<dynamic> confirmDialog(BuildContext context, var totalhours,
      var totalpricr, String start, String end, var prkingid, var indexpark) {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text('تأكيد الحجز'),
              content: Container(
                height: 120,
                child: Column(
                  children: [
                    Text("عدد الساعات : " + totalhours.toString()),
                    Text("السعر الاجمالي : " + totalpricr.toString()),
                    Text("تاريخ الدخول  : " + start),
                    Text("تاريخ الخروج : " + end),
                  ],
                ),
              ),
              actions: [
                FlatButton(
                  textColor: Colors.black,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('CANCEL'),
                ),
                FlatButton(
                  textColor: Colors.black,
                  onPressed: () async {
                    await confirmBooking(prkingid, indexpark, start, end,
                        totalpricr, totalhours);
                  },
                  child: Text('ACCEPT'),
                ),
              ],
            ));
  }

  final priceinfo = "http://10.0.2.2:3000/booking/price";
  Future getprice() async {
    var respnse = await http.post(Uri.parse(priceinfo),
        body: jsonEncode({
          "startdate": startdate,
          "starttime": starttime,
          "enddate": enddate,
          "endtime": endtime,
          "parkingId": parkingId
        }),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json'
        });
    var responsbody = jsonDecode(respnse.body);
    if (respnse.statusCode == 200) {
      print(responsbody);
      // var respnsbody = jsonDecode(response.body);
      var finalprice = responsbody['finalprice'];
      var difrent = responsbody['difrent'];
      var startbooking = responsbody['finalDatest'];
      var endbooking = responsbody['finalDateen'];
      List difpri = [finalprice, difrent, startbooking, endbooking];
      return difpri;
    }
  }

  String? id;
  final confirm = "http://10.0.2.2:3000/booking/confirmBoking";
  confirmBooking(var parkingid, var parkingindex, var startdate, var enddate,
      var totalprice1, var totalhours1) async {
    print(startdate);
    print(enddate);
    print(parkingindex);
    print(parkingid);
    SharedPreferences pref = await SharedPreferences.getInstance();
    id = pref.getString("id");
    var response = await http.post(Uri.parse(confirm),
        body: jsonEncode({
          "userId": id,
          "parkingId": parkingid,
          "parkingIndex": parkingindex,
          "startdate": startdate,
          "enddate": enddate,
          "totalprice": totalprice1,
          "totalhours": totalhours1,
        }),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json'
        });
    print(response.body);
  }

  final String showEmptyParkings = "http://10.0.2.2:3000/booking/newbooking";
  Future showParking() async {
    print(parkingId);
    var response = await http.post(Uri.parse(showEmptyParkings),
        body: jsonEncode({
          "parkingId": parkingId,
          "startdate": startdate,
          "starttime": starttime,
          "enddate": enddate,
          "endtime": endtime
        }),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json'
        });
    var respnsbody = jsonDecode(response.body);
    List jsonData = respnsbody['result'];
    if (response.statusCode == 200) {
      return jsonData;
    } else {
      print("not ok");
    }
  }
}
