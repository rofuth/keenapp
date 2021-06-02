// To parse this JSON data, do
//
//     final mPmsMobile = mPmsMobileFromJson(jsonString);

import 'dart:convert';

List<MPmsMobile> mPmsMobileFromJson(String str) =>
    List<MPmsMobile>.from(json.decode(str).map((x) => MPmsMobile.fromJson(x)));

String mPmsMobileToJson(List<MPmsMobile> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MPmsMobile {
  MPmsMobile({
    this.rowId,
    this.deviceId,
    this.applicationName,
    this.status,
    this.createBy,
    this.createDate,
    this.updateBy,
    this.updateDate,
  });

  int rowId;
  String deviceId;
  String applicationName;
  String status;
  String createBy;
  String createDate;
  String updateBy;
  String updateDate;

  factory MPmsMobile.fromJson(Map<String, dynamic> json) => MPmsMobile(
        rowId: json["rowId"] == null ? null : json["rowId"],
        deviceId: json["deviceID"] == null ? null : json["deviceID"],
        applicationName:
            json["applicationName"] == null ? null : json["applicationName"],
        status: json["status"] == null ? null : json["status"],
        createBy: json["createBy"] == null ? null : json["createBy"],
        createDate: json["createDate"] == null ? null : json["createDate"],
        updateBy: json["updateBy"] == null ? null : json["updateBy"],
        updateDate: json["updateDate"] == null ? null : json["updateDate"],
      );

  Map<String, dynamic> toJson() => {
        "rowId": rowId == null ? null : rowId,
        "deviceID": deviceId == null ? null : deviceId,
        "applicationName": applicationName == null ? null : applicationName,
        "status": status == null ? null : status,
        "createBy": createBy == null ? null : createBy,
        "createDate": createDate == null ? null : createDate,
        "updateBy": updateBy == null ? null : updateBy,
        "updateDate": updateDate == null ? null : updateDate,
      };
}
