import 'package:hive/hive.dart';

class EducationArticle {
  final String id;
  final String title;
  final String body;
  final String category;
  final int gestationalWeek;
  final String language;
  final DateTime cachedAt;

  const EducationArticle({
    required this.id,
    required this.title,
    required this.body,
    required this.category,
    required this.gestationalWeek,
    required this.language,
    required this.cachedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'category': category,
        'gestationalWeek': gestationalWeek,
        'language': language,
        'cachedAt': cachedAt.millisecondsSinceEpoch,
      };

  factory EducationArticle.fromJson(Map<String, dynamic> json) =>
      EducationArticle(
        id: json['id'] as String,
        title: json['title'] as String,
        body: json['body'] as String,
        category: json['category'] as String,
        gestationalWeek: json['gestationalWeek'] as int,
        language: json['language'] as String,
        cachedAt:
            DateTime.fromMillisecondsSinceEpoch(json['cachedAt'] as int),
      );
}

class EducationArticleAdapter extends TypeAdapter<EducationArticle> {
  @override
  final int typeId = 4;

  @override
  EducationArticle read(BinaryReader reader) {
    return EducationArticle(
      id: reader.readString(),
      title: reader.readString(),
      body: reader.readString(),
      category: reader.readString(),
      gestationalWeek: reader.readInt(),
      language: reader.readString(),
      cachedAt: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
    );
  }

  @override
  void write(BinaryWriter writer, EducationArticle obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.title);
    writer.writeString(obj.body);
    writer.writeString(obj.category);
    writer.writeInt(obj.gestationalWeek);
    writer.writeString(obj.language);
    writer.writeInt(obj.cachedAt.millisecondsSinceEpoch);
  }
}
