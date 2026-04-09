import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme/app_colors.dart';
import 'web/admin/admin_overview.dart';
// TODO: Replace the home below with the Clinician developer's splash/login screen.
// After login, route to AdminOverview or DhoOverview based on the authenticated user's role.
// import 'web/dho/dho_overview.dart';

void main() {
  runApp(const SafeMotherApp());
}

class SafeMotherApp extends StatelessWidget {
  const SafeMotherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Safe Mother Malawi — Staff Portal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.interTextTheme(),
        scaffoldBackgroundColor: AppColors.pageBg,
      ),
      // Temporary: loads Admin dashboard directly.
      // Replace with Clinician developer's login screen when ready.
      home: const AdminOverview(),
    );
  }
}
