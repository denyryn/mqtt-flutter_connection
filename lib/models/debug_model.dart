class DebugModel {
  final String topic;
  final String? name;
  final bool state;

  DebugModel({required this.topic, required this.state, this.name});

  factory DebugModel.fromJson(Map<String, dynamic> json) {
    return DebugModel(
        topic: json['topic'], name: json['name'], state: json['state']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['topic'] = topic;
    data['state'] = state;
    if (name != null) {
      data['name'] = name;
    }
    return data;
  }
}
