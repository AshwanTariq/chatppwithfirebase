class UserModel {
  String name;
  String id;
  String fcmToken;
  String addTime;
  String email;

  UserModel({
    required this.name,
    required this.id,
    required this.fcmToken,
    required this.addTime,
    required this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      id: json['id'],
      fcmToken: json['fcmToken'],
      addTime: json['addTime'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'fcmToken': fcmToken,
      'addTime': addTime,
      'email': email,
    };
  }
}