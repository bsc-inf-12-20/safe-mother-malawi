import 'package:hive/hive.dart';

class SyncQueueItem {
  final String id;
  final String endpoint;
  final String payload;
  final DateTime createdAt;
  final int retryCount;

  const SyncQueueItem({
    required this.id,
    required this.endpoint,
    required this.payload,
    required this.createdAt,
    required this.retryCount,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'endpoint': endpoint,
        'payload': payload,
        'createdAt': createdAt.millisecondsSinceEpoch,
        'retryCount': retryCount,
      };

  factory SyncQueueItem.fromJson(Map<String, dynamic> json) => SyncQueueItem(
        id: json['id'] as String,
        endpoint: json['endpoint'] as String,
        payload: json['payload'] as String,
        createdAt:
            DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int),
        retryCount: json['retryCount'] as int,
      );
}

class SyncQueueItemAdapter extends TypeAdapter<SyncQueueItem> {
  @override
  final int typeId = 6;

  @override
  SyncQueueItem read(BinaryReader reader) {
    return SyncQueueItem(
      id: reader.readString(),
      endpoint: reader.readString(),
      payload: reader.readString(),
      createdAt: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
      retryCount: reader.readInt(),
    );
  }

  @override
  void write(BinaryWriter writer, SyncQueueItem obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.endpoint);
    writer.writeString(obj.payload);
    writer.writeInt(obj.createdAt.millisecondsSinceEpoch);
    writer.writeInt(obj.retryCount);
  }
}
