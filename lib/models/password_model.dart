import 'dart:convert';

PasswordModel passwordModelFromJson(String str) =>
    PasswordModel.fromJson(json.decode(str));

String passwordModelToJson(PasswordModel data) => json.encode(data.toJson());

class PasswordModel {
  PasswordModel({
    this.website,
    this.username,
    this.password,
    this.type,
  });

  String? website;
  String? username;
  String? password;
  String? type;

  factory PasswordModel.fromJson(Map<String, dynamic> json) => PasswordModel(
        website: json["website"],
        username: json["username"],
        password: json["password"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "website": website,
        "username": username,
        "password": password,
        "type": type,
      };
}
