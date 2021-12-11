import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddParkingPage extends StatefulWidget {
  const AddParkingPage({Key? key}) : super(key: key);

  @override
  _AddParkingPageState createState() => _AddParkingPageState();
}

class _AddParkingPageState extends State<AddParkingPage> {
  TextEditingController parkingName = TextEditingController();
  TextEditingController parkingnum = TextEditingController();
  TextEditingController descrition = TextEditingController();
  TextEditingController price = TextEditingController();

  final cityInfo = "http://10.0.2.2:3000/users/city";
  List? _cityList;
  String? _mycity;
  Future _getcity() async {
    var response = await http.get(Uri.parse(cityInfo));
    var responsbody = jsonDecode(response.body);
    var data = responsbody['result'];
    if (response.statusCode == 200) {
      var responsbody = jsonDecode(response.body);
      var data = responsbody['result'] as List;
      print(data);
      setState(() {
        _cityList = data;
      });
    }
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
        print(_areaList);
      });
    }
  }

  @override
  void initState() {
    _getcity();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("اضافة موقف للسيارات"),
      ),
      body: Container(
        height: size.height,
        width: size.width,
        child: Center(
          child: Container(
            height: size.height,
            // margin: EdgeInsets.only(bottom: 400),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(padding: EdgeInsets.only(top: size.height / 15)),
                  Container(
                    height: 50,
                    width: size.width / 1.5,
                    child: Center(
                      child: TextFormField(
                        controller: parkingName,
                        decoration: InputDecoration(
                            icon: Icon(Icons.local_parking),
                            hintText: "اسم الموقف",
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide(
                                  width: 1.5, color: Colors.blueGrey),
                            )),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 20)),
                  Container(
                    width: size.width / 2,
                    child: Center(
                      child: Text(
                        "اختر المدينة",
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 10)),
                  cityWidget(size),
                  Padding(padding: EdgeInsets.only(top: 20)),
                  Container(
                    width: size.width / 2,
                    child: Center(
                      child: Text(
                        "اختر الحي",
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 10)),
                  areaWidget(size),
                  Padding(padding: EdgeInsets.only(top: 20)),
                  Container(
                    height: 50,
                    width: size.width / 1.5,
                    child: Center(
                      child: TextFormField(
                        controller: parkingnum,
                        decoration: InputDecoration(
                            icon: Icon(Icons.format_list_numbered),
                            hintText: "عدد المواقف",
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide(
                                  width: 1.5, color: Colors.blueGrey),
                            )),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 20)),
                  Container(
                    height: 50,
                    width: size.width / 1.5,
                    child: Center(
                      child: TextFormField(
                        controller: price,
                        decoration: InputDecoration(
                            icon: Icon(Icons.format_list_numbered),
                            hintText: "سعر الموقف الواحد للساعة",
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide(
                                  width: 1.5, color: Colors.blueGrey),
                            )),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 20)),
                  Container(
                    height: 80,
                    width: size.width / 1.5,
                    child: Center(
                      child: TextFormField(
                        controller: descrition,
                        minLines: 2,
                        maxLines: 5,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          hintText: 'الوصف',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 20)),
                  Container(
                      width: 150,
                      height: 50,
                      color: Colors.blueGrey.withOpacity(.5),
                      child: OutlinedButton.icon(
                        onPressed: () {
                          save();
                        },
                        icon: Icon(
                          Icons.save,
                          color: Colors.black,
                        ),
                        label: Text(
                          "حفظ ",
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
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
                      print(_myarea);
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

  final saveInfoUri = "http://10.0.2.2:3000/users/addparking";
  Future save() async {
    print(parkingnum.text);
    SharedPreferences pref = await SharedPreferences.getInstance();
    var id = pref.getString("id");
    print(id);
    var response = await http.post(Uri.parse(saveInfoUri),
        body: jsonEncode({
          "id": id,
          "parkingname": parkingName.text,
          "cityid": _mycity,
          "area": _myarea,
          "parkingnum": parkingnum.text,
          "descrition": descrition.text,
          "price": price.text
        }),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json'
        });
    if (response.statusCode == 200) {
      print("add it secss");
      Navigator.pushReplacementNamed(context, "onermainpage");
    } else {
      print("error: " + response.body);
    }
  }

  // Widget showDilgate(){

  // }
}
