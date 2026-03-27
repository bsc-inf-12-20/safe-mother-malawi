import 'dart:convert';

import 'package:hive/hive.dart';

class HealthCheck {
  final String id;
  final DateTime timestamp;
  final List<Map<String, String>> responses;
  final bool hasDangerSign;

  const HealthCheck({
    required this.id,
    required this.timestamp,
    required this.responses,
    required this.hasDangerSign,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'timestamp': timestamp.millisecondsSinceEpoch,
        'responses': responses,
        'hasDangerSign': hasDangerSign,
      };

  factory HealthCheck.fromJson(Map<String, dynamic> json) => HealthCheck(
        id: json['id'] as String,
        timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp'] as int),
        responses: (json['responses'] as List<dynamic>)
            .map((e) => Map<String, String>.from(e as Map))
            .toList(),
        hasDangerSign: json['hasDangerSign'] as bool,
      );
}

class HealthCheckAdapter extends TypeAdapter<HealthCheck> {
  @override
  final int typeId = 2;

  @override
  HealthCheck read(BinaryReader reader) {
    final id = reader.readString();
    final timestamp = DateTime.fromMillisecondsSinceEpoch(reader.readInt());
    final responsesJson = reader.readString();
    final responses = (jsonDecode(responsesJson) as List<dynamic>)
        .map((e) => Map<String, String>.from(e as Map))
        .toList();
    final hasDangerSign = reader.readBool();
    return HealthCheck(
      id: id,
      timestamp: timestamp,
      responses: responses,
      hasDangerSign: hasDangerSign,
    );
  }

  @override
  void write(BinaryWriter writer, HealthCheck obj) {
    writer.writeString(obj.id);
    writer.writeInt(obj.timestamp.millisecondsSinceEpoch);
    writer.writeString(jsonEncode(obj.responses));
    writer.writeBool(obj.hasDangerSign);
  }
}
