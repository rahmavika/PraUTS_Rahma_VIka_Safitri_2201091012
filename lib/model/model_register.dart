// To parse this JSON data, do
//
//     final modelRegisterLagi = modelRegisterLagiFromJson(jsonString);

import 'dart:convert';

ModelRegisterLagi modelRegisterLagiFromJson(String str) => ModelRegisterLagi.fromJson(json.decode(str));

String modelRegisterLagiToJson(ModelRegisterLagi data) => json.encode(data.toJson());

class ModelRegisterLagi {
  int value;
  String message;

  ModelRegisterLagi({
    required this.value,
    required this.message,
  });

  factory ModelRegisterLagi.fromJson(Map<String, dynamic> json) => ModelRegisterLagi(
    value: json["value"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "value": value,
    "message": message,
  };
}
