import 'package:flutter/material.dart';
import 'package:iotflutter/mqtt/MqttConnection.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttPublishScreen extends StatefulWidget {
  const MqttPublishScreen({Key? key}) : super(key: key);
  @override
  _MqttPublishScreenState createState() => _MqttPublishScreenState();
}

class _MqttPublishScreenState extends State<MqttPublishScreen> {
  MqttServerClient? mqttController;
  TextEditingController messageController = TextEditingController();
  bool isConnected = false;

  @override
  void initState() {
    super.initState();
    connect().then((value) {
      setState(() {
        mqttController = value;
        isConnected = true;
      });
    });
  }

  @override
  void dispose() {
    if (isConnected) {
      mqttController!.disconnect();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MQTT Publish Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: messageController,
              decoration:
                  const InputDecoration(labelText: 'Mensaje a Publicar'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: mqttController == null
                  ? null
                  : () {
                      publishTopic(mqttController!, 'test', 'test');
                    },
              child: const Text('Publicar Mensaje'),
            ),
          ],
        ),
      ),
    );
  }
}
