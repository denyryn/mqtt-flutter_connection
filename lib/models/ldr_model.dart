class LdrModel {
  double intensity;

  LdrModel({required this.intensity});

  factory LdrModel.fromJson(Map<String, dynamic> json) {
    return LdrModel(intensity: json['intensity']);
  }

  Map<String, dynamic> toJson() => {'intensity': intensity};
}
