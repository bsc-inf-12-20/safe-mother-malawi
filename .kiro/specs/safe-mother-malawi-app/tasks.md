# Implementation Plan: Safe Mother Malawi — Pregnant Mother Flutter App

## Overview

Incremental implementation of the Safe Mother Malawi Flutter mobile app, building from project scaffolding through core infrastructure, feature screens, offline support, localisation, and voice guidance. Each task builds on the previous and ends with all code wired together. Backend NestJS tasks are included where API contracts must be established to unblock Flutter work.

---

## Tasks

- [x] 1. Project setup — pubspec, theme, router, folder structure
  - [x] 1.1 Add all required dependencies to `pubspec.yaml`
    - Add: `dio`, `hive`, `hive_flutter`, `hive_generator`, `build_runner`, `go_router`, `flutter_riverpod` (or `provider`), `connectivity_plus`, `flutter_secure_storage`, `flutter_tts`, `speech_to_text`, `geolocator`, `permission_handler`, `flutter_local_notifications`, `cached_network_image`, `intl`, `flutter_localizations`, `freezed`, `freezed_annotation`, `json_annotation`, `json_serializable`
    - _Requirements: 1.1, 2.1, 4.5, 7.4, 9.1, 12.1_
  - [x] 1.2 Create feature-first folder structure under `lib/`
    - Directories: `core/`, `features/auth/`, `features/home/`, `features/pregnancy_tracking/`, `features/danger_signs/`, `features/health_check/`, `features/anc_visits/`, `features/learn/`, `features/profile/`, `features/notifications/`, `features/voice/`, `l10n/`
    - _Requirements: all_
  - [x] 1.3 Define `AppTheme` in `lib/core/theme/app_theme.dart`
    - Teal primary colour (`#00897B`), red danger accent, amber warning accent, blue info accent, typography scale, card/button styles
    - _Requirements: 3.1, 4.4_
  - [x] 1.4 Configure `GoRouter` in `lib/core/router/app_router.dart`
    - Named routes for: `/splash`, `/login`, `/home`, `/pregnancy-tracking`, `/danger-signs`, `/health-check`, `/anc-visits`, `/learn`, `/profile`, `/notifications`, `/voice`
    - Guard redirecting unauthenticated users to `/login`
    - _Requirements: 1.2, 2.1_

- [x] 2. Core layer — API client, Hive, connectivity, auth interceptor
  - [x] 2.1 Implement `ApiClient` in `lib/core/network/api_client.dart` using Dio
    - Base URL from environment config, JSON content-type headers, 10 s timeout
    - _Requirements: 2.2, 14.1_
  - [x] 2.2 Add `AuthInterceptor` to Dio that attaches Bearer token from `flutter_secure_storage`
    - On 401 response: clear token and redirect to `/login`
    - _Requirements: 2.2, 14.3_
  - [x] 2.3 Implement `ConnectivityService` in `lib/core/services/connectivity_service.dart`
    - Expose `Stream<bool> isOnline` using `connectivity_plus`
    - _Requirements: 12.2, 12.3_
  - [x] 2.4 Initialise Hive in `main.dart` and register all box names as constants in `lib/core/storage/hive_boxes.dart`
    - Boxes: `authBox`, `profileBox`, `healthCheckBox`, `ancBox`, `learnBox`, `notificationsBox`, `syncQueueBox`
    - _Requirements: 12.1_
  - [ ]* 2.5 Write unit tests for `ConnectivityService` and `AuthInterceptor`
    - Test token attachment, 401 redirect, online/offline stream emissions
    - _Requirements: 2.2, 12.2_

- [x] 3. Data models with Hive adapters
  - [x] 3.1 Create `MotherProfile` model (`lib/core/models/mother_profile.dart`)
    - Fields: id, fullName, patientId, phone, village, bloodGroup, clinicianName, lmp, edd, gravida, parity, ancVisitsCompleted, preferredLanguage
    - Annotate with `@HiveType` / `@HiveField`, generate adapter via `build_runner`
    - _Requirements: 10.1, 12.1_
  - [x] 3.2 Create `AncVisit` model (`lib/core/models/anc_visit.dart`)
    - Fields: id, date, facility, clinicianName, status (scheduled/completed/missed)
    - _Requirements: 6.1, 6.5_
  - [x] 3.3 Create `HealthCheck` model (`lib/core/models/health_check.dart`)
    - Fields: id, timestamp, responses (List of question/answer pairs), hasDangerSign
    - _Requirements: 5.1, 5.4_
  - [x] 3.4 Create `DangerSign` model (`lib/core/models/danger_sign.dart`)
    - Fields: id, title, description (localised map), severity (red/amber/blue)
    - _Requirements: 4.2, 4.3, 4.4_
  - [x] 3.5 Create `EducationArticle` model (`lib/core/models/education_article.dart`)
    - Fields: id, title, body, category, gestationalWeek, language, cachedAt
    - _Requirements: 7.1, 7.5_
  - [x] 3.6 Create `AppNotification` model (`lib/core/models/app_notification.dart`)
    - Fields: id, type, title, body, isRead, timestamp, deepLinkRoute
    - _Requirements: 11.3_
  - [x] 3.7 Create `SyncQueueItem` model (`lib/core/models/sync_queue_item.dart`)
    - Fields: id, endpoint, payload (JSON string), createdAt, retryCount
    - _Requirements: 12.3_
  - [x] 3.8 Run `flutter pub run build_runner build` to generate all Hive adapters and Freezed/JSON serialisation code
    - _Requirements: 12.1_
  - [ ]* 3.9 Write property tests for model serialisation round-trips
    - **Property 1: Serialise → deserialise → serialise produces identical output for all 7 models**
    - **Validates: Requirements 12.1**

- [x] 4. Backend — Auth endpoints (NestJS)
  - [x] 4.1 Create `AuthModule` with `POST /auth/login` endpoint accepting `{ phone, pin }`
    - Return `{ accessToken, expiresIn }` on success; hash PIN comparison using bcrypt
    - _Requirements: 2.2, 14.2_
  - [x] 4.2 Implement account lockout logic: 5 failed attempts → 15-minute lock, return remaining seconds in error body
    - _Requirements: 2.3_
  - [x] 4.3 Log all auth events (login, failed login, logout) to an `auth_audit` table with timestamp and device ID header
    - _Requirements: 14.4_
  - [ ]* 4.4 Write NestJS unit tests for login, lockout, and audit logging
    - _Requirements: 2.2, 2.3, 14.4_

- [x] 5. Auth feature — Splash screen and Login screen
  - [x] 5.1 Implement `SplashScreen` (`lib/features/auth/screens/splash_screen.dart`)
    - Show logo, tagline, version, Ministry of Health branding for ≥ 1.5 s
    - After delay: if stored token exists → navigate to `/home`, else → `/login`
    - _Requirements: 1.1, 1.2_
  - [x] 5.2 Implement `LoginScreen` (`lib/features/auth/screens/login_screen.dart`)
    - Phone number field + 4-digit PIN input (obscured), submit button
    - IVR fallback notice: "No smartphone? Dial 800-SAFE-MOM"
    - Disable submit and show offline banner when `ConnectivityService.isOnline == false`
    - _Requirements: 2.1, 2.4, 2.5_
  - [x] 5.3 Implement `AuthRepository` (`lib/features/auth/repositories/auth_repository.dart`)
    - `login(phone, pin)` → POST `/auth/login`, store token in `flutter_secure_storage`
    - `logout()` → clear token and Hive `authBox`
    - _Requirements: 2.2, 14.3_
  - [x] 5.4 Wire lockout error response to display remaining wait time on `LoginScreen`
    - _Requirements: 2.3_
  - [ ]* 5.5 Write widget tests for `LoginScreen` — offline banner, PIN masking, lockout message
    - _Requirements: 2.3, 2.4, 2.5_

- [ ] 6. Checkpoint — Auth flow complete
  - Ensure splash → login → home navigation works end-to-end. Ask the user if questions arise.

- [x] 7. Home / Landing page feature
  - [x] 7.1 Implement `HomeScreen` (`lib/features/home/screens/home_screen.dart`) with teal header
    - Show mother's first name, gestational week badge, trimester label
    - _Requirements: 3.1_
  - [x] 7.2 Add `PregnancyProgressBar` widget showing weeks completed/remaining in current trimester
    - _Requirements: 3.2_
  - [x] 7.3 Add `WeeklyTipCard` widget showing baby size comparison, developmental milestone, care tip for current gestational week
    - _Requirements: 3.3_
  - [x] 7.4 Add four `QuickAccessTile` widgets: Danger Signs, ANC Visits, Nutrition (→ Learn), Health Check
    - Each navigates to the corresponding named route on tap
    - _Requirements: 3.4_
  - [x] 7.5 Add `NextAncCard` widget showing next appointment date, facility, clinician name
    - _Requirements: 3.5, 6.6_
  - [x] 7.6 Add `DangerSignBanner` widget — shown only when backend reports an active danger sign alert
    - _Requirements: 3.6_
  - [x] 7.7 Add persistent `SosButton` (FAB or fixed bottom widget) navigating to danger signs SOS flow
    - _Requirements: 3.7, 4.5_
  - [x] 7.8 Add persistent `VoiceAssistantButton` (microphone/speaker icon) opening voice overlay
    - _Requirements: 3.8, 9.1_
  - [x] 7.9 Implement `HomeRepository` fetching mother summary (gestational week, trimester, next ANC, active alerts) from `GET /mothers/me/summary`
    - Cache response in Hive `profileBox`; serve cache when offline
    - _Requirements: 3.1, 12.1, 12.2_
  - [ ]* 7.10 Write widget tests for `HomeScreen` — danger banner visibility, SOS button presence, quick-access tile navigation
    - _Requirements: 3.4, 3.6, 3.7_

- [x] 8. Pregnancy tracking feature
  - [x] 8.1 Implement `PregnancyTrackingScreen` (`lib/features/pregnancy_tracking/screens/pregnancy_tracking_screen.dart`)
    - Display current gestational week, trimester label, EDD countdown in days
    - _Requirements: 8.1, 8.5_
  - [x] 8.2 Add `WeekProgressTracker` widget — 40-week dot/step row with completed weeks visually distinguished
    - _Requirements: 8.2_
  - [x] 8.3 Add `WeekDetailCard` widget for the current week showing baby size, estimated weight, developmental stage description
    - _Requirements: 8.3_
  - [x] 8.4 Add `TrimesterSummarySection` widget highlighting the active trimester with week ranges (1–12, 13–26, 27–40)
    - _Requirements: 8.4_
  - [x] 8.5 Implement `PregnancyRepository` fetching gestational data from `GET /mothers/me/pregnancy` and recalculating EDD countdown on sync
    - _Requirements: 8.6_
  - [ ]* 8.6 Write property test for EDD countdown calculation
    - **Property 2: For any LMP date L and current date D where D ≥ L, eddCountdown(L, D) = (L + 280 days) − D, and result is never negative after EDD**
    - **Validates: Requirements 8.5, 8.6**

- [x] 9. Danger signs feature
  - [x] 9.1 Implement `DangerSignsScreen` (`lib/features/danger_signs/screens/danger_signs_screen.dart`)
    - List all danger signs with severity colour coding (red/amber/blue)
    - Plain-language description in selected language
    - _Requirements: 4.1, 4.2, 4.3, 4.4_
  - [x] 9.2 Implement `SosAlertService` (`lib/features/danger_signs/services/sos_alert_service.dart`)
    - `sendSos()` → POST `/alerts/sos` with motherId, timestamp, GPS coords (if permission granted)
    - If location permission denied: send without coords, show advisory message
    - _Requirements: 4.5, 4.7_
  - [x] 9.3 Wire SOS button on `DangerSignsScreen` and `HomeScreen` to `SosAlertService`
    - _Requirements: 4.5_
  - [x] 9.4 Backend: implement `POST /alerts/sos` endpoint that stores alert and pushes FCM notification to assigned clinician within 30 s
    - _Requirements: 4.6_
  - [ ]* 9.5 Write unit tests for `SosAlertService` — with/without GPS, offline queuing
    - _Requirements: 4.5, 4.7_

- [-] 10. Weekly health check feature
  - [x] 10.1 Implement `HealthCheckScreen` (`lib/features/health_check/screens/health_check_screen.dart`)
    - Render up to 8 questions sequentially with progress indicator (e.g. "Question 2 of 8")
    - Fetal movement question uses three-option answer: Yes / Not sure / No
    - _Requirements: 5.1, 5.2, 5.6_
  - [x] 10.2 Implement danger sign detection logic: when a flagged question is answered "Yes", "Not sure", or "No" (for fetal movement), show warning prompt with SOS button
    - _Requirements: 5.3_
  - [ ] 10.3 Implement `HealthCheckRepository` (`lib/features/health_check/repositories/health_check_repository.dart`)
    - `submit(HealthCheck)` → POST `/health-checks`; if offline, enqueue in `syncQueueBox`
    - _Requirements: 5.4, 12.3_
  - [ ] 10.4 Backend: `POST /health-checks` stores responses and, if `hasDangerSign == true`, creates clinician alert within 60 s
    - _Requirements: 5.5_
  - [ ]* 10.5 Write property test for danger sign detection
    - **Property 3: For any health check response set R, hasDangerSign(R) == true iff at least one flagged question has a positive/uncertain answer**
    - **Validates: Requirements 5.3, 5.5**
  - [ ]* 10.6 Write widget tests for `HealthCheckScreen` — progress indicator, warning prompt on danger answer, SOS button visibility
    - _Requirements: 5.2, 5.3_

- [ ] 11. ANC visits feature
  - [ ] 11.1 Implement `AncVisitsScreen` (`lib/features/anc_visits/screens/anc_visits_screen.dart`)
    - List all visits with date, facility, clinician, status badge (scheduled/completed/missed)
    - Highlight next upcoming visit prominently
    - _Requirements: 6.1, 6.6_
  - [ ] 11.2 Implement `AncRepository` fetching visits from `GET /mothers/me/anc-visits` and caching in Hive `ancBox`
    - _Requirements: 6.1, 12.1_
  - [ ] 11.3 Backend: implement push notification job for 7-day and 1-day ANC reminders using FCM
    - Mark visit as missed when date passes without recorded attendance
    - _Requirements: 6.2, 6.3, 6.5_
  - [ ]* 11.4 Write unit tests for `AncRepository` — cache read when offline, missed-visit status mapping
    - _Requirements: 6.1, 6.5_

- [ ] 12. Educational content module (Learn screen)
  - [ ] 12.1 Implement `LearnScreen` (`lib/features/learn/screens/learn_screen.dart`)
    - Tabs or sections: Articles, Weekly Tips, Nutrition
    - Display content in selected language (Chichewa/English)
    - Show offline banner when serving cached content
    - _Requirements: 7.1, 7.2, 7.3, 7.4_
  - [ ] 12.2 Implement `ArticleDetailScreen` rendering full article body
    - _Requirements: 7.1_
  - [ ] 12.3 Implement `LearnRepository` (`lib/features/learn/repositories/learn_repository.dart`)
    - Fetch articles from `GET /content/articles?lang=&week=`, cache in Hive `learnBox` with `cachedAt` timestamp
    - Serve from cache when offline
    - _Requirements: 7.4, 7.5, 12.1_
  - [ ]* 12.4 Write property test for offline content cache
    - **Property 4: If articles were cached at time T, then at any time T' > T with no connectivity, LearnRepository returns the same cached articles**
    - **Validates: Requirements 7.4, 7.5, 12.1**
  - [ ]* 12.5 Write widget tests for `LearnScreen` — offline banner display, language switching
    - _Requirements: 7.3, 7.4_

- [ ] 13. Checkpoint — Core features complete
  - Ensure home, pregnancy tracking, danger signs, health check, ANC visits, and learn screens all render and navigate correctly. Ask the user if questions arise.

- [ ] 14. Mother profile screen
  - [ ] 14.1 Implement `ProfileScreen` (`lib/features/profile/screens/profile_screen.dart`)
    - Display all profile fields: name, patient ID, phone, village, blood group, clinician, LMP, EDD, gravida/parity, ANC visits completed
    - _Requirements: 10.1_
  - [ ] 14.2 Add `ModeSwitchWidget` showing Pregnant (active) and Postnatal options
    - _Requirements: 10.2_
  - [ ] 14.3 Add language preference selector (Chichewa / English) that persists to Hive and triggers app locale rebuild
    - _Requirements: 10.3, 13.1, 13.2_
  - [ ] 14.4 Add sign-out button that calls `AuthRepository.logout()`, clears Hive session data, and navigates to `/login`
    - _Requirements: 10.4, 10.5, 14.3_

- [ ] 15. In-app notification centre
  - [ ] 15.1 Implement `NotificationsScreen` (`lib/features/notifications/screens/notifications_screen.dart`)
    - List notifications with read/unread indicator, timestamp, brief description
    - Tap navigates to `deepLinkRoute`
    - _Requirements: 11.3, 11.4_
  - [ ] 15.2 Implement `flutter_local_notifications` setup in `lib/core/services/notification_service.dart`
    - Handle FCM payload → local notification; on tap → navigate via `GoRouter`
    - _Requirements: 11.2_
  - [ ] 15.3 Implement `NotificationsRepository` storing received notifications in Hive `notificationsBox`
    - Mark as read on open; serve from cache when offline
    - _Requirements: 11.3, 11.4_
  - [ ]* 15.4 Write unit tests for `NotificationsRepository` — unread count, mark-as-read, deep-link routing
    - _Requirements: 11.2, 11.3_

- [ ] 16. Voice-enabled guidance interface
  - [ ] 16.1 Implement `VoiceAssistantOverlay` widget (`lib/features/voice/widgets/voice_assistant_overlay.dart`)
    - Microphone listening indicator when active
    - Text-only mode when microphone permission denied (show advisory message)
    - _Requirements: 9.1, 9.5, 9.6_
  - [ ] 16.2 Implement `TtsService` (`lib/features/voice/services/tts_service.dart`) using `flutter_tts`
    - Read aloud danger sign descriptions, weekly tips, ANC reminders in selected language (Chichewa/English)
    - _Requirements: 9.3_
  - [ ] 16.3 Implement `SpeechService` (`lib/features/voice/services/speech_service.dart`) using `speech_to_text`
    - Accept voice commands in Chichewa or English; map recognised phrases to `GoRouter` navigation actions
    - _Requirements: 9.2_
  - [ ] 16.4 Implement SOS voice command flow: on SOS phrase detected, show confirmation dialog before calling `SosAlertService.sendSos()`
    - _Requirements: 9.4_
  - [ ]* 16.5 Write unit tests for `TtsService` — language switching, content read-aloud mapping
    - _Requirements: 9.3_
  - [ ]* 16.6 Implement Chichewa phrase recognition dictionary for common navigation commands
    - Map Chichewa phrases to screen routes and health info queries
    - _Requirements: 9.2_

- [ ] 17. Localisation — ARB files and app locale wiring
  - [ ] 17.1 Create `lib/l10n/app_en.arb` with all English string keys for every patient-facing screen
    - Keys covering: auth, home, pregnancy tracking, danger signs, health check, ANC visits, learn, profile, notifications, voice assistant
    - _Requirements: 13.1_
  - [ ] 17.2 Create `lib/l10n/app_ny.arb` (Chichewa) with translations for all keys in `app_en.arb`
    - _Requirements: 13.2, 13.3_
  - [ ] 17.3 Configure `flutter_localizations` and `intl` in `pubspec.yaml` and `MaterialApp`
    - Default locale: `ny` (Chichewa); fallback: `en`
    - _Requirements: 13.3_
  - [ ] 17.4 Replace all hardcoded strings in every screen with `AppLocalizations` lookups
    - _Requirements: 13.1, 13.2_
  - [ ]* 17.5 Write property test for localisation completeness
    - **Property 5: For every key K in `app_en.arb`, a corresponding key K exists in `app_ny.arb` (no missing translations)**
    - **Validates: Requirements 13.1, 13.2**

- [ ] 18. Offline sync — Hive cache, connectivity, sync queue
  - [ ] 18.1 Implement `SyncService` (`lib/core/services/sync_service.dart`)
    - On connectivity restored: drain `syncQueueBox`, POST each queued item to its endpoint, remove on success, increment `retryCount` on failure (max 3 retries)
    - _Requirements: 12.3_
  - [ ] 18.2 Wire `SyncService` to `ConnectivityService` stream so sync triggers automatically on reconnect
    - _Requirements: 12.3_
  - [ ] 18.3 Add offline indicator banner (shown app-wide when `isOnline == false`) with "Data may not be current" message
    - _Requirements: 12.2_
  - [ ] 18.4 Ensure all repositories fall back to Hive cache for read operations when offline
    - Profile, danger signs, education articles, last health check, ANC visits
    - _Requirements: 12.1, 12.4_
  - [ ]* 18.5 Write property test for sync queue integrity
    - **Property 6: For any sequence of N offline submissions followed by connectivity restore, SyncService posts exactly N items and the queue is empty after successful sync**
    - **Validates: Requirements 12.3**
  - [ ]* 18.6 Write unit tests for `SyncService` — retry logic, max retry cap, queue drain order
    - _Requirements: 12.3_

- [ ] 19. Security hardening
  - [ ] 19.1 Ensure all Dio requests use HTTPS base URL; add `BadCertificateCallback` rejection in non-debug builds
    - _Requirements: 14.1_
  - [ ] 19.2 Verify `AuthRepository.logout()` clears `flutter_secure_storage` token, all Hive boxes, and in-memory state
    - _Requirements: 14.3_

- [ ] 20. Final checkpoint — Full integration
  - Wire all features together: confirm router guards, offline banner, SOS flow, voice overlay, notification deep links, and language switching all function end-to-end. Ask the user if questions arise.

---

## Notes

- Tasks marked with `*` are optional and can be skipped for a faster MVP
- Each task references specific requirements for traceability
- Property tests validate universal correctness properties; unit/widget tests validate specific examples and edge cases
- Backend tasks (4, 9.4, 10.4, 11.3) are included only where the API contract must exist before Flutter work can proceed
- Chichewa locale code used is `ny` (ISO 639-1)
