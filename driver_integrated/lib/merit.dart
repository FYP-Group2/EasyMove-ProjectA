// import 'package:flutter/material.dart';
// import 'package:getwidget/getwidget.dart';
// import 'package:driver_integrated/my_api_service.dart';
// import 'package:driver_integrated/driver.dart';
// import 'package:driver_integrated/NavBar.dart';
// import 'package:intl/intl.dart';

// String display_merit_value = "";

// class Merit extends StatefulWidget {
//   Map<String, dynamic> text = {};
//   @override
//   meritPageState createState() {
//     return meritPageState();
//   }
// }

// class meritPageState extends State<Merit> {
//   Map<String, dynamic> meritMap = {};
//   Driver driver = Driver();

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       child: Scaffold(
//         appBar: AppBar(
//           iconTheme: const IconThemeData(
//             color: Colors.black, //change your color here
//             size: 35,
//           ),
//           elevation: 0,
//           bottom: PreferredSize(
//             preferredSize: const Size.fromHeight(20.0),
//             child: Container(
//               color: Colors.orangeAccent,
//               height: 4.0,
//             ),
//           ),
//           centerTitle: true,
//           title: const Padding(
//             padding: EdgeInsets.only(top: 10.0),
//             child: Text(
//               "Merit",
//               style: TextStyle(color: Colors.black, fontSize: 25.0),

//             ),
//           ),
//           backgroundColor: Colors.white,
//         ),
//         body: SingleChildScrollView(
//           child: Column(
//             children: [
//               _meritscore(),
//               _show_withdrawable(),
//               _withdraw_merit_button(),
//               _filterRow(),
//               _listheadings(),
//               _meritlist(),
//             ],
//           ),
//         ),
//       ),
//       onWillPop: () async{
//         Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => NavBar(
//                   currentPage: PageItem.Account,
//                 )));
//         return true;
//       });
//   }

//   Future<List<dynamic>> initMerit() async {
//     meritMap = await MyApiService.getMeritStatement(driver.id.toString(), driver.jwtToken);
//     List<dynamic> meritData = meritMap["merits"];
//     return meritData;
//   }

//   //display merit score
//   Widget _meritscore() {
//     return FutureBuilder(
//         future: initMerit(),
//         builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
//           return Container(
//             margin: EdgeInsets.only(left: 50, right: 50, top: 20),
//             padding: EdgeInsets.only(top: 15, bottom: 25),
//             decoration: BoxDecoration(
//                 color: Colors.white,
//                 border: Border.all(color: Colors.black, width: 0.1),
//                 borderRadius: BorderRadius.circular(5.0),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.5),
//                     spreadRadius: 5,
//                     blurRadius: 7,
//                   )
//                 ]
//             ),
//             child: Column(
//               children: [
//                 Container(
//                   height: 90,
//                   child: Row(
//                     mainAxisSize: MainAxisSize.max,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       _meritvalue(),
//                     ],
//                   ),
//                 ),
//                 const Text("MERIT SCORE",
//                   style: TextStyle(fontSize: 20, color: Colors.orange),),
//               ],
//             ),
//           );
//         }
//     );
//   }

//   //merit score value
//   Widget _meritvalue() {
//     if (meritMap["merit"].toString() != "null") {
//       return Text(meritMap["merit"].toString(),
//           style: const TextStyle(fontSize: 50, color: Colors.orange));
//     } else {
//       return const Text("Loading...",
//           style: TextStyle(fontSize: 36, color: Colors.orange));
//     }
//   }

//   //show withdrawable merit
//   Widget _show_withdrawable() {
//     return FutureBuilder(
//         future: initMerit(),
//         builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
//           if(snapshot.hasData){
//             return Padding(
//                 padding: EdgeInsets.only(top: 20),
//                 child: Text("Amount withdrawable: RM ${meritMap["withdrawable_merit"].toString()}",
//                   style: const TextStyle(fontSize: 20, color: Colors.orange),)
//             );
//           }else{
//             return const Text("Loading");
//           }
//         }
//     );
//   }

//   //withdraw merit button
//   Widget _withdraw_merit_button() {
//     return Padding(
//       padding: EdgeInsets.only(top:5),
//       child: GFButton(
//         color: Colors.orange,
//         onPressed: () async {
//           //call api - notice page
//           await MyApiService.convertMerit(driver.id, driver.jwtToken).then((value){
//             if(value == true){
//               showSuccessDialog();
//               Navigator.push(context,MaterialPageRoute(builder:(context) => Merit()));
//             }else{
//               showErrorDialog();
//             }
//           });
//         },
//         padding: const EdgeInsets.only(left: 20, right: 20),
//         child: Text("Withdraw",style: TextStyle(fontSize: 16)),
//         shape: GFButtonShape.pills,
//       ),
//     );
//   }

//   //filter row
//   Widget _filterRow(){
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         YearFilterDropdown(),
//         MonthFilterDropdown(),
//         ResetFilterButton(),
//       ],
//     );
//   }

//   //filter row elements
//   //filter dropdown year
//   Widget YearFilterDropdown() {
//     return Container(
//       child: DropdownButton(
//         value: year_value,
//         items: year.map((String year) {
//           return DropdownMenuItem(
//             value: year,
//             child: Text(year),
//           );
//         }).toList(),
//         icon: const Icon(Icons.keyboard_arrow_down),
//         onChanged: (String? newValue) {
//           setState(() {
//             year_value = newValue!;
//           });
//         },
//       ),
//     );
//   }

//   //filter dropdown month
//   Widget MonthFilterDropdown() {
//     return DropdownButton<String>(
//       items: monthMap.map((description, value) {
//         return MapEntry(description,
//             DropdownMenuItem<String>(
//               value: description,
//               child: Text(description),
//             ));
//       })
//           .values
//           .toList(),
//       value: month_value,
//       onChanged: (String? newValue) {
//         if (newValue != null) {
//           setState(() {
//             month_value = newValue;
//           });
//         }
//       },
//     );
//   }

//   //filter reset button
//   Widget ResetFilterButton(){
//     return GFButton(
//       color: Colors.orange,
//       onPressed: () {
//         setState(() {
//           month_value = "--------";
//           year_value = "----";
//         });
//       },
//       child: Text("Reset",style: TextStyle(fontSize: 16),),
//       shape: GFButtonShape.pills,
//     );
//   }

//   //merit list headers
//   Widget _listheadings() {
//     return Container(
//       height: 50,
//       padding: EdgeInsets.only(left: 45, right: 50),
//       child: Row(
//         children: [
//           Expanded(child: Text("Date")),
//           Expanded(child: Text("Description")),
//           Expanded(child: Text("Order ID")),
//           Text("Points"),
//         ],
//       ),
//     );
//   }

//   //show merit list depending on filter
//   Widget _meritlist() {
//     if (year_value != "----" && month_value == "--------") {
//       return year_meritlist();
//     } else if (year_value != "----" && month_value != "--------") {
//       return month_meritlist();
//     } else if (year_value == "----" && month_value != "--------") {
//       return month_meritlist();
//     } else {
//       return default_meritlist();
//     }
//   }

//   //default merit list (current month)
//   Widget default_meritlist() {
//     return FutureBuilder(
//         future: initMerit(),
//         builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
//           if(snapshot.hasData) {
//             DateTime now = new DateTime.now();
//             var formatter = new DateFormat('yyyy-MM-dd');
//             String formattedDate = formatter.format(now);
//             return ListView.builder(
//                 physics: const NeverScrollableScrollPhysics(),
//                 scrollDirection: Axis.vertical,
//                 shrinkWrap: true,
//                 itemCount: snapshot.data!.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   if (meritMap["merits"][index]["date"].toString().substring(6, 8) == formattedDate.substring(6,8)) {
//                     return Container(
//                       height: 50,
//                       padding: EdgeInsets.only(left: 45, right: 50),
//                       child: Row(
//                         children: [
//                           Expanded(
//                             child: Text('${meritMap["merits"][index]["date"]}'),
//                           ),
//                           Expanded(
//                             child: Text('${meritMap["merits"][index]["note"]}'),
//                           ),
//                           Expanded(
//                             child: meritMap["merits"][index]["order_id"] == null
//                                 ?
//                             const Text("ad-hoc")
//                                 :
//                             Text('${meritMap["merits"][index]["order_id"]}'),
//                           ),
//                           Text('${meritMap["merits"][index]["points"]}p'),
//                         ],
//                       ),
//                     );
//                   }else{
//                     return SizedBox.shrink();
//                   }
//                 }
//             );
//           }else{
//             return const Text("Loading");
//           }
//         }
//     );
//   }

//   //year filtered merit list
//   Widget year_meritlist() {
//     return FutureBuilder(
//         future: initMerit(),
//         builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
//           if (snapshot.hasData) {
//             return ListView.builder(
//                 physics: const NeverScrollableScrollPhysics(),
//                 scrollDirection: Axis.vertical,
//                 shrinkWrap: true,
//                 itemCount: snapshot.data!.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   if (meritMap["merits"][index]["date"].toString().substring(6, 8) == year_value.substring(2, 4)) {
//                     return Container(
//                         height: 50,
//                         padding: EdgeInsets.only(left: 45, right: 50),
//                         child: Row(
//                           children: [
//                             Expanded(child: Text(
//                                 '${meritMap["merits"][index]["date"]}'),),
//                             Expanded(child: Text(
//                                 '${meritMap["merits"][index]["note"]}'),),
//                             Expanded(child: Text(
//                                 '${meritMap["merits"][index]["order_id"]}'),),
//                             Text('${meritMap["merits"][index]["points"]}p'),
//                           ],
//                         )
//                     );
//                   } else{
//                     return SizedBox.shrink();
//                   }
//                 }
//             );
//           }else{
//             return const Text("Loading");
//           }
//         }
//     );
//   }

//   //month filtered merit list
//   Widget month_meritlist() {
//     return FutureBuilder(
//         future: initMerit(),
//         builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
//           if(snapshot.hasData) {
//             return ListView.builder(
//                 physics: const NeverScrollableScrollPhysics(),
//                 scrollDirection: Axis.vertical,
//                 shrinkWrap: true,
//                 itemCount: snapshot.data!.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   if (meritMap["merits"][index]["date"].toString().substring(3, 5) == monthMap[month_value].toString()) {
//                     return Container(
//                         height: 50,
//                         padding: EdgeInsets.only(left: 45, right: 50),
//                         child: Row(
//                             children: [
//                               Expanded(child: Text('${meritMap["merits"][index]["date"]}'),),
//                               Expanded(child: Text('${meritMap["merits"][index]["note"]}'),),
//                               Expanded(child: Text('${meritMap["merits"][index]["order_id"]}'),),
//                               Text('${meritMap["merits"][index]["points"]}p'),
//                             ]
//                         ));
//                   }
//                   else{
//                     return SizedBox.shrink();
//                   }
//                 }
//             );
//           }else{
//             return const Text("Loading");
//           }
//         }
//     );
//   }

//   showErrorDialog() async {
//     await Future.delayed(Duration(microseconds: 1));
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         content:
//         const Text("Insufficient Merit for Withdrawal"),
//         actions: <Widget>[
//           TextButton(
//             onPressed: () {
//               Navigator.of(ctx).pop();
//             },
//             child: Container(
//               color: Colors.orange,
//               padding: const EdgeInsets.all(14),
//               child: const Text("Okay", style: TextStyle(color: Colors.white)),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   showSuccessDialog() async {
//     await Future.delayed(Duration(microseconds: 1));
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         content:
//         const Text("Withdrawn Successfully"),
//         actions: <Widget>[
//           TextButton(
//             onPressed: () {
//               Navigator.of(ctx).pop();
//             },
//             child: Container(
//               color: Colors.orange,
//               padding: const EdgeInsets.all(14),
//               child: const Text("Done",
//                   style: TextStyle(color: Colors.white)),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   showError() async {
//     await Future.delayed(Duration(microseconds: 1));
//     showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text("Error"),
//             content: Text("HAHAHA"),
//             // actions: <Widget>[
//             //   GFButton(
//             //     child: Text("No"),
//             //     onPressed: ,
//             //   ),
//             //   FlatButton(child: Text("Yes")),
//             // ],
//           );
//         });
//   }
// }

// //year drop down list values
// const Map<String, int> monthMap = {'--------':0,
//   'January':1,
//   'February':2,
//   'March':3,
//   'April':4,
//   'May':5,
//   'June':6,
//   'July':7,
//   'August':8,
//   'September':9,
//   'October':10,
//   'November':11,
//   'December':12};


// String month_value = '--------';

// int month_value_num = 0;

// //year drop down list values
// var year = [
//   '----',
//   '2022',
//   '2021',
//   '2020',
//   '2019',
//   '2018',
// ];
// String year_value = '----';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:driver_integrated/driver.dart';
import 'package:driver_integrated/NavBar.dart';
import 'package:driver_integrated/screen_size.dart';
import 'package:driver_integrated/my_api_service.dart';


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
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.black, //change your color here
            size: 35,
          ),
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(20.0),
            child: Container(
              color: Colors.orangeAccent,
              height: 4.0,
            ),
          ),
          centerTitle: true,
          title: const Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Text(
              "Merit",
              style: TextStyle(color: Colors.black, fontSize: 25.0),

            ),
          ),
          backgroundColor: Colors.white,
        ),
        body: Stack(
          children: [
            Container(
              width: ScreenSize.screenWidth(context),
              height: ScreenSize.screenHeight(context),
              padding: EdgeInsets.symmetric(
                  horizontal: ScreenSize.screenWidth(context) * 0.05,
                  vertical: ScreenSize.screenHeight(context) * 0.02
              ),
              decoration: BoxDecoration(
                  color: Colors.white
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _meritscore(),
                    SizedBox(height: ScreenSize.screenHeight(context) * 0.02),
                    _show_withdrawable(),
                    SizedBox(height: ScreenSize.screenHeight(context) * 0.02),
                    _withdraw_merit_button(),
                    SizedBox(height: ScreenSize.screenHeight(context) * 0.02),
                    _filterRow(),
                    _listheadings(),
                    _meritlist(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      onWillPop: () async{
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NavBar(
                  currentPage: PageItem.Account,
                )));
        return true;
      });
  }

  Future<List<dynamic>> initMerit() async {
    meritMap = await MyApiService.getMeritStatement(driver.id.toString(), driver.jwtToken);
    List<dynamic> meritData = meritMap["merits"];
    return meritData;
  }

  //display merit score
  Widget _meritscore() {
    return FutureBuilder(
        future: initMerit(),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          return Container(
            width: ScreenSize.screenWidth(context) * 0.8,
            height: ScreenSize.screenWidth(context) * 0.4,
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
                color: Colors.white,
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _meritvalue(),
                Text(
                  "MERIT SCORE",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.orange
                  ),
                )
              ],
            ),
          );
        }
    );
  }

  //merit score value
  Widget _meritvalue() {
    if (meritMap["merit"].toString() != "null") {
      return Text(
          meritMap["merit"].toString(),
          style: const TextStyle(
              fontSize: 50,
              color: Colors.orange)
      );
    } else {
      return const Text(
          "Loading...",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 36,
              color: Colors.orange)
      );
    }
  }

  //show withdrawable merit
  Widget _show_withdrawable() {
    return FutureBuilder(
        future: initMerit(),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if(snapshot.hasData){
            return Text(
                "Amount withdrawable: RM ${meritMap["withdrawable_merit"].toString()}",
                style: const TextStyle(
                    fontSize: 20,
                    color: Colors.orange
                )
            );
          }else{
            return const Text("Loading");
          }
        }
    );
  }

  //withdraw merit button
  Widget _withdraw_merit_button() {
    return GFButton(
      color: Colors.orange,
      onPressed: () async {
        //call api - notice page
        await MyApiService.convertMerit(driver.id, driver.jwtToken).then((value){
          if(value == true){
            showSuccessDialog();
            Navigator.push(context,MaterialPageRoute(builder:(context) => Merit()));
          }else{
            showErrorDialog();
          }
        });
      },
      padding: EdgeInsets.all(10.0),
      child: Text("Withdraw",style: TextStyle(fontSize: 16)),
      shape: GFButtonShape.pills,
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
    return DropdownButton<String>(
      items: monthMap.map((description, value) {
        return MapEntry(description,
            DropdownMenuItem<String>(
              value: description,
              child: Text(description),
            ));
      })
          .values
          .toList(),
      value: month_value,
      onChanged: (String? newValue) {
        if (newValue != null) {
          setState(() {
            month_value = newValue;
          });
        }
      },
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
      margin: EdgeInsets.symmetric(horizontal: ScreenSize.screenWidth(context) * 0.05),
      child: Center(
        child: Row(
          children: [
            Expanded(child: Text("Date")),
            Expanded(child: Text("Description")),
            Expanded(child: Text("Order ID")),
            Text("Points"),
          ],
        ),
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

  //default merit list (current month)
  Widget default_meritlist() {
    return FutureBuilder(
        future: initMerit(),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if(snapshot.hasData) {
            DateTime now = new DateTime.now();
            var formatter = new DateFormat('yyyy-MM-dd');
            String formattedDate = formatter.format(now);
            return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  if (meritMap["merits"][index]["date"].toString().substring(6, 8) == formattedDate.substring(6,8)) {
                    return Container(
                      height: 50,
                      margin: EdgeInsets.symmetric(horizontal: ScreenSize.screenWidth(context) * 0.05),
                      child: Center(
                        child: Row(
                          children: [
                            Expanded(
                              child: Text('${meritMap["merits"][index]["date"]}'),
                            ),
                            Expanded(
                              child: Text('${meritMap["merits"][index]["note"]}'),
                            ),
                            Expanded(
                              child: meritMap["merits"][index]["order_id"] == null
                                  ?
                              const Text("ad-hoc")
                                  :
                              Text('${meritMap["merits"][index]["order_id"]}'),
                            ),
                            Text('${meritMap["merits"][index]["points"]}p'),
                          ],
                        ),
                      ),
                    );
                  }else{
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
                      margin: EdgeInsets.symmetric(horizontal: ScreenSize.screenWidth(context) * 0.05),
                        child: Center(
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
                        ),
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
                  if (meritMap["merits"][index]["date"].toString().substring(3, 5) == monthMap[month_value].toString()) {
                    return Container(
                        height: 50,
                        margin: EdgeInsets.symmetric(horizontal: ScreenSize.screenWidth(context) * 0.05),
                        child: Center(
                            child: Row(
                                children: [
                                  Expanded(child: Text('${meritMap["merits"][index]["date"]}'),),
                                  Expanded(child: Text('${meritMap["merits"][index]["note"]}'),),
                                  Expanded(child: Text('${meritMap["merits"][index]["order_id"]}'),),
                                  Text('${meritMap["merits"][index]["points"]}p'),
                                ]
                            )
                        ),
                    );
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

  showErrorDialog() async {
    await Future.delayed(Duration(microseconds: 1));
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        content:
        const Text("Insufficient Merit for Withdrawal"),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Container(
              color: Colors.orange,
              padding: const EdgeInsets.all(14),
              child: const Text("Okay", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  showSuccessDialog() async {
    await Future.delayed(Duration(microseconds: 1));
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        content:
        const Text("Withdrawn Successfully"),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Container(
              color: Colors.orange,
              padding: const EdgeInsets.all(14),
              child: const Text("Done",
                  style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  showError() async {
    await Future.delayed(Duration(microseconds: 1));
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("HAHAHA"),
            // actions: <Widget>[
            //   GFButton(
            //     child: Text("No"),
            //     onPressed: ,
            //   ),
            //   FlatButton(child: Text("Yes")),
            // ],
          );
        });
  }
}

//year drop down list values
const Map<String, int> monthMap = {'--------':0,
  'January':1,
  'February':2,
  'March':3,
  'April':4,
  'May':5,
  'June':6,
  'July':7,
  'August':8,
  'September':9,
  'October':10,
  'November':11,
  'December':12};


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