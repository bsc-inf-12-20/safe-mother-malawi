import 'package:hive/hive.dart';

class MotherProfile {
  final String id;
  final String fullName;
  final String patientId;
  final String phone;
  final String village;
  final String bloodGroup;
  final String clinicianName;
  final DateTime lmp;
  final DateTime edd;
  final int gravida;
  final int parity;
  final int ancVisitsCompleted;
  final String preferredLanguage;

  const MotherProfile({
    required this.id,
    required this.fullName,
    required this.patientId,
    required this.phone,
    required this.village,
    required this.bloodGroup,
    required this.clinicianName,
    required this.lmp,
    required this.edd,
    required this.gravida,
    required this.parity,
    required this.ancVisitsCompleted,
    required this.preferredLanguage,
  });

  int get gestationalWeek {
    final week = ((DateTime.now().difference(lmp).inDays) ~/ 7) + 1;
    return week.clamp(1, 40);
  }

  String get trimester {
    final week = gestationalWeek;
    if (week <= 12) return 'First';
    if (week <= 26) return 'Second';
    return 'Third';
  }

  int get eddCountdownDays => edd.difference(DateTime.now()).inDays;

  Map<String, dynamic> toJson() => {
        'id': id,
        'fullName': fullName,
        'patientId': patientId,
        'phone': phone,
        'village': village,
        'bloodGroup': bloodGroup,
        'clinicianName': clinicianName,
        'lmp': lmp.millisecondsSinceEpoch,
        'edd': edd.millisecondsSinceEpoch,
        'gravida': gravida,
        'parity': parity,
        'ancVisitsCompleted': ancVisitsCompleted,
        'preferredLanguage': preferredLanguage,
      };

  factory MotherProfile.fromJson(Map<String, dynamic> json) => MotherProfile(
        id: json['id'] as String,
        fullName: json['fullName'] as String,
        patientId: json['patientId'] as String,
        phone: json['phone'] as String,
        village: json['village'] as String,
        bloodGroup: json['bloodGroup'] as String,
        clinicianName: json['clinicianName'] as String,
        lmp: DateTime.fromMillisecondsSinceEpoch(json['lmp'] as int),
        edd: DateTime.fromMillisecondsSinceEpoch(json['edd'] as int),
        gravida: json['gravida'] as int,
        parity: json['parity'] as int,
        ancVisitsCompleted: json['ancVisitsCompleted'] as int,
        preferredLanguage: json['preferredLanguage'] as String,
      );
}

class MotherProfileAdapter extends TypeAdapter<MotherProfile> {
  @override
  final int typeId = 0;

  @override
  MotherProfile read(BinaryReader reader) {
    return MotherProfile(
      id: reader.readString(),
      fullName: reader.readString(),
      patientId: reader.readString(),
      phone: reader.readString(),
      village: reader.readString(),
      bloodGroup: reader.readString(),
      clinicianName: reader.readString(),
      lmp: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
      edd: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
      gravida: reader.readInt(),
      parity: reader.readInt(),
      ancVisitsCompleted: reader.readInt(),
      preferredLanguage: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, MotherProfile obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.fullName);
    writer.writeString(obj.patientId);
    writer.writeString(obj.phone);
    writer.writeString(obj.village);
    writer.writeString(obj.bloodGroup);
    writer.writeString(obj.clinicianName);
    writer.writeInt(obj.lmp.millisecondsSinceEpoch);
    writer.writeInt(obj.edd.millisecondsSinceEpoch);
    writer.writeInt(obj.gravida);
    writer.writeInt(obj.parity);
    writer.writeInt(obj.ancVisitsCompleted);
    writer.writeString(obj.preferredLanguage);
  }
}
