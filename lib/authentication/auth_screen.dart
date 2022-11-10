import 'package:flutter/material.dart';
import 'package:food_rider/authentication/register.dart';

import 'login.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: WillPopScope(
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
            automaticallyImplyLeading: false,
            title: Text(
              "Super Foodie's Rider App",
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width / 12,
                color: Colors.white,
                fontFamily: "Signatra",
              ),
            ),
            centerTitle: true,
            bottom: const TabBar(
              tabs: [
                Tab(
                  icon: Icon(
                    Icons.lock,
                    color: Colors.white,
                  ),
                  text: "Login",
                ),
                Tab(
                  icon: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  text: "Register",
                )
              ],
              indicatorColor: Colors.white,
              indicatorWeight: 6,
            ),
          ),
          body: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [Colors.amber, Colors.cyan])),
            child: const TabBarView(children: [LoginScren(), RegisterScreen()]),
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
