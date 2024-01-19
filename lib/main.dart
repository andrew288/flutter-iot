import 'package:flutter/material.dart';
import 'package:iotflutter/uis/screenPublishScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ScreenHome(),
    );
  }
}

class ScreenHome extends StatefulWidget {
  @override
  _ScreenHomeState createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MQTT App'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navega a la pantalla de publicación y pasa la instancia de MqttConnection
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MqttPublishScreen(),
              ),
            );
          },
          child: const Text('Ir a la pantalla de publicación'),
        ),
      ),
    );
  }
}
