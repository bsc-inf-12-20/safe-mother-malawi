import 'package:hive/hive.dart';

import 'mother_profile.dart';
import 'anc_visit.dart';
import 'health_check.dart';
import 'danger_sign.dart';
import 'education_article.dart';
import 'app_notification.dart';
import 'sync_queue_item.dart';

void registerHiveAdapters() {
  Hive.registerAdapter(MotherProfileAdapter());
  Hive.registerAdapter(AncVisitAdapter());
  Hive.registerAdapter(HealthCheckAdapter());
  Hive.registerAdapter(DangerSignAdapter());
  Hive.registerAdapter(EducationArticleAdapter());
  Hive.registerAdapter(AppNotificationAdapter());
  Hive.registerAdapter(SyncQueueItemAdapter());
}
