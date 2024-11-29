class LedModel {
  String pin;
  bool status;
  int? brightness;

  LedModel({required this.pin, required this.status, this.brightness});

  // From JSON to LedModel
  factory LedModel.fromJson(Map<String, dynamic> json) {
    return LedModel(
      pin: json['pin'],
      status: json['status'],
      brightness: json['brightness'],
    );
  }

  // From LedModel to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {'pin': pin, 'status': status};

    // Only add brightness if it's not null
    if (brightness != null) {
      data['brightness'] = brightness;
    }

    return data;
  }
}
