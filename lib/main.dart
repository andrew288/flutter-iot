import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iotflutter/models/sensor.dart';
import 'package:http/http.dart' as http;
import 'package:iotflutter/widgets/cardDataSensor.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  Future<List<DataSensor>> fetchData() async {
    var url =
        Uri.https('brthu4f4ef.execute-api.us-east-2.amazonaws.com', 'items');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => DataSensor.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('DataSensor from API'),
        ),
        body: FutureBuilder<List<DataSensor>>(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return CardDataSensor(data: snapshot.data![index]);
                },
              );
            } else if (snapshot.hasError) {
              return Center(child: Text("${snapshot.error}"));
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
