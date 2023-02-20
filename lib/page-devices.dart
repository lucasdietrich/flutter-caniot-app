import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';

import 'config.dart';

// TODO: https://chat.openai.com/chat/04f778b3-1b0b-4bba-ae0e-fbfabf33603c
CustomSettings settings = CustomSettings(hostname: '192.168.10.240', port: 80);

Future<List<dynamic>> fetchDevices() async {
  final response =
      await http.get(Uri.parse('http://${settings.hostname}/api/devices/'));
  if (response.statusCode == 200) {
    List<dynamic> devices = jsonDecode(response.body) as List<dynamic>;
    print(devices);
    return devices;
  } else {
    throw Exception('Failed to retrieve devices');
  }
}

class DevicesButton extends StatefulWidget {
  @override
  _DevicesButtonState createState() => _DevicesButtonState();
}

class _DevicesButtonState extends State<DevicesButton> {
  List<dynamic> _devices = [];

  void _getDevices() async {
    List<dynamic> devices = await fetchDevices();
    setState(() {
      _devices = devices;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: _getDevices,
          child: Text('Get devices'),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _devices.length,
            itemBuilder: (context, index) {
              print(_devices[index]);
              return ListTile(
                title: Text('Device ${index}: ${_devices[index]['addr_repr']}'),
                subtitle:
                    Text('SDEVUI ${_devices[index]['sdevuid'].toString()}'),
              );
            },
          ),
        ),
      ],
    );
  }
}
