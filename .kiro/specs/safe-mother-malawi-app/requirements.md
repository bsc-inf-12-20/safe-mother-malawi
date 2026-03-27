# Requirements Document

## Introduction

Safe Mother Malawi is a Flutter mobile app (Android/iOS) for pregnant women in Malawi, backed by a NestJS API. This document covers the Pregnant Mother app experience only. The app is designed for low-connectivity environments and supports both smartphone users and feature-phone users via an IVR fallback notice. It is operated under the Ministry of Health, Republic of Malawi. Key features include a Pregnant Women Landing Page as the primary post-login entry point, a dedicated Pregnancy Tracking interface, an Educational Content Module with offline caching, and a Voice-Enabled Guidance Interface supporting Chichewa and English voice commands and text-to-speech output.

## Glossary

- **App**: The Safe Mother Malawi Flutter mobile application.
- **Pregnant_Mother**: A registered pregnant woman using the App.
- **Clinician**: A registered healthcare worker (nurse, midwife, or doctor) assigned to the Pregnant_Mother at a health facility.
- **ANC**: Antenatal Care — scheduled clinic visits during pregnancy.
- **EDD**: Estimated Due Date — the calculated date of expected delivery.
- **LMP**: Last Menstrual Period — used to calculate gestational age and EDD.
- **Danger_Sign**: A clinical symptom or condition that requires immediate medical attention.
- **Health_Check**: A structured weekly self-assessment questionnaire completed by the Pregnant_Mother.
- **IVR**: Interactive Voice Response — a telephone-based interface for feature-phone users.
- **SOS_Alert**: An emergency distress signal sent by a Pregnant_Mother to the system and her assigned Clinician.
- **Backend**: The NestJS REST API server that stores and processes all application data.
- **PIN**: A 4-digit numeric personal identification number used for Pregnant_Mother authentication.
- **Notification**: An in-app or push message delivered to the Pregnant_Mother.
- **Voice_Assistant**: The voice-enabled guidance component of the App that accepts voice commands and produces text-to-speech output.
- **TTS**: Text-to-Speech — the capability to convert written text to audible speech output.
- **Trimester**: One of three gestational periods: First (weeks 1–12), Second (weeks 13–26), Third (weeks 27–40).
- **Gestational_Week**: The current week of pregnancy calculated from the Pregnant_Mother's LMP.

---

## Requirements

### Requirement 1: Application Splash and Onboarding

**User Story:** As a new user, I want to see a branded loading screen when I open the app, so that I understand the app's identity and affiliation before I log in.

#### Acceptance Criteria

1. WHEN the App is launched, THE App SHALL display a splash screen showing the Safe Mother Malawi logo, tagline, version number, and Ministry of Health branding for a minimum of 1.5 seconds.
2. WHEN the splash screen completes loading, THE App SHALL navigate the user to the login screen.
3. WHEN a Pregnant_Mother has previously authenticated, THE App SHALL display a personalised welcome screen showing the Mother's name, current gestational week, trimester, and next ANC appointment before entering the home screen.

---

### Requirement 2: User Authentication

**User Story:** As a Pregnant_Mother, I want to log in using my phone number and a 4-digit PIN, so that I can securely access my personal health information.

#### Acceptance Criteria

1. THE App SHALL present a patient login screen accepting a phone number and 4-digit PIN in Pregnant_Mother mode.
2. WHEN a Pregnant_Mother submits a valid phone number and PIN combination, THE Backend SHALL authenticate the Pregnant_Mother and return a session token within 5 seconds.
3. IF a Pregnant_Mother submits an incorrect PIN 5 consecutive times, THEN THE Backend SHALL lock the account for 15 minutes and THE App SHALL display a lockout message with the remaining wait time.
4. THE App SHALL display a prominent IVR fallback notice ("No smartphone? Dial 800-SAFE-MOM") on the patient login screen.
5. IF a network connection is unavailable during login, THEN THE App SHALL display an offline error message and SHALL NOT attempt to submit credentials.

---

### Requirement 3: Pregnant Women Landing Page

**User Story:** As a Pregnant_Mother, I want to see a visually designed, personalised landing page after login showing my pregnancy progress, upcoming appointments, and quick access to key features, so that I can stay informed and navigate the app efficiently.

#### Acceptance Criteria

1. WHEN a Pregnant_Mother opens the home screen, THE App SHALL display a teal-themed header showing the Mother's first name, current Gestational_Week as a badge, and the current Trimester label.
2. THE App SHALL display a visual pregnancy progress indicator — using a progress bar or dot-step row — showing the weeks completed and remaining within the current Trimester.
3. THE App SHALL display a contextual weekly tip card for the current Gestational_Week containing: the baby's approximate size comparison, a developmental milestone, and one care tip for the mother.
4. THE App SHALL display four quick-access tiles on the landing page: Danger Signs, ANC Visits, Nutrition, and Health Check, each navigating to the corresponding screen on tap.
5. THE App SHALL display a Next ANC Appointment card on the landing page showing the appointment date, facility name, and assigned Clinician name.
6. WHEN the Backend has recorded an active Danger_Sign alert for the Pregnant_Mother, THE App SHALL display a prominent danger sign warning banner at the top of the landing page.
7. THE App SHALL display a persistent SOS emergency button on the landing page that is reachable within one tap.
8. THE App SHALL display a persistent microphone/speaker button on the landing page to activate the Voice_Assistant.

---

### Requirement 4: Danger Sign Awareness Section

**User Story:** As a Pregnant_Mother, I want to access a dedicated danger sign awareness screen from the landing page and quickly alert my clinician if I experience a danger sign, so that I can get timely medical help.

#### Acceptance Criteria

1. THE App SHALL provide a dedicated Danger Signs screen accessible from the quick-access tile on the landing page.
2. THE App SHALL display a list of maternal danger signs including: vaginal bleeding, severe headache or blurred vision, reduced fetal movement for more than 2 hours, sudden swelling of face or hands, and fever above 38°C.
3. FOR EACH danger sign, THE App SHALL display a plain-language description in the Pregnant_Mother's selected language explaining the risk and recommended action.
4. THE App SHALL apply severity colour coding to each danger sign: red for immediately life-threatening signs, amber for urgent signs, and blue for serious signs requiring prompt attention.
5. WHEN a Pregnant_Mother taps the SOS emergency button, THE App SHALL send an SOS_Alert to the Backend containing the Mother's identifier, timestamp, and current GPS coordinates (if location permission is granted).
6. WHEN the Backend receives an SOS_Alert, THE Backend SHALL immediately notify the Mother's assigned Clinician via push notification within 30 seconds.
7. IF location permission has not been granted, THEN THE App SHALL send the SOS_Alert without GPS coordinates and SHALL display a message advising the Pregnant_Mother to state her location verbally when calling for help.

---

### Requirement 5: Weekly Health Check

**User Story:** As a Pregnant_Mother, I want to complete a weekly health self-assessment, so that my clinician can monitor my wellbeing between ANC visits.

#### Acceptance Criteria

1. THE App SHALL present a structured Health_Check questionnaire of up to 8 questions covering: danger signs (severe headache, blurred vision, vaginal bleeding), fetal movement, swelling, fever, and general wellbeing.
2. THE App SHALL display a progress indicator showing the current question number and total question count during the Health_Check.
3. WHEN a Pregnant_Mother answers "Yes" to a question flagged as a Danger_Sign indicator, THE App SHALL immediately display a warning prompt advising the Pregnant_Mother to seek clinic care and offering the SOS button.
4. WHEN a Pregnant_Mother completes the Health_Check, THE Backend SHALL store the responses linked to the Mother's profile with a timestamp.
5. WHEN a completed Health_Check contains one or more Danger_Sign positive responses, THE Backend SHALL generate an alert visible to the Mother's assigned Clinician within 60 seconds.
6. THE App SHALL support three answer options for fetal movement questions: "Yes", "Not sure", and "No", and SHALL treat both "Not sure" and "No" as requiring a follow-up prompt.

---

### Requirement 6: ANC Visit Tracking and Appointment Reminders

**User Story:** As a Pregnant_Mother, I want to view my scheduled and completed ANC visits and receive timely reminders, so that I can attend all recommended appointments.

#### Acceptance Criteria

1. THE App SHALL display a list of all ANC visits for the Pregnant_Mother, showing visit date, facility, clinician name, and status (scheduled, completed, or missed).
2. WHEN an ANC visit is due within 7 days, THE Backend SHALL send a push notification reminder to the Pregnant_Mother.
3. WHEN an ANC visit is due within 1 day, THE Backend SHALL send a second push notification reminder to the Pregnant_Mother.
4. THE App SHALL display an in-app reminder card on the landing page for any ANC visit due within 7 days, showing the appointment date, facility name, and Clinician name.
5. WHEN an ANC visit date passes without a recorded attendance, THE Backend SHALL mark the visit as missed and THE App SHALL display a missed-visit indicator.
6. THE App SHALL display the next upcoming ANC appointment prominently on the landing page and on the ANC visits screen.

---

### Requirement 7: Educational Content Module

**User Story:** As a Pregnant_Mother, I want to access a Learn section with health education articles, weekly tips, and nutrition guidance, so that I can make informed decisions during my pregnancy.

#### Acceptance Criteria

1. THE App SHALL provide a Learn section containing health education articles covering nutrition, hygiene, birth preparedness, and breastfeeding.
2. THE App SHALL display weekly nutrition and health tips relevant to the Pregnant_Mother's current Gestational_Week.
3. THE Backend SHALL serve education content in both Chichewa and English, and THE App SHALL display content in the Pregnant_Mother's selected language.
4. WHERE the device has no internet connection, THE App SHALL display previously cached education articles and tips rather than an empty screen.
5. THE App SHALL cache education content locally on the device so that at least the most recently loaded articles remain accessible offline.

---

### Requirement 8: Pregnancy Tracking Feature

**User Story:** As a Pregnant_Mother, I want a dedicated pregnancy tracking screen showing my gestational progress, baby development milestones, and EDD countdown, so that I can follow my pregnancy week by week.

#### Acceptance Criteria

1. THE App SHALL provide a dedicated Pregnancy Tracking screen displaying the Pregnant_Mother's current Gestational_Week and Trimester.
2. THE App SHALL display a visual week-by-week progress tracker showing all 40 weeks, with completed weeks visually distinguished from remaining weeks.
3. FOR EACH Gestational_Week, THE App SHALL display the baby's approximate size comparison, estimated weight, and a key developmental stage description.
4. THE App SHALL display a Trimester summary section with the week ranges: First Trimester (weeks 1–12), Second Trimester (weeks 13–26), and Third Trimester (weeks 27–40), and SHALL highlight the current Trimester.
5. THE App SHALL display a countdown showing the number of days remaining until the Pregnant_Mother's EDD.
6. WHEN the Pregnant_Mother's EDD is updated by the Backend, THE App SHALL recalculate and display the updated Gestational_Week, Trimester, and EDD countdown on next data sync.

---

### Requirement 9: Voice-Enabled Guidance Interface

**User Story:** As a Pregnant_Mother, I want to navigate the app and hear health information read aloud using voice commands in Chichewa or English, so that I can access guidance hands-free or when I have difficulty reading.

#### Acceptance Criteria

1. THE App SHALL provide a Voice_Assistant accessible from a persistent microphone/speaker button on the landing page.
2. WHEN a Pregnant_Mother activates the Voice_Assistant, THE App SHALL accept voice commands in Chichewa or English to navigate to app screens and retrieve health information.
3. THE Voice_Assistant SHALL use TTS to read aloud danger sign descriptions, weekly health tips, and ANC appointment reminders in the Pregnant_Mother's selected language.
4. WHEN a Pregnant_Mother issues a voice command to trigger an SOS alert, THE App SHALL display a confirmation prompt before sending the SOS_Alert, and SHALL only send the SOS_Alert after the Pregnant_Mother confirms.
5. IF microphone permission has not been granted, THEN THE App SHALL display the Voice_Assistant in text-only mode, providing TTS output without accepting voice input, and SHALL display a message explaining that microphone access is required for voice commands.
6. WHEN microphone permission is granted and the Voice_Assistant is active, THE App SHALL display a visual indicator showing that the microphone is listening.

---

### Requirement 10: Mother Profile

**User Story:** As a Pregnant_Mother, I want to view my profile and see a mode switch option, so that the app reflects my current health status and I can transition to postnatal mode after delivery.

#### Acceptance Criteria

1. THE App SHALL display the Pregnant_Mother's profile including: full name, patient ID, phone number, village/address, blood group, assigned Clinician, LMP, EDD, gravida/parity, and number of ANC visits completed.
2. THE App SHALL display a mode switch UI on the profile screen showing Pregnant and Postnatal options, with the Pregnant option marked as active.
3. THE App SHALL display the Pregnant_Mother's preferred language setting and allow the Pregnant_Mother to change it from the profile screen.
4. THE App SHALL display a sign out button on the profile screen.
5. WHEN a Pregnant_Mother taps sign out, THE App SHALL clear all session data from device memory and navigate to the login screen.

---

### Requirement 11: Notifications

**User Story:** As a Pregnant_Mother, I want to receive timely notifications about appointments and health reminders, so that I stay informed without having to open the app.

#### Acceptance Criteria

1. THE Backend SHALL send push notifications to the Pregnant_Mother for: ANC appointment reminders (7 days and 1 day before), weekly Health_Check reminders, and Danger_Sign alerts triggered by the system.
2. WHEN a Pregnant_Mother taps a push notification, THE App SHALL navigate directly to the relevant screen (e.g. appointment detail or Health_Check).
3. THE App SHALL display an in-app notification centre listing all recent notifications with read/unread status, timestamp, and a brief description.
4. WHERE a device does not support push notifications, THE App SHALL display pending notifications in the in-app notification centre on next app open.

---

### Requirement 12: Offline and Low-Bandwidth Support

**User Story:** As a Pregnant_Mother in a low-connectivity area, I want the app to work with limited or no internet, so that I can still access critical health information.

#### Acceptance Criteria

1. THE App SHALL cache the Pregnant_Mother's profile, last Health_Check results, danger signs content, and education articles locally on the device.
2. WHILE the device has no internet connection, THE App SHALL display cached content and SHALL indicate to the user that the data may not be current.
3. WHEN internet connectivity is restored, THE App SHALL automatically synchronise any locally stored Health_Check responses and profile changes with the Backend.
4. THE App SHALL function for core read operations (viewing danger signs, education content, and profile) without an active internet connection.
5. THE App SHALL minimise data usage by compressing API payloads and serving education content as text rather than media-heavy formats by default.

---

### Requirement 13: Localisation and Language Support

**User Story:** As a Pregnant_Mother in Malawi, I want to use the app in Chichewa, so that I can understand all health information in my native language.

#### Acceptance Criteria

1. THE App SHALL support Chichewa and English as display languages for all patient-facing screens.
2. WHEN a Pregnant_Mother selects Chichewa as her language, THE App SHALL display all UI labels, health tips, danger sign descriptions, and questionnaire text in Chichewa.
3. THE App SHALL default to Chichewa for new patient registrations unless the Pregnant_Mother selects English.

---

### Requirement 14: Security and Data Privacy

**User Story:** As a system operator, I want all patient data to be stored and transmitted securely, so that sensitive health information is protected.

#### Acceptance Criteria

1. THE Backend SHALL transmit all data over HTTPS using TLS 1.2 or higher.
2. THE Backend SHALL store Pregnant_Mother PINs as salted cryptographic hashes and SHALL NOT store PINs in plaintext.
3. THE App SHALL clear all session data from device memory when a Pregnant_Mother explicitly logs out.
4. THE Backend SHALL log all authentication events (login, failed login, logout) with timestamp and device identifier for audit purposes.
