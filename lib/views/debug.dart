import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../view_models/debug_viewmodel.dart';
import '../widgets/form_field.dart';
import '../widgets/elev_button.dart';
import '../widgets/switch_button.dart';

class DebugPage extends StatelessWidget {
  DebugPage({super.key});

  final DebugViewmodel _viewmodel = Get.put(DebugViewmodel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug'),
        actions: [
          SwitchButton(
            isSwitched: _viewmodel.isDebugging,
            onChanged: (value) {
              _viewmodel.toggleDebug(value);
            },
          ),
        ],
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Form(
            child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Obx(() => CustomFormField(
                    icon: const Icon(Icons.text_snippet_rounded),
                    label: 'Name',
                    controller: _viewmodel.isLoading.value
                        ? null
                        : _viewmodel.nameFieldController,
                    keyboardType: TextInputType.url,
                    enabled: !_viewmodel.isLoading.value,
                    validator: (value) {
                      return null;
                    },
                  )),
              const SizedBox(height: 20),
              Obx(() => CustomFormField(
                    icon: const Icon(Icons.topic),
                    label: 'Topic',
                    controller: _viewmodel.isLoading.value
                        ? null
                        : _viewmodel.topicFieldController,
                    keyboardType: TextInputType.url,
                    enabled: !_viewmodel.isLoading.value,
                    validator: (value) {
                      return null;
                    },
                  )),
              const SizedBox(height: 20),
              Obx(() => _viewmodel.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : CustomElevButton(
                      label: 'Save',
                      onPressed: () => _viewmodel.updateDebug(),
                    )),
              Obx(() => Container(
                    margin: const EdgeInsets.all(
                        16), // Increased margin for more space
                    padding: const EdgeInsets.all(
                        12), // Added padding for the content
                    decoration: BoxDecoration(
                      color: _viewmodel.isDebugging.value
                          ? Colors.green[800]
                          : Colors.red[
                              800], // Dynamic background color based on debugging state
                      borderRadius: BorderRadius.circular(
                          12), // Rounded corners for the container
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ], // Added shadow for a subtle 3D effect
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _viewmodel.isDebugging.value
                              ? "Debugging Status"
                              : "No Debugging",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                            height: 8), // Spacing between title and message
                        Text(
                          _viewmodel.isDebugging.value
                              ? _viewmodel.debugMessage.value
                              : "Not Debugging",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontStyle: FontStyle
                                .italic, // Styled message to be less prominent
                          ),
                        ),
                      ],
                    ),
                  ))
            ],
          ),
        )),
      )),
    );
  }
}
