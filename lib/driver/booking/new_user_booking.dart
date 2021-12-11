import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:http/http.dart' as http;
import 'package:parking_booking/driver/booking/show_parking.dart';

class NewBooking extends StatefulWidget {
  const NewBooking({Key? key}) : super(key: key);

  @override
  _NewBookingState createState() => _NewBookingState();
}

class _NewBookingState extends State<NewBooking> {
  bool isSave = false;
  String? desc;
  String _startdate = "Not set";
  String _starttime = "Not set";

  String _enddate = "Not set";
  String _endtime = "Not set";
  String saveInfoUrl = "http://10.0.2.2:3000/booking/newbooking";
  Future save() async {
    var response = await http.post(Uri.parse(saveInfoUrl),
        body: jsonEncode({
          "startdate": _startdate,
          "starttime": _starttime,
          "enddate": _enddate,
          "endtime": _endtime,
          // "parkingId": parking_id
          "parkingId": _myparking
        }),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json'
        });
    var responsbody = jsonDecode(response.body);
    var data = responsbody['result'];
    List jsondata = data as List;
    print(jsondata.runtimeType);
    if (response.statusCode == 200) {
      return jsondata;
    } else {
      print("error");
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("الحجوزات الجديدة"),
      ),
      body: Container(
          height: size.height,
          width: size.width,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(padding: EdgeInsets.only(top: 20)),
                  cityWidget(size),
                  Padding(padding: EdgeInsets.only(top: 20)),
                  areaWidget(size),
                  Padding(padding: EdgeInsets.only(top: 20)),
                  parkinginArea(size),
                  Padding(padding: EdgeInsets.only(top: 20)),
                  if (_parkinList != null)
                    Container(
                        height: size.height / 2.5,
                        width: size.width / 1.5,
                        decoration: BoxDecoration(
                            color: Colors.blueAccent.withOpacity(.5),
                            borderRadius: BorderRadius.circular(18)),
                        child: Center(
                          child: Column(
                            children: [
                              Text(
                                ":الوصف",
                                style: TextStyle(fontSize: 25),
                              ),
                              Padding(padding: EdgeInsets.only(top: 30)),
                              Text(
                                desc.toString(),
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black38),
                              ),
                            ],
                          ),
                        ))
                  else
                    Text("الرجاء اختيار المنطقة المراد الوقوف فيها"),
                  Padding(padding: EdgeInsets.only(top: 30)),
                  Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        // color: Colors.blueGrey,
                        height: 300,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(padding: EdgeInsets.only(left: 50)),
                            Center(
                              child: Text(
                                "ادخل تاريخ بداية الحجز",
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                              elevation: 4.0,
                              onPressed: () {
                                DatePicker.showDatePicker(context,
                                    showTitleActions: true,
                                    minTime: DateTime(2000, 1, 1),
                                    maxTime: DateTime(2022, 12, 31),
                                    onConfirm: (DateTime date) {
                                  print('confirm $date');
                                  _startdate =
                                      '${date.year}-${date.month}-${date.day}';
                                  print(_startdate);
                                  setState(() {});
                                },
                                    currentTime: DateTime.now(),
                                    locale: LocaleType.en);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 50.0,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Container(
                                          child: Row(
                                            children: <Widget>[
                                              Icon(
                                                Icons.date_range,
                                                size: 18.0,
                                                color: Colors.teal,
                                              ),
                                              Text(
                                                " $_startdate",
                                                style: TextStyle(
                                                    color: Colors.teal,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18.0),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    Text(
                                      "  Change",
                                      style: TextStyle(
                                          color: Colors.teal,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0),
                                    ),
                                  ],
                                ),
                              ),
                              color: Colors.white,
                            ),
                            Padding(padding: EdgeInsets.only(left: 10)),
                            RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                              elevation: 4.0,
                              onPressed: () {
                                DatePicker.showTimePicker(context,
                                    // theme: DatePickerTheme(
                                    //   containerHeight: 210.0,
                                    // ),
                                    showTitleActions: true, onConfirm: (time) {
                                  print('confirm $time');
                                  _starttime =
                                      '${time.hour}:${time.minute}:${time.second}';
                                  print(_starttime);
                                  setState(() {});
                                },
                                    currentTime: DateTime.now(),
                                    locale: LocaleType.en);
                                setState(() {});
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 50.0,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Container(
                                          child: Row(
                                            children: <Widget>[
                                              Icon(
                                                Icons.access_time,
                                                size: 18.0,
                                                color: Colors.teal,
                                              ),
                                              Text(
                                                " $_starttime",
                                                style: TextStyle(
                                                    color: Colors.teal,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18.0),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    Text(
                                      "  Change",
                                      style: TextStyle(
                                          color: Colors.teal,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0),
                                    ),
                                  ],
                                ),
                              ),
                              color: Colors.white,
                            ),
                            Padding(padding: EdgeInsets.only(left: 100)),
                            Text("ادخل تاريخ نهاية الحجز",
                                style: TextStyle(fontSize: 20)),
                            Padding(padding: EdgeInsets.only(right: 50)),
                            RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                              elevation: 4.0,
                              onPressed: () {
                                DatePicker.showDatePicker(context,
                                    showTitleActions: true,
                                    minTime: DateTime(2000, 1, 1),
                                    maxTime: DateTime(2022, 12, 31),
                                    onConfirm: (date) {
                                  print('confirm $date');
                                  _enddate =
                                      '${date.year}-${date.month}-${date.day}';
                                  print(_enddate);
                                  setState(() {});
                                },
                                    currentTime: DateTime.now(),
                                    locale: LocaleType.en);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 50.0,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Container(
                                          child: Row(
                                            children: <Widget>[
                                              Icon(
                                                Icons.date_range,
                                                size: 18.0,
                                                color: Colors.teal,
                                              ),
                                              Text(
                                                " $_enddate",
                                                style: TextStyle(
                                                    color: Colors.teal,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18.0),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    Text(
                                      "  Change",
                                      style: TextStyle(
                                          color: Colors.teal,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0),
                                    ),
                                  ],
                                ),
                              ),
                              color: Colors.white,
                            ),
                            Padding(padding: EdgeInsets.only(left: 20)),
                            RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                              elevation: 4.0,
                              onPressed: () {
                                DatePicker.showTimePicker(context,
                                    theme: DatePickerTheme(
                                      containerHeight: 210.0,
                                    ),
                                    showTitleActions: true, onConfirm: (time) {
                                  print('confirm $time');
                                  _endtime =
                                      '${time.hour}:${time.minute}:${time.second}';
                                  print(_endtime);
                                  setState(() {});
                                },
                                    currentTime: DateTime.now(),
                                    locale: LocaleType.en);
                                setState(() {});
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 50.0,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Container(
                                          child: Row(
                                            children: <Widget>[
                                              Icon(
                                                Icons.access_time,
                                                size: 18.0,
                                                color: Colors.teal,
                                              ),
                                              Text(
                                                " $_endtime",
                                                style: TextStyle(
                                                    color: Colors.teal,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18.0),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    Text(
                                      "  Change",
                                      style: TextStyle(
                                          color: Colors.teal,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0),
                                    ),
                                  ],
                                ),
                              ),
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 20)),
                    ],
                  ),

                  //
                  Container(
                      // color: Colors.blueGrey,
                      width: 200,
                      height: 50,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          print(_mycity);
                          if (_startdate == "Not set" ||
                              _starttime == "Not set" ||
                              _enddate == "Not set" ||
                              _endtime == "Not set" ||
                              _mycity == null ||
                              _myparking == null ||
                              _myarea == null) {
                            print("ok");
                          } else {
                            save();
                            print(_parkinList);
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (cotext) {
                              return ShowParking(
                                parkingId: _myparking,
                                startdate: _startdate,
                                starttime: _starttime,
                                enddate: _enddate,
                                endtime: _endtime,
                              );
                            }));
                          }
                        },
                        icon: Icon(
                          Icons.local_parking,
                        ),
                        label: Text(
                          " عرض المواقف ",
                          style: TextStyle(fontSize: 18),
                        ),
                      )),
                ],
              ),
            ),
          )),
    );
  }

  String? _mycity;
  List? _cityList;
  final getCityUri = "http://10.0.2.2:3000/booking/getcity";
  Future getcity() async {
    var response = await http.get(Uri.parse(getCityUri));
    if (response.statusCode == 200) {
      var resbonsbody = jsonDecode(response.body);
      var data = resbonsbody['result'];
      List jsondata = data as List;

      setState(() {
        _cityList = jsondata;
      });
      // print(_cityList);
    } else {
      print("ok" + response.body);
    }
  }

  Widget cityWidget(Size size) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.blueAccent.withOpacity(.3)),
      width: size.width / 1.2,
      padding: EdgeInsets.only(left: 15, right: 15, top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                disabledColor: Colors.blueAccent,
                alignedDropdown: true,
                child: DropdownButton<String>(
                  focusColor: Colors.blueAccent,
                  dropdownColor: Colors.blueAccent,
                  value: _mycity,
                  iconSize: 30,
                  icon: (null),
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                  hint: Text("اختر المدينة"),
                  onChanged: (newValue) {
                    setState(() {
                      _mycity = newValue;
                      _myarea = null;
                      _myparking = null;
                    });
                    _getArea();
                  },
                  items: _cityList?.map((item) {
                        // print(item.runtimeType);
                        return new DropdownMenuItem(
                          child: new Text(item['city_name']),
                          value: item['city_id'].toString(),
                        );
                      }).toList() ??
                      [],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  final areaInfo = "http://10.0.2.2:3000/users/area";
  List? _areaList;
  String? _myarea;
  Future _getArea() async {
    var response = await http.post(Uri.parse(areaInfo),
        body: jsonEncode({"city": _mycity}),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json'
        });
    var responsbody = jsonDecode(response.body);
    var data = responsbody['result'];
    if (response.statusCode == 200) {
      var responsbody = jsonDecode(response.body);
      var data = responsbody['result'] as List;
      setState(() {
        _areaList = data;
        // print(_areaList);
      });
    }
  }

  Widget areaWidget(Size size) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.blueAccent.withOpacity(.3)),
      width: size.width / 1.2,
      padding: EdgeInsets.only(left: 15, right: 15, top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                disabledColor: Colors.blueAccent,
                alignedDropdown: true,
                child: DropdownButton<String>(
                  focusColor: Colors.blueAccent,
                  dropdownColor: Colors.blueAccent,
                  value: _myarea,
                  iconSize: 30,
                  icon: (null),
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                  hint: Text("اختر الحي"),
                  onChanged: (newValue) {
                    setState(() {
                      _myarea = newValue;
                      _myparking = null;
                      // print(_myarea);
                      _getParking();
                    });
                  },
                  items: _areaList?.map((item) {
                        return new DropdownMenuItem(
                          child: new Text(item['area_name']),
                          value: item['area_id'].toString(),
                        );
                      }).toList() ??
                      [],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  final parkingInfo = "http://10.0.2.2:3000/booking/selectparking";
  List? _parkinList;
  String? _myparking;
  Future _getParking() async {
    var response = await http.post(Uri.parse(parkingInfo),
        body: jsonEncode({"areaId": _myarea}),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json'
        });
    var responsbody = jsonDecode(response.body);
    var data = responsbody['result'];
    // print(responsbody);
    if (response.statusCode == 200) {
      var responsbody = jsonDecode(response.body);
      var data = responsbody['result'] as List;
      setState(() {
        _parkinList = data;
      });
      // print(_parkinList);
    }
  }

  Widget parkinginArea(Size size) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.blueAccent.withOpacity(.3)),
      width: size.width / 1.2,
      padding: EdgeInsets.only(left: 15, right: 15, top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                disabledColor: Colors.blueAccent,
                alignedDropdown: true,
                child: DropdownButton<String>(
                  focusColor: Colors.blueAccent,
                  dropdownColor: Colors.blueAccent,
                  value: _myparking,
                  iconSize: 30,
                  icon: (null),
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                  hint: Text("اختر الموقف"),
                  onChanged: (newValue) {
                    setState(() {
                      _myparking = newValue;
                      print(_myparking);

                      print(desc);
                    });
                  },
                  items: _parkinList?.map((item) {
                        setState(() {
                          desc = item['parking_description'];
                        });
                        return new DropdownMenuItem(
                          child: new Text(item['parking_name']),
                          value: item['parkin_id'].toString(),
                          onTap: () {
                            setState(() {
                              desc = item['parking_description'];
                            });
                          },
                        );
                      }).toList() ??
                      [],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    getcity();
    // TODO: implement initState
    super.initState();
  }
}
