import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:driver_integrated/merit.dart';
import 'package:driver_integrated/wallet.dart';
import 'package:driver_integrated/my_location_service.dart';
import 'package:driver_integrated/driver.dart';
import 'package:driver_integrated/my_api_service.dart';
import 'package:driver_integrated/notification_service.dart';

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
  NotificationService notificationService = NotificationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
        backgroundColor: const Color.fromARGB(255, 255, 168, 0),
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
    return SizedBox(
        width: 300,
        height: 80,
        child: GFButton(
          color: Colors.orange,
          onPressed: () {
            Navigator.push(context,MaterialPageRoute(builder:(context) => Wallet()));
          },
          shape: GFButtonShape.pills,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset('assets/images/wallet.png'),
              const Text("Wallet",style:TextStyle(fontSize: 30)),
            ],
          ),
        )
    );
  }

  Widget _merit(context)
  {
    return SizedBox(
      height: 80,
      width: 300,
      child:GFButton(
        color: Colors.orange,
        onPressed: () {
          Navigator.push(context,MaterialPageRoute(builder:(context) => Merit()));
        },
        shape: GFButtonShape.pills,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset('assets/images/merit.png'),
            const Text("Merit",style: TextStyle(fontSize: 30),),
          ],
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
          color: Colors.orange,
          onPressed: () {
            if(driver.status == "on") {
              driver.status = "off";
              myLocationService.stop();
              MyApiService.updateDriverOnOff(driver.id, "off");
            }
            notificationService.stop();
            Navigator.popUntil(context,ModalRoute.withName(Navigator.defaultRouteName));
          },
          shape: GFButtonShape.pills,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const[
              Text("Logout",style: TextStyle(fontSize: 22),),
            ],
          ),
        )
    );
  }

}