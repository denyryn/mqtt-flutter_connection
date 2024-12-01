class DhtModel {
  double temperature;
  double humidity;
  // final Array? topic;

  DhtModel({required this.temperature, required this.humidity});

  factory DhtModel.fromJson(Map<String, dynamic> json) {
    return DhtModel(
      temperature: json['temperature'],
      humidity: json['humidity'],
      // topic: json['topic'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'temperature': temperature,
      'humidity': humidity,
      // 'topic': topic
    };

    return data;
  }
}
