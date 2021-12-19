// To parse this JSON data, do
//
//     final responsePickup = responsePickupFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

ResponsePickup responsePickupFromJson(String str) =>
    ResponsePickup.fromJson(json.decode(str));

String responsePickupToJson(ResponsePickup data) => json.encode(data.toJson());

class ResponsePickup {
  ResponsePickup({
    required this.status,
    required this.message,
    required this.pickupOrders,
  });

  final String status;
  final String message;
  final PickupOrders pickupOrders;

  factory ResponsePickup.fromJson(Map<String, dynamic> json) => ResponsePickup(
        status: json["status"],
        message: json["message"],
        pickupOrders: PickupOrders.fromJson(json["pickup_orders"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "pickup_orders": pickupOrders.toJson(),
      };
}

class PickupOrders {
  PickupOrders({
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
  final String prevPageUrl;
  final int to;
  final int total;

  factory PickupOrders.fromJson(Map<String, dynamic> json) => PickupOrders(
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
    required this.pickupOrderNo,
    required this.userId,
    required this.driverId,
    required this.address,
    required this.cityId,
    required this.postalCode,
    required this.recipientName,
    required this.phoneNumber,
    required this.pickupDate,
    required this.estimateVolume,
    required this.weighingVolume,
    required this.realRecipientName,
    required this.cancelReason,
    required this.rejectReason,
    required this.rejectUserId,
    required this.cancelUserId,
    required this.pickupProofImage,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.totalPrice,
    required this.price,
    required this.latitude,
    required this.longitude,
  });

  final int id;
  final String pickupOrderNo;
  final int userId;
  final dynamic driverId;
  final String address;
  final int cityId;
  final String postalCode;
  final String recipientName;
  final String phoneNumber;
  final dynamic pickupDate;
  final double estimateVolume;
  final dynamic weighingVolume;
  final dynamic realRecipientName;
  final dynamic cancelReason;
  final dynamic rejectReason;
  final dynamic rejectUserId;
  final dynamic cancelUserId;
  final dynamic pickupProofImage;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final dynamic deletedAt;
  final int totalPrice;
  final int price;
  final dynamic latitude;
  final dynamic longitude;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        pickupOrderNo: json["pickup_order_no"],
        userId: json["user_id"],
        driverId: json["driver_id"],
        address: json["address"],
        cityId: json["city_id"],
        postalCode: json["postal_code"],
        recipientName: json["recipient_name"],
        phoneNumber: json["phone_number"],
        pickupDate: json["pickup_date"],
        estimateVolume: json["estimate_volume"].toDouble(),
        weighingVolume: json["weighing_volume"],
        realRecipientName: json["real_recipient_name"],
        cancelReason: json["cancel_reason"],
        rejectReason: json["reject_reason"],
        rejectUserId: json["reject_user_id"],
        cancelUserId: json["cancel_user_id"],
        pickupProofImage: json["pickup_proof_image"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        totalPrice: json["total_price"],
        price: json["price"],
        latitude: json["latitude"],
        longitude: json["longitude"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "pickup_order_no": pickupOrderNo,
        "user_id": userId,
        "driver_id": driverId,
        "address": address,
        "city_id": cityId,
        "postal_code": postalCode,
        "recipient_name": recipientName,
        "phone_number": phoneNumber,
        "pickup_date": pickupDate,
        "estimate_volume": estimateVolume,
        "weighing_volume": weighingVolume,
        "real_recipient_name": realRecipientName,
        "cancel_reason": cancelReason,
        "reject_reason": rejectReason,
        "reject_user_id": rejectUserId,
        "cancel_user_id": cancelUserId,
        "pickup_proof_image": pickupProofImage,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
        "total_price": totalPrice,
        "price": price,
        "latitude": latitude,
        "longitude": longitude,
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
