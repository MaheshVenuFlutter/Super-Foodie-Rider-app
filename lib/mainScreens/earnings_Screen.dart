import 'package:flutter/material.dart';
import 'package:food_rider/global/global.dart';
import 'package:food_rider/splashScreen/splash_screen.dart';

class EarningScreen extends StatefulWidget {
  const EarningScreen({super.key});

  @override
  State<EarningScreen> createState() => _EarningScreenState();
}

class _EarningScreenState extends State<EarningScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
            child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "₹ " + previousRiderEarnings,
                style: const TextStyle(
                    fontFamily: "Signatra", fontSize: 80, color: Colors.white),
              ),
              const Text(
                "Total Earnings",
                style: TextStyle(
                    fontFamily: "Signatra",
                    fontSize: 30,
                    color: Colors.blueGrey,
                    letterSpacing: 3),
              ),
              const SizedBox(
                height: 20,
                width: 200,
                child: Divider(
                  color: Colors.white,
                  thickness: 1.5,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (c) => const MySplashScreen()));
                },
                child: const Card(
                  color: Colors.blueGrey,
                  margin: EdgeInsets.symmetric(vertical: 40, horizontal: 40),
                  child: ListTile(
                    title: Text(
                      " Go Back ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22),
                    ),
                  ),
                ),
              )
            ],
          ),
        )),
      ),
    );
  }
}
