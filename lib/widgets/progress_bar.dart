import 'package:flutter/material.dart';

CircularProgress() {
  return Container(
    alignment: Alignment.center,
    padding: const EdgeInsets.only(top: 20),
    child: const CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(
        Colors.amber,
      ),
    ),
  );
}
