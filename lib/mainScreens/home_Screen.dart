import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_rider/mainScreens/earnings_Screen.dart';
import 'package:food_rider/mainScreens/history_screen.dart';
import 'package:food_rider/mainScreens/new_orders_screen.dart';
import 'package:food_rider/mainScreens/not_yet_delivered_screen.dart';
import 'package:food_rider/mainScreens/parcel_in_progress_screen.dart';

import '../assistantMethods/get_current_location.dart';
import '../authentication/auth_screen.dart';
import '../global/global.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Card makeDashboardItem(String title, IconData iconData, int index) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.all(8),
      child: Container(
        decoration: index == 0 || index == 3 || index == 4
            ? const BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.cyan, Colors.amber],
                    begin: FractionalOffset(0.0, 0.0),
                    end: FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp),
              )
            : const BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.redAccent, Colors.amber],
                    begin: FractionalOffset(0.0, 0.0),
                    end: FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp),
              ),
        child: InkWell(
          onTap: () {
            if (index == 0) {
              //new Avilable order
              Navigator.push(context,
                  MaterialPageRoute(builder: (c) => NewOrdersScreen()));
            }
            if (index == 1) {
              //Parcel in Progress
              Navigator.push(context,
                  MaterialPageRoute(builder: (c) => ParcelInProgress()));
            }
            if (index == 2) {
              //Not yet edlivberd
              Navigator.push(context,
                  MaterialPageRoute(builder: (c) => NotYetDeliveredScreen()));
            }
            if (index == 3) {
              //history
              Navigator.push(
                  context, MaterialPageRoute(builder: (c) => HistoryScreen()));
            }
            if (index == 4) {
              //total earning
              Navigator.push(context,
                  MaterialPageRoute(builder: (c) => const EarningScreen()));
            }
            if (index == 5) {
              firebaseAuth.signOut().then((value) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (c) => const AuthScreen()),
                    (route) => false);
              });
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            children: [
              const SizedBox(
                height: 50,
              ),
              Center(
                child: Icon(
                  iconData,
                  size: 40,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    UserLocation uLocation = UserLocation();
    uLocation.getCurrentLocation();
    getPerParcelDeliveryAmount();
    getRiderPreviousearnings();
  }

  getPerParcelDeliveryAmount() {
    FirebaseFirestore.instance
        .collection("perDelivery")
        .doc("mahi")
        .get()
        .then((snap) {
      perParcelDeliveryAmount = snap.data()!["amount"].toString();
    });
  }

  getRiderPreviousearnings() {
    FirebaseFirestore.instance
        .collection("riders")
        .doc(sharedPreferences!.getString("uid"))
        .get()
        .then((snap) {
      previousRiderEarnings = snap.data()!["earnings"].toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onBackButtenPressed(context),
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.cyan, Colors.amber],
                  begin: FractionalOffset(0.0, 0.0),
                  end: FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
          ),
          title: Text(
            "Rider: " +
                sharedPreferences!.getString(
                  "name",
                )!,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.width / 22,
                fontFamily: "Acme",
                letterSpacing: 2,
                color: Colors.black),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 1.0),
          child: GridView.count(
            crossAxisCount: 2,
            padding: const EdgeInsets.all(2),
            children: [
              makeDashboardItem("New Avilable Orders", Icons.assessment, 0),
              makeDashboardItem("Parcel in progress", Icons.airport_shuttle, 1),
              makeDashboardItem("Not Yet Delivered", Icons.location_history, 2),
              makeDashboardItem("History", Icons.done_all, 3),
              makeDashboardItem("Total Earning", Icons.monetization_on, 4),
              makeDashboardItem("LogOut", Icons.logout, 5),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackButtenPressed(BuildContext context) async {
    bool exitApp = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            content: const Text(
              "Do you want to close the app ?",
              style: TextStyle(
                  fontFamily: "KiwiMaru",
                  fontSize: 15,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold),
            ),
            title: const Text(
              "Really ??",
              style: TextStyle(
                  fontFamily: "KiwiMaru",
                  fontSize: 22,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text(
                    "No",
                    style: TextStyle(fontSize: 30, color: Colors.blueAccent),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text(
                    "Yes",
                    style: TextStyle(fontSize: 30, color: Colors.blueAccent),
                  )),
            ],
          );
        });

    return exitApp;
  }
}
