// To parse this JSON data, do
//
//     final mLogPrNumber = mLogPrNumberFromJson(jsonString);

import 'dart:convert';

List<MLogPrNumber> mLogPrNumberFromJson(String str) => List<MLogPrNumber>.from(
    json.decode(str).map((x) => MLogPrNumber.fromJson(x)));

String mLogPrNumberToJson(List<MLogPrNumber> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MLogPrNumber {
  MLogPrNumber({
    this.rowId,
    this.prNumber,
    this.users,
    this.date,
    this.status,
    this.comment,
    this.action,
    this.clientName,
  });

  int rowId;
  String prNumber;
  String users;
  String date;
  String status;
  String comment;
  String action;
  String clientName;

  factory MLogPrNumber.fromJson(Map<String, dynamic> json) => MLogPrNumber(
        rowId: json["rowId"] == null ? null : json["rowId"],
        prNumber: json["PRNumber"] == null ? null : json["PRNumber"],
        users: json["users"] == null ? null : json["users"],
        date: json["date"] == null ? null : json["date"],
        status: json["status"] == null ? null : json["status"],
        comment: json["comment"] == null ? null : json["comment"],
        action: json["action"] == null ? null : json["action"],
        clientName: json["clientName"] == null ? null : json["clientName"],
      );

  Map<String, dynamic> toJson() => {
        "rowId": rowId == null ? null : rowId,
        "PRNumber": prNumber == null ? null : prNumber,
        "users": users == null ? null : users,
        "date": date == null ? null : date,
        "status": status == null ? null : status,
        "comment": comment == null ? null : comment,
        "action": action == null ? null : action,
        "clientName": clientName == null ? null : clientName,
      };
}
