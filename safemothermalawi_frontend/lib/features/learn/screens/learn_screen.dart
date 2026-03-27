import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/education_article.dart';
import '../../../core/theme/app_theme.dart';
import '../repositories/learn_repository.dart';

class LearnScreen extends ConsumerStatefulWidget {
  const LearnScreen({super.key});

  @override
  ConsumerState<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends ConsumerState<LearnScreen> {
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final articles = ref.watch(learnArticlesProvider);
    final categories = ['All', ...ref.read(learnRepositoryProvider).categories];

    final filtered = _selectedCategory == 'All'
        ? articles
        : articles.where((a) => a.category == _selectedCategory).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.teal,
        title: const Text('Learn'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            color: AppColors.teal,
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: const Text(
              'Health information for a safe pregnancy.',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),

          // Category chips
          SizedBox(
            height: 52,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final cat = categories[i];
                final selected = cat == _selectedCategory;
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = cat),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.teal : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: selected ? AppColors.teal : AppColors.outline,
                      ),
                    ),
                    child: Text(
                      cat,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: selected ? Colors.white : AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Articles list
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) => _ArticleCard(article: filtered[i]),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Article card
// ---------------------------------------------------------------------------

class _ArticleCard extends StatelessWidget {
  const _ArticleCard({required this.article});
  final EducationArticle article;

  static const _categoryEmoji = {
    'Nutrition': '🥗',
    'Wellness': '💚',
    'Health': '🏥',
    'Birth Prep': '👶',
  };

  @override
  Widget build(BuildContext context) {
    final emoji = _categoryEmoji[article.category] ?? '📖';

    return GestureDetector(
      onTap: () => _openDetail(context),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.tealLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(emoji, style: const TextStyle(fontSize: 22)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    article.body,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.tealLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      article.category,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.tealDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.onSurfaceVariant),
          ],
        ),
      ),
    );
  }

  void _openDetail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ArticleDetailScreen(article: article),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Article detail screen
// ---------------------------------------------------------------------------

class ArticleDetailScreen extends StatelessWidget {
  const ArticleDetailScreen({super.key, required this.article});
  final EducationArticle article;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.teal,
        title: Text(article.category),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              article.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Container(
              height: 2,
              width: 40,
              color: AppColors.teal,
            ),
            const SizedBox(height: 16),
            Text(
              article.body,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    height: 1.7,
                    color: AppColors.onSurface,
                  ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.tealLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: AppColors.teal, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Always consult your clinician for personal medical advice.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.tealDark,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
