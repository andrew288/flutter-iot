import 'package:flutter/material.dart';
import 'package:iotflutter/mqtt/MqttConnection.dart';
import 'package:mqtt5_client/mqtt5_server_client.dart';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';

class MqttPublishScreen extends StatefulWidget {
  const MqttPublishScreen({Key? key}) : super(key: key);
  @override
  _MqttPublishScreenState createState() => _MqttPublishScreenState();
}

class _MqttPublishScreenState extends State<MqttPublishScreen> {
  MqttServerClient? mqttController;
  TextEditingController messageController = TextEditingController();
  bool isConnected = false;
  final _colorNotifier = ValueNotifier(Colors.green);

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
                        publishTopic(mqttController!, 'test', 'inTopic');
                      },
                child: const Text('Publicar Mensaje'),
              ),
            ],
          ),
        ));
    // body: Center(
    //   child: Padding(
    //     padding: const EdgeInsets.all(30),
    //     child: Container(
    //       decoration: BoxDecoration(color: Colors.white, boxShadow: [
    //         BoxShadow(
    //             color: Colors.grey.withOpacity(0.5),
    //             spreadRadius: 5,
    //             blurRadius: 7,
    //             offset: const Offset(0, 3)),
    //       ]),
    //       child: Padding(
    //         padding: const EdgeInsets.all(20),
    //         child: ValueListenableBuilder<Color>(
    //           valueListenable: _colorNotifier,
    //           builder: (_, color, __) {
    //             return ColorPicker(
    //                 color: color, onChanged: (value) => color = value);
    //           },
    //         ),
    //       ),
    //     ),
    //   ),
    // ));
  }
}
