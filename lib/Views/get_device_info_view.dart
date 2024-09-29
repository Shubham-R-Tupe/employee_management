import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class DeviceInfoScreen extends StatefulWidget {
  const DeviceInfoScreen({super.key});

  @override
  DeviceInfoScreenState createState() => DeviceInfoScreenState();
}

class DeviceInfoScreenState extends State<DeviceInfoScreen> {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String id = 'Unknown';

  @override
  void initState() {
    super.initState();
    _getDeviceInfo();
  }

  Future<void> _getDeviceInfo() async {
    try {
      if (await Permission.phone.request().isGranted) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        setState(() {
          id = androidInfo.id ;
        });
      } else {
        setState(() {
          id = 'Permission denied';
        });
      }
    } catch (e) {
      debugPrint('Error getting device info: $e');
      setState(() {
        id = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Device Info'),
      ),
      body: Center(
        child: Text('Id: $id'),
      ),
    );
  }
}