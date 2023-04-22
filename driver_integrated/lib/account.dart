import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'merit.dart';
import 'package:driver_integrated/wallet.dart';
import 'package:driver_integrated/my_location_service.dart';
import 'package:driver_integrated/driver.dart';
import 'package:driver_integrated/my_api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

Driver driver = Driver();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: AccountPage(title: 'Flutter Demo Home Page'),
    );
  }
}

class AccountPage extends StatefulWidget {
  const AccountPage({super.key, required this.title});
  final String title;

  @override
  State<AccountPage> createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<AccountPage> {
  MyLocationService myLocationService = MyLocationService(driver.id);
  //NotificationService notificationService = NotificationService();

  Future<void> unsetPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("username", "null");
    prefs.setString("password", "null");
    prefs.setString("tempusername", "null");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(16.0),
          child: Container(
            height: 4.0,
          ),
        ),
        title: SizedBox(
            child: Padding(
              padding: EdgeInsets.only(top: 50, bottom: 30),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(' | ',
                      style: TextStyle(
                          color: Colors.orange, fontWeight: FontWeight.w900, fontSize: 32.0)),
                  Flexible(
                    child: Text("Account", style: TextStyle(fontSize: 30.0, color: Colors.black),),
                  ),
                ],
              ),
            )
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _wallet(context),
            _merit(context),
            _logout(context),
          ],
        ),
      ),
    );
  }

  Widget _wallet(context)
  {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: Colors.grey.shade100,
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            Navigator.push(context,MaterialPageRoute(builder:(context) => Wallet()));
          },
          child: Container(
              padding: const EdgeInsets.all(35),
              width: 350,
              height: 190,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topLeft ,
                    child: Text(
                      "WALLET",
                      style: TextStyle(fontSize: 30.0),
                    ),
                  ),
                  Align(
                      alignment: Alignment.bottomRight,
                      child: Icon(Icons.account_balance_wallet, color: Colors.orange.shade400, size: 50,)),
                ],
              )

          ),
        ),
      ),
    );
  }

  Widget _merit(context)
  {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: Colors.grey.shade100,
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            Navigator.push(context,MaterialPageRoute(builder:(context) => Merit()));
          },
          child: Container(
              padding: const EdgeInsets.all(35),
              width: 350,
              height: 190,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topLeft ,
                    child: Text(
                      "MERIT",
                      style: TextStyle(fontSize: 30.0),
                    ),
                  ),
                  Align(
                      alignment: Alignment.bottomRight,
                      child: Icon(Icons.star_rate_rounded, color: Colors.orange.shade400, size: 55,)),
                ],
              )

          ),
        ),
      ),
    );
  }

  Widget _logout(context)
  {
    return SizedBox(
        width:160,
        height:50,
        child:GFButton(
          color: Colors.orange.shade400,
          borderSide: BorderSide(
            color: Colors.orange.shade400,
            style: BorderStyle.solid,
            width: 1,
          ),
          onPressed: () async {
            if(driver.status == "on") {
              driver.status = "off";
              myLocationService.stop();
              await MyApiService.updateDriverOnOff(driver.id, "off",driver.jwtToken);
            }
            //notificationService.stop();
            await unsetPref();
            Navigator.popUntil(context,ModalRoute.withName(Navigator.defaultRouteName));
          },
          shape: GFButtonShape.pills,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const[
              Text("Logout",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
            ],
          ),
        )
    );
  }

}