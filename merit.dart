import 'package:driver_integrated/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:getwidget/getwidget.dart';
import 'package:driver_integrated/my_api_service.dart';
import 'package:driver_integrated/driver.dart';

String display_merit_value = "";

class Merit extends StatefulWidget {
  Map<String, dynamic> text = {};
  @override
  meritPageState createState() {
    return meritPageState();
  }
}

class meritPageState extends State<Merit> {
  Map<String, dynamic> meritMap = {};
  Driver driver = Driver();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Merit", style: const TextStyle(color: Colors.white),),
          backgroundColor: const Color.fromARGB(255, 255, 168, 0),
        ),
        body: SingleChildScrollView(
            child: Column(
              children: [
                _meritscore(),
                _show_withdrawable(),
                _filterRow(),
                _listheadings(),
                _meritlist(),
              ],
            )));
  }

  Future<List<dynamic>> initMerit() async {
    meritMap = await MyApiService.getMeritStatement(driver.id.toString());
    List<dynamic> meritData = meritMap["merits"];
    return meritData;
  }

  Future<Map<String, dynamic>> initWallet() async{
    final test = await MyApiService.getCommissionStatement(driver.id.toString());
    widget.text = test;
    return test;
  }

  //display merit score
  Widget _meritscore() {
    return FutureBuilder(
      future: initMerit(),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        return Container(
          margin: EdgeInsets.only(left: 50, right: 50, top: 20),
          padding: EdgeInsets.only(top: 15, bottom: 15),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black, width: 0.1),
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                )
              ]
          ),
          child: Column(
            children: [
              Container(
                height: 70,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _meritvalue(),
                  ],
                ),
              ),
              const Text("MERIT SCORE",
                style: TextStyle(fontSize: 20, color: Colors.orange),),
            ],
          ),
        );
      }
    );
  }

  //merit score value
  Widget _meritvalue() {
    if (meritMap["merit"].toString() != "null") {
      return Text(meritMap["merit"].toString(),
          style: const TextStyle(fontSize: 50, color: Colors.orange));
    } else {
      return const Text("Loading...",
          style: TextStyle(fontSize: 36, color: Colors.orange));
    }
  }

  //show withdrawable merit
  Widget _show_withdrawable() {
    return FutureBuilder(
        future: initWallet(),
        builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if(snapshot.hasData){
            return Padding(
                padding: EdgeInsets.only(top: 20, bottom: 20),
                child: Text("Amount withdrawable: RM ${widget.text["withdrawable_merit"].toString()}",
                  style: const TextStyle(fontSize: 20, color: Colors.orange),)
            );
          }else{
            return const Text("Loading");
          }
        }
    );
  }

  //filter row
  Widget _filterRow(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        YearFilterDropdown(),
        MonthFilterDropdown(),
        ResetFilterButton(),
      ],
    );
  }

  //filter row elements
  //filter dropdown year
  Widget YearFilterDropdown() {
    return Container(
      child: DropdownButton(
        value: year_value,
        items: year.map((String year) {
          return DropdownMenuItem(
            value: year,
            child: Text(year),
          );
        }).toList(),
        icon: const Icon(Icons.keyboard_arrow_down),
        onChanged: (String? newValue) {
          setState(() {
            year_value = newValue!;
          });
        },
      ),
    );
  }

  //filter dropdown month
  Widget MonthFilterDropdown() {
    return Container(
      child: DropdownButton(
        value: month_value,
        items: month.map((String month) {
          return DropdownMenuItem(
            value: month,
            child: Text(month),
          );
        }).toList(),
        icon: const Icon(Icons.keyboard_arrow_down),
        onChanged: (String? newValue) {
          setState(() {
            month_value = newValue!;
            if (month_value == "January") {
              month_value_num = 1;
            }else if (month_value == "February") {
              month_value_num = 2;
            }else if (month_value == "March") {
              month_value_num = 3;
            }else if (month_value == "April") {
              month_value_num = 4;
            }else if (month_value == "May") {
              month_value_num = 5;
            }else if (month_value == "June") {
              month_value_num = 6;
            }
          });
        },
      ),
    );
  }

  //filter reset button
  Widget ResetFilterButton(){
    return GFButton(
      color: Colors.orange,
      onPressed: () {
        setState(() {
          month_value = "--------";
          year_value = "----";
        });
      },
      child: Text("Reset",style: TextStyle(fontSize: 16),),
      shape: GFButtonShape.pills,
    );
  }

  //merit list headers
  Widget _listheadings() {
    return Container(
      height: 50,
      padding: EdgeInsets.only(left: 45, right: 50),
      child: Row(
        children: [
          Expanded(child: Text("Date")),
          Expanded(child: Text("Description")),
          Expanded(child: Text("Order ID")),
          Text("Points"),
        ],
      ),
    );
  }

  //show merit list depending on filter
  Widget _meritlist() {
    if (year_value != "----" && month_value == "--------") {
      return year_meritlist();
    } else if (year_value != "----" && month_value != "--------") {
      return month_meritlist();
    } else if (year_value == "----" && month_value != "--------") {
      return month_meritlist();
    } else {
      return default_meritlist();
    }
  }

  //default merit list
  Widget default_meritlist() {
    return FutureBuilder(
      future: initMerit(),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if(snapshot.hasData) {
          return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  height: 50,
                  padding: EdgeInsets.only(left: 45, right: 50),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text('${meritMap["merits"][index]["date"]}'),
                      ),
                      Expanded(
                        child: Text('${meritMap["merits"][index]["note"]}'),
                      ),
                      Expanded(
                        child: meritMap["merits"][index]["order_id"] == null ?
                          const Text("ad-hoc") :
                          Text('${meritMap["merits"][index]["order_id"]}'),
                      ),
                      Text('${meritMap["merits"][index]["points"]}p'),
                    ],
                  ),
                );
              }
          );
        }else{
          return const Text("Loading");
        }
      }
    );
  }

  //year filtered merit list
  Widget year_meritlist() {
    return FutureBuilder(
        future: initMerit(),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  if (meritMap["merits"][index]["date"].toString().substring(6, 8) == year_value.substring(2, 4)) {
                    return Container(
                        height: 50,
                        padding: EdgeInsets.only(left: 45, right: 50),
                        child: Row(
                          children: [
                            Expanded(child: Text(
                                '${meritMap["merits"][index]["date"]}'),),
                            Expanded(child: Text(
                                '${meritMap["merits"][index]["note"]}'),),
                            Expanded(child: Text(
                                '${meritMap["merits"][index]["order_id"]}'),),
                            Text('${meritMap["merits"][index]["points"]}p'),
                          ],
                        )
                    );
                  } else{
                    return SizedBox.shrink();
                  }
                }
            );
          }else{
            return const Text("Loading");
          }
        }
    );
  }

  //month filtered merit list
  Widget month_meritlist() {
    if (month_value == "July") {
      month_value_num = 7;
    } else if (month_value == "August") {
      month_value_num = 8;
    } else if (month_value == "September") {
      month_value_num = 9;
    } else if (month_value == "October"){
      month_value_num = 10;
    } else if(month_value == "November"){
      month_value_num = 11;
    } else if(month_value == "December"){
      month_value_num = 12;
    }
    return FutureBuilder(
      future: initMerit(),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if(snapshot.hasData) {
          return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                if (meritMap["merits"][index]["date"].toString().substring(3, 5) == month_value_num.toString()) {
                  return Container(
                    height: 50,
                    padding: EdgeInsets.only(left: 45, right: 50),
                    child: Row(
                      children: [
                      Expanded(child: Text('${meritMap["merits"][index]["date"]}'),),
                      Expanded(child: Text('${meritMap["merits"][index]["note"]}'),),
                      Expanded(child: Text('${meritMap["merits"][index]["order_id"]}'),),
                      Text('${meritMap["merits"][index]["points"]}p'),
                      ]
                    ));
                  }
                else{
                  return SizedBox.shrink();
                }
              }
          );
        }else{
          return const Text("Loading");
        }
      }
    );
  }
}

//year drop down list values
var month = [
  '--------',
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];
String month_value = '--------';

int month_value_num = 0;

//year drop down list values
var year = [
  '----',
  '2022',
  '2021',
  '2020',
  '2019',
  '2018',
];
String year_value = '----';