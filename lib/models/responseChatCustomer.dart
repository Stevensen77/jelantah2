// To parse this JSON data, do
//
//     final responseChatCustomer = responseChatCustomerFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

ResponseChatCustomer responseChatCustomerFromJson(String str) =>
    ResponseChatCustomer.fromJson(json.decode(str));

String responseChatCustomerToJson(ResponseChatCustomer data) =>
    json.encode(data.toJson());

class ResponseChatCustomer {
  ResponseChatCustomer({
    required this.status,
    required this.message,
    required this.chats,
  });

  final String status;
  final String message;
  final Chats chats;

  factory ResponseChatCustomer.fromJson(Map<String, dynamic> json) =>
      ResponseChatCustomer(
        status: json["status"],
        message: json["message"],
        chats: Chats.fromJson(json["chats"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "chats": chats.toJson(),
      };
}

class Chats {
  Chats({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    required this.nextPageUrl,
    required this.path,
    required this.perPage,
    required this.prevPageUrl,
    required this.to,
    required this.total,
  });

  final int currentPage;
  final List<Datum> data;
  final String firstPageUrl;
  final int from;
  final int lastPage;
  final String lastPageUrl;
  final List<Link> links;
  final dynamic nextPageUrl;
  final String path;
  final int perPage;
  final dynamic prevPageUrl;
  final int to;
  final int total;

  factory Chats.fromJson(Map<String, dynamic> json) => Chats(
        currentPage: json["current_page"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "links": List<dynamic>.from(links.map((x) => x.toJson())),
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
      };
}

class Datum {
  Datum({
    required this.id,
    required this.message,
    required this.image,
    required this.pickupOrderId,
    required this.sendUserId,
    required this.sendName,
    required this.toUserId,
    required this.toName,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.isPush,
    required this.isRead,
  });

  final int id;
  final String message;
  final String image;
  final dynamic pickupOrderId;
  final int sendUserId;
  final String sendName;
  final int toUserId;
  final String toName;
  final DateTime createdAt;
  final DateTime updatedAt;
  final dynamic deletedAt;
  final int isPush;
  final bool isRead;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        message: json["message"],
        image: json["image"] == null ? null : json["image"],
        pickupOrderId: json["pickup_order_id"],
        sendUserId: json["send_user_id"],
        sendName: json["send_name"],
        toUserId: json["to_user_id"],
        toName: json["to_name"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        isPush: json["is_push"],
        isRead: json["is_read"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "message": message,
        "image": image == null ? null : image,
        "pickup_order_id": pickupOrderId,
        "send_user_id": sendUserId,
        "send_name": sendName,
        "to_user_id": toUserId,
        "to_name": toName,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
        "is_push": isPush,
        "is_read": isRead,
      };
}

class Link {
  Link({
    required this.url,
    required this.label,
    required this.active,
  });

  final String url;
  final String label;
  final bool active;

  factory Link.fromJson(Map<String, dynamic> json) => Link(
        url: json["url"] == null ? null : json["url"],
        label: json["label"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "url": url == null ? null : url,
        "label": label,
        "active": active,
      };
}
