import 'package:hive/hive.dart';

class AncVisit {
  final String id;
  final DateTime date;
  final String facility;
  final String clinicianName;
  final String status;

  const AncVisit({
    required this.id,
    required this.date,
    required this.facility,
    required this.clinicianName,
    required this.status,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.millisecondsSinceEpoch,
        'facility': facility,
        'clinicianName': clinicianName,
        'status': status,
      };

  factory AncVisit.fromJson(Map<String, dynamic> json) => AncVisit(
        id: json['id'] as String,
        date: DateTime.fromMillisecondsSinceEpoch(json['date'] as int),
        facility: json['facility'] as String,
        clinicianName: json['clinicianName'] as String,
        status: json['status'] as String,
      );
}

class AncVisitAdapter extends TypeAdapter<AncVisit> {
  @override
  final int typeId = 1;

  @override
  AncVisit read(BinaryReader reader) {
    return AncVisit(
      id: reader.readString(),
      date: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
      facility: reader.readString(),
      clinicianName: reader.readString(),
      status: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, AncVisit obj) {
    writer.writeString(obj.id);
    writer.writeInt(obj.date.millisecondsSinceEpoch);
    writer.writeString(obj.facility);
    writer.writeString(obj.clinicianName);
    writer.writeString(obj.status);
  }
}
