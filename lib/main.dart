import 'package:flutter/material.dart';
import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'package:check_connection/notification.dart';
import 'package:overlay_support/overlay_support.dart';

void main() {
  runApp(checkConnection());
}

class checkConnection extends StatelessWidget {
  //const checkConnection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => OverlaySupport(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Color(0xffFFEBE5),
          ),
          home: HomePage(),
        ),
      );
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  StreamSubscription? subscription;

  @override
  void initState() {
    super.initState();

    subscription =
        Connectivity().onConnectivityChanged.listen(showConnectionNotification);
  }

  @override
  void dispose() {
    subscription!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFDEBE8),
      appBar: AppBar(
        title: Text("Check your Connection Here"), // display the app bar
      ),
      // create a button
      body: Center(
        child: ElevatedButton(
          style:
              ElevatedButton.styleFrom(padding: EdgeInsets.all(15.0)), // style
          child: Text(
            "Check Connection !",
            style: TextStyle(fontSize: 20),
          ),
          onPressed: () async {
            final status = await Connectivity().checkConnectivity();
            showConnectionNotification(status);
          },
        ),
      ),
    );
  }

  // define the showConnectionNotification fuc
  // which will tell us or give the notifi. that
  // whether we have an established connec. or not

  void showConnectionNotification(ConnectivityResult status) {
    final internetStatus = status != ConnectivityResult.none;
    final msg = internetStatus
        ? ' You have ${status.toString()}'
        : ' Oops, it seems You do not have an established internet connection !! \n Check Your connection';

    // setting the color of the notification
    // if the user has connection = green
    // otherwise red for no connection
    final notificationColor = internetStatus ? Colors.green : Colors.red;

    // validate by adding the alert box
    bool connectedToWiFi = (status == ConnectivityResult.wifi);
    bool connectedToMobile = (status == ConnectivityResult.mobile);
    if (!connectedToWiFi && connectedToMobile) {
      _showAlertMobile(context);
    } else if (!connectedToMobile && connectedToWiFi) {
      _showAlertWifi(context);
    } else {
      _showAlertError(context);
    }

    // call the notification.dart file and pass the values: color, and msg
    NotificationBar.showNotificationBar(context, msg, notificationColor);
  }

  void _showAlertMobile(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Colors.green,
              content: Text(
                "Connected to Mobile Data",
                style: TextStyle(fontSize: 20),
              ),
            ));
  }

  void _showAlertWifi(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Colors.blueAccent,
              content: Text(
                "Connected to WiFi",
                style: TextStyle(fontSize: 20),
              ),
            ));
  }

  void _showAlertError(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Colors.redAccent,
              content: Text(
                " Oops ! \n Try Again",
                style: TextStyle(fontSize: 20),
              ),
            ));
  }
}
