import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/app_notification.dart';

// ---------------------------------------------------------------------------
// Mock notifications
// ---------------------------------------------------------------------------

List<AppNotification> _mockNotifications() {
  final now = DateTime.now();
  return [
    AppNotification(
      id: 'notif-1',
      type: 'anc_reminder',
      title: 'ANC Visit in 4 days',
      body: 'Your next antenatal visit is on ${now.add(const Duration(days: 4)).day} at Zomba Central Hospital.',
      isRead: false,
      timestamp: now.subtract(const Duration(hours: 2)),
      deepLinkRoute: '/anc-visits',
    ),
    AppNotification(
      id: 'notif-2',
      type: 'health_tip',
      title: 'Weekly health tip',
      body: 'Remember to take your iron and folic acid tablets today.',
      isRead: false,
      timestamp: now.subtract(const Duration(hours: 8)),
      deepLinkRoute: '/learn',
    ),
    AppNotification(
      id: 'notif-3',
      type: 'danger_sign',
      title: 'Check fetal movement',
      body: 'Have you felt your baby move today? Count at least 10 movements in 2 hours.',
      isRead: true,
      timestamp: now.subtract(const Duration(days: 1)),
      deepLinkRoute: '/danger-signs',
    ),
    AppNotification(
      id: 'notif-4',
      type: 'health_check',
      title: 'Weekly health check due',
      body: 'It\'s time for your weekly self-assessment. Tap to start.',
      isRead: true,
      timestamp: now.subtract(const Duration(days: 2)),
      deepLinkRoute: '/health-check',
    ),
  ];
}

// ---------------------------------------------------------------------------
// Repository (in-memory state for read/unread)
// ---------------------------------------------------------------------------

class NotificationsRepository extends StateNotifier<List<AppNotification>> {
  NotificationsRepository() : super(_mockNotifications());

  void markRead(String id) {
    state = [
      for (final n in state)
        if (n.id == id)
          AppNotification(
            id: n.id,
            type: n.type,
            title: n.title,
            body: n.body,
            isRead: true,
            timestamp: n.timestamp,
            deepLinkRoute: n.deepLinkRoute,
          )
        else
          n,
    ];
  }

  void markAllRead() {
    state = [
      for (final n in state)
        AppNotification(
          id: n.id,
          type: n.type,
          title: n.title,
          body: n.body,
          isRead: true,
          timestamp: n.timestamp,
          deepLinkRoute: n.deepLinkRoute,
        ),
    ];
  }

  int get unreadCount => state.where((n) => !n.isRead).length;
}

// ---------------------------------------------------------------------------
// Providers
// ---------------------------------------------------------------------------

final notificationsRepositoryProvider =
    StateNotifierProvider<NotificationsRepository, List<AppNotification>>(
  (ref) => NotificationsRepository(),
);

final unreadCountProvider = Provider<int>((ref) {
  final notifications = ref.watch(notificationsRepositoryProvider);
  return notifications.where((n) => !n.isRead).length;
});
