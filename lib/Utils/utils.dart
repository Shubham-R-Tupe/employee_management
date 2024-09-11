import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utils {
  static loader() {
    return const Center(
      child: SpinKitCubeGrid(
        size: 30,
        color: Colors.blueAccent,
      ),
    );
  }

  static flutterToast(String msg) {
    Fluttertoast.showToast(msg: msg, backgroundColor: Colors.blueAccent);
  }
}
