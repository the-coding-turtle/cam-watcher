import 'package:cam_watcher/src/views/home/home_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:getwidget/getwidget.dart';

class HomeView extends StatelessWidget {
  late HomeController _controller;

  HomeView({required HomeController controller, Key? key}) : super(key: key) {
    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cam Watcher'),
      ),
      floatingActionButton: GFIconButton(
        key:Key("button_add"),
        icon: const Icon(Icons.add),
        onPressed: _controller.onAddButtonPressed,
      ),
      body: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              GFButton(
                key: Key("button_save"),
                text: "Save",
                onPressed: () {
                  _controller.save();
                  Get.snackbar("Settings saved", "Settings saved to device.");
                },
              ),
              const SizedBox(
                width: 50,
              ),
              GFButton(
                key: Key("button_load"),
                text: "Load",
                onPressed: () {
                  _controller.load();
                  Get.snackbar(
                      "Settings loaded", "Settings loaded from device.");
                },
              )
            ],
          ),
          Obx(
            () => ListView.builder(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: _controller.streamObjects.length,
              itemBuilder: (context, index) => buildStreamElement(index: index),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStreamElement({required int index}) {
    return ObxValue(
        (RxBool streamEnabled) => Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: FormBuilderTextField(
                          key: Key("text_field_$index"),
                          name: "text_field_$index",
                          decoration:
                              const InputDecoration(labelText: "Stream URL"),
                          keyboardType: TextInputType.url,
                          initialValue: _controller.streamObjects[index].url,
                          onChanged: (value) {
                            streamEnabled.value = false;
                            _controller.streamObjects[index].url = value!;
                          },
                        ),
                      ),
                      Container(
                        child: GFIconButton(
                          key: Key("button_delete_$index"),
                          icon: const Icon(Icons.delete),
                          onPressed: () =>
                              _controller.streamObjects.removeAt(index),
                        ),
                        padding: const EdgeInsets.all(10),
                      ),
                      GFButton(
                        key: Key("button_start-stop_$index"),
                        text: streamEnabled.value ? "Stop" : "Start",
                        onPressed: () =>
                            streamEnabled.value = !streamEnabled.value,
                      )
                    ],
                  ),
                ),
                if (streamEnabled.value)
                  Mjpeg(
                    key: Key("stream_$index"),
                    isLive: true,
                    error: (context, error, stack) {
                      print(error);
                      print(stack);
                      return Text(error.toString(),
                          style: const TextStyle(color: Colors.red));
                    },
                    stream: _controller.streamObjects[index].url,
                  ),
              ],
            ),
        _controller.streamObjects[index].enabled);
  }
}
