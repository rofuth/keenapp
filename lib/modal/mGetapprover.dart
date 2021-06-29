// To parse this JSON data, do
//
//     final mGetapprover = mGetapproverFromJson(jsonString);

import 'dart:convert';

List<MGetapprover> mGetapproverFromJson(String str) => List<MGetapprover>.from(
    json.decode(str).map((x) => MGetapprover.fromJson(x)));

String mGetapproverToJson(List<MGetapprover> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MGetapprover {
  MGetapprover({
    this.department,
    this.condition,
    this.approvalName,
    this.email,
    this.levels,
  });

  String department;
  String condition;
  String approvalName;
  String email;
  String levels;

  factory MGetapprover.fromJson(Map<String, dynamic> json) => MGetapprover(
        department: json["Department"] == null ? null : json["Department"],
        condition: json["condition"] == null ? null : json["condition"],
        approvalName:
            json["ApprovalName"] == null ? null : json["ApprovalName"],
        email: json["email"] == null ? null : json["email"],
        levels: json["levels"] == null ? null : json["levels"],
      );

  Map<String, dynamic> toJson() => {
        "Department": department == null ? null : department,
        "condition": condition == null ? null : condition,
        "ApprovalName": approvalName == null ? null : approvalName,
        "email": email == null ? null : email,
        "levels": levels == null ? null : levels,
      };
}
