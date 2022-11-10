import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import '../global/global.dart';
import '../models/address_model.dart';
import '../widgets/progress_bar.dart';
import '../widgets/shipment_addres_design.dart';
import '../widgets/status_banner.dart';

class OrderDetailsScreen extends StatefulWidget {
  final String? orderID;

  OrderDetailsScreen({this.orderID});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  String orderStatus = "";
  String orderByUser = "";
  String sellerId = "";

  getOrderInFo() {
    FirebaseFirestore.instance
        .collection("orders")
        .doc(widget.orderID)
        .get()
        .then((DocumentSnapshot) {
      orderStatus = DocumentSnapshot.data()!["status"].toString();
      orderByUser = DocumentSnapshot.data()!["orderBy"].toString();
      sellerId = DocumentSnapshot.data()!["sellerUID"].toString();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOrderInFo();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SingleChildScrollView(
          child: FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection("orders")
                .doc(widget.orderID)
                .get(),
            builder: (context, snapshot) {
              Map? dataMap;
              if (snapshot.hasData) {
                dataMap = snapshot.data!.data() as Map<String, dynamic>;
                orderStatus = dataMap["status"].toString();
              }
              return snapshot.hasData
                  ? Container(
                      child: Column(
                        children: [
                          StatusBanner(
                            status: dataMap!["isSuccess"],
                            orderStatus: orderStatus,
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Total: ₹ ${dataMap["totalAmount"].toString()}",
                                style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              "Order Id: ${widget.orderID!}",
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              "Order at: " +
                                  DateFormat("dd MMMM, yyyy - hh:mm aa").format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          int.parse(dataMap["orderTime"]))),
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.grey),
                            ),
                          ),
                          const Divider(
                            thickness: 4,
                          ),
                          orderStatus == "ended"
                              ? Image.asset("images/success.jpg")
                              : Image.asset("images/confirm_pick.png"),
                          const Divider(
                            thickness: 4,
                          ),
                          FutureBuilder<DocumentSnapshot>(
                            future: FirebaseFirestore.instance
                                .collection("users")
                                .doc(orderByUser)
                                .collection("userAddress")
                                .doc(dataMap["addressID"])
                                .get(),
                            builder: (context, snapshot) {
                              return snapshot.hasData
                                  ? ShipmentAddressDesign(
                                      model: Address.fromJson(snapshot.data!
                                          .data()! as Map<String, dynamic>),
                                      orderStatus: orderStatus,
                                      orderId: widget.orderID,
                                      sellerId: sellerId,
                                      orderByUser: orderByUser)
                                  : Center(
                                      child: CircularProgress(),
                                    );
                            },
                          )
                        ],
                      ),
                    )
                  : Center(
                      child: CircularProgress(),
                    );
            },
          ),
        ),
      ),
    );
  }
}
