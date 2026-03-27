import 'package:hive/hive.dart';

class DangerSign {
  final String id;
  final String titleEn;
  final String titleNy;
  final String descriptionEn;
  final String descriptionNy;
  final String severity;

  const DangerSign({
    required this.id,
    required this.titleEn,
    required this.titleNy,
    required this.descriptionEn,
    required this.descriptionNy,
    required this.severity,
  });

  String getTitle(String lang) => lang == 'ny' ? titleNy : titleEn;

  String getDescription(String lang) =>
      lang == 'ny' ? descriptionNy : descriptionEn;

  Map<String, dynamic> toJson() => {
        'id': id,
        'titleEn': titleEn,
        'titleNy': titleNy,
        'descriptionEn': descriptionEn,
        'descriptionNy': descriptionNy,
        'severity': severity,
      };

  factory DangerSign.fromJson(Map<String, dynamic> json) => DangerSign(
        id: json['id'] as String,
        titleEn: json['titleEn'] as String,
        titleNy: json['titleNy'] as String,
        descriptionEn: json['descriptionEn'] as String,
        descriptionNy: json['descriptionNy'] as String,
        severity: json['severity'] as String,
      );
}

class DangerSignAdapter extends TypeAdapter<DangerSign> {
  @override
  final int typeId = 3;

  @override
  DangerSign read(BinaryReader reader) {
    return DangerSign(
      id: reader.readString(),
      titleEn: reader.readString(),
      titleNy: reader.readString(),
      descriptionEn: reader.readString(),
      descriptionNy: reader.readString(),
      severity: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, DangerSign obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.titleEn);
    writer.writeString(obj.titleNy);
    writer.writeString(obj.descriptionEn);
    writer.writeString(obj.descriptionNy);
    writer.writeString(obj.severity);
  }
}
