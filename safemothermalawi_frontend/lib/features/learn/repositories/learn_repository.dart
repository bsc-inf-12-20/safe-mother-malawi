import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/education_article.dart';

// ---------------------------------------------------------------------------
// Mock articles
// ---------------------------------------------------------------------------

final _mockArticles = [
  EducationArticle(
    id: 'art-1',
    title: 'Eating well during pregnancy',
    body: 'A balanced diet during pregnancy helps your baby grow strong. '
        'Eat plenty of green vegetables, beans, eggs, and fish. '
        'Drink at least 8 glasses of clean water every day. '
        'Avoid raw meat, alcohol, and too much salt.',
    category: 'Nutrition',
    gestationalWeek: 0,
    language: 'en',
    cachedAt: DateTime.now(),
  ),
  EducationArticle(
    id: 'art-2',
    title: 'Iron and folic acid tablets',
    body: 'Take your iron and folic acid tablets every day as prescribed. '
        'These prevent anaemia and protect your baby\'s brain development. '
        'Take them with food to reduce nausea. '
        'Do not skip doses — they are very important.',
    category: 'Nutrition',
    gestationalWeek: 0,
    language: 'en',
    cachedAt: DateTime.now(),
  ),
  EducationArticle(
    id: 'art-3',
    title: 'Sleeping safely in pregnancy',
    body: 'After 20 weeks, sleep on your left side. '
        'This improves blood flow to your baby. '
        'Use a pillow between your knees for comfort. '
        'Avoid lying flat on your back for long periods.',
    category: 'Wellness',
    gestationalWeek: 20,
    language: 'en',
    cachedAt: DateTime.now(),
  ),
  EducationArticle(
    id: 'art-4',
    title: 'Malaria prevention',
    body: 'Sleep under an insecticide-treated mosquito net every night. '
        'Take your malaria prevention medicine (IPTp) at each ANC visit. '
        'Wear long sleeves in the evening. '
        'If you have fever, go to the clinic immediately.',
    category: 'Health',
    gestationalWeek: 0,
    language: 'en',
    cachedAt: DateTime.now(),
  ),
  EducationArticle(
    id: 'art-5',
    title: 'Preparing for birth',
    body: 'Plan your birth at a health facility with a skilled attendant. '
        'Pack a bag with clothes for you and your baby, your health passport, and money. '
        'Arrange transport in advance. '
        'Know the danger signs that mean you must go to the clinic immediately.',
    category: 'Birth Prep',
    gestationalWeek: 28,
    language: 'en',
    cachedAt: DateTime.now(),
  ),
  EducationArticle(
    id: 'art-6',
    title: 'Fetal movement counting',
    body: 'From week 28, count your baby\'s movements every day. '
        'Your baby should move at least 10 times in 2 hours. '
        'If you feel fewer than 10 movements, drink cold water and lie on your left side. '
        'If movement does not improve, go to the clinic immediately.',
    category: 'Wellness',
    gestationalWeek: 28,
    language: 'en',
    cachedAt: DateTime.now(),
  ),
];

// ---------------------------------------------------------------------------
// Repository
// ---------------------------------------------------------------------------

class LearnRepository {
  List<EducationArticle> fetchArticles() => _mockArticles;

  List<String> get categories =>
      _mockArticles.map((a) => a.category).toSet().toList();
}

// ---------------------------------------------------------------------------
// Providers
// ---------------------------------------------------------------------------

final learnRepositoryProvider =
    Provider<LearnRepository>((ref) => LearnRepository());

final learnArticlesProvider = Provider<List<EducationArticle>>((ref) {
  return ref.read(learnRepositoryProvider).fetchArticles();
});
