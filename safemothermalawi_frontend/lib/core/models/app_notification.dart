import 'package:hive/hive.dart';

class AppNotification {
  final String id;
  final String type;
  final String title;
  final String body;
  final bool isRead;
  final DateTime timestamp;
  final String deepLinkRoute;

  const AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.isRead,
    required this.timestamp,
    required this.deepLinkRoute,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'title': title,
        'body': body,
        'isRead': isRead,
        'timestamp': timestamp.millisecondsSinceEpoch,
        'deepLinkRoute': deepLinkRoute,
      };

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      AppNotification(
        id: json['id'] as String,
        type: json['type'] as String,
        title: json['title'] as String,
        body: json['body'] as String,
        isRead: json['isRead'] as bool,
        timestamp:
            DateTime.fromMillisecondsSinceEpoch(json['timestamp'] as int),
        deepLinkRoute: json['deepLinkRoute'] as String,
      );
}

class AppNotificationAdapter extends TypeAdapter<AppNotification> {
  @override
  final int typeId = 5;

  @override
  AppNotification read(BinaryReader reader) {
    return AppNotification(
      id: reader.readString(),
      type: reader.readString(),
      title: reader.readString(),
      body: reader.readString(),
      isRead: reader.readBool(),
      timestamp: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
      deepLinkRoute: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, AppNotification obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.type);
    writer.writeString(obj.title);
    writer.writeString(obj.body);
    writer.writeBool(obj.isRead);
    writer.writeInt(obj.timestamp.millisecondsSinceEpoch);
    writer.writeString(obj.deepLinkRoute);
  }
}
