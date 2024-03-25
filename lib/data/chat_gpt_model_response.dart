import 'dart:convert';

class ChatGptModelResponse {
  String object;
  List<Datum> data;

  ChatGptModelResponse({
    required this.object,
    required this.data,
  });

  factory ChatGptModelResponse.fromRawJson(String str) => ChatGptModelResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ChatGptModelResponse.fromJson(Map<String, dynamic> json) => ChatGptModelResponse(
        object: json["object"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "object": object,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };

  List<String> extractModelList() => List.generate(data.length, (index) => data[index].id);
}

class Datum {
  String id;
  Object object;
  int created;
  OwnedBy ownedBy;

  Datum({
    required this.id,
    required this.object,
    required this.created,
    required this.ownedBy,
  });

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        object: objectValues.map[json["object"]]!,
        created: json["created"],
        ownedBy: ownedByValues.map[json["owned_by"]]!,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "object": objectValues.reverse[object],
        "created": created,
        "owned_by": ownedByValues.reverse[ownedBy],
      };
}

enum Object { MODEL }

final objectValues = EnumValues({"model": Object.MODEL});

enum OwnedBy { OPENAI, OPENAI_INTERNAL, SYSTEM }

final ownedByValues = EnumValues({"openai": OwnedBy.OPENAI, "openai-internal": OwnedBy.OPENAI_INTERNAL, "system": OwnedBy.SYSTEM});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
