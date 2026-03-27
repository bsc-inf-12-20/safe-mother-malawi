import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/models/health_check.dart';
import '../repositories/health_check_repository.dart';

// ---------------------------------------------------------------------------
// Question model
// ---------------------------------------------------------------------------

enum _AnswerType { yesNo, yesNotSureNo }

class _Question {
  const _Question({
    required this.text,
    required this.category,
    required this.categoryColor,
    required this.answerType,
    required this.isDangerSign,
    this.dangerAnswers = const {},
  });

  final String text;
  final String category;
  final Color categoryColor;
  final _AnswerType answerType;
  final bool isDangerSign;

  /// Which answer values trigger the danger warning.
  final Set<String> dangerAnswers;
}

const _questions = <_Question>[
  _Question(
    text: 'Are you experiencing severe headaches or blurred vision?',
    category: 'DANGER SIGN',
    categoryColor: AppColors.red,
    answerType: _AnswerType.yesNo,
    isDangerSign: true,
    dangerAnswers: {'Yes'},
  ),
  _Question(
    text: 'Any vaginal bleeding this week?',
    category: 'DANGER SIGN',
    categoryColor: AppColors.red,
    answerType: _AnswerType.yesNo,
    isDangerSign: true,
    dangerAnswers: {'Yes'},
  ),
  _Question(
    text: 'Is your baby moving normally today?',
    category: 'FETAL MOVEMENT',
    categoryColor: AppColors.amber,
    answerType: _AnswerType.yesNotSureNo,
    isDangerSign: true,
    dangerAnswers: {'Not sure', 'No'},
  ),
  _Question(
    text: 'Do you have any swelling of your face or hands?',
    category: 'DANGER SIGN',
    categoryColor: AppColors.red,
    answerType: _AnswerType.yesNo,
    isDangerSign: true,
    dangerAnswers: {'Yes'},
  ),
  _Question(
    text: 'Do you have a fever (temperature above 38°C)?',
    category: 'DANGER SIGN',
    categoryColor: AppColors.red,
    answerType: _AnswerType.yesNo,
    isDangerSign: true,
    dangerAnswers: {'Yes'},
  ),
  _Question(
    text: 'Are you able to eat and drink normally?',
    category: 'GENERAL',
    categoryColor: AppColors.blue,
    answerType: _AnswerType.yesNo,
    isDangerSign: false,
    dangerAnswers: {},
  ),
  _Question(
    text: 'How are you feeling generally today?',
    category: 'GENERAL',
    categoryColor: AppColors.blue,
    answerType: _AnswerType.yesNotSureNo,
    isDangerSign: false,
    dangerAnswers: {},
  ),
  _Question(
    text: 'Do you have any concerns you\'d like to share with your clinician?',
    category: 'GENERAL',
    categoryColor: AppColors.blue,
    answerType: _AnswerType.yesNo,
    isDangerSign: false,
    dangerAnswers: {},
  ),
];

List<String> _optionsFor(_AnswerType type, int index) {
  if (type == _AnswerType.yesNo) return ['Yes', 'No'];
  // Question 7 (index 6) uses Good/Okay/Not well
  if (index == 6) return ['Good', 'Okay', 'Not well'];
  return ['Yes', 'Not sure', 'No'];
}

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

class HealthCheckScreen extends ConsumerStatefulWidget {
  const HealthCheckScreen({super.key});

  @override
  ConsumerState<HealthCheckScreen> createState() => _HealthCheckScreenState();
}

class _HealthCheckScreenState extends ConsumerState<HealthCheckScreen> {
  final Map<int, String> _answers = {};
  bool _submitting = false;

  int get _answeredCount => _answers.length;
  bool get _allAnswered => _answeredCount == _questions.length;

  bool _isDangerAnswer(int index, String answer) {
    final q = _questions[index];
    return q.isDangerSign && q.dangerAnswers.contains(answer);
  }

  Future<void> _submit() async {
    if (!_allAnswered || _submitting) return;
    setState(() => _submitting = true);

    final hasDanger = _answers.entries.any((e) => _isDangerAnswer(e.key, e.value));
    final responses = _answers.entries.map((e) {
      return {
        'question': _questions[e.key].text,
        'answer': e.value,
      };
    }).toList();

    final check = HealthCheck(
      id: 'hc_${DateTime.now().millisecondsSinceEpoch}',
      timestamp: DateTime.now(),
      responses: responses,
      hasDangerSign: hasDanger,
    );

    try {
      await ref.read(healthCheckRepositoryProvider).submit(check);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Health check submitted successfully'),
            backgroundColor: AppColors.teal,
          ),
        );
        context.pop();
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Saved offline — will sync when connected'),
            backgroundColor: AppColors.amber,
          ),
        );
        context.pop();
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weekly Health Check'),
        backgroundColor: AppColors.teal,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          _Header(answeredCount: _answeredCount, total: _questions.length),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  for (int i = 0; i < _questions.length; i++) ...[
                    _QuestionCard(
                      index: i,
                      question: _questions[i],
                      selectedAnswer: _answers[i],
                      onAnswerSelected: (answer) {
                        setState(() => _answers[i] = answer);
                      },
                    ),
                    if (_answers[i] != null && _isDangerAnswer(i, _answers[i]!))
                      _DangerWarningCard(
                        onGetHelp: () => context.push('/danger-signs'),
                      ),
                    const SizedBox(height: 12),
                  ],
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _allAnswered && !_submitting ? _submit : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.teal,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: AppColors.outline,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _submitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Submit Health Check',
                              style: TextStyle(
                                fontFamily: 'DM Sans',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Header widget
// ---------------------------------------------------------------------------

class _Header extends StatelessWidget {
  const _Header({required this.answeredCount, required this.total});

  final int answeredCount;
  final int total;

  @override
  Widget build(BuildContext context) {
    final progress = total == 0 ? 0.0 : answeredCount / total;
    return Container(
      width: double.infinity,
      color: AppColors.teal,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Weekly Health Check',
            style: TextStyle(
              fontFamily: 'Fraunces',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Question $answeredCount of $total',
            style: const TextStyle(
              fontFamily: 'DM Sans',
              fontSize: 13,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: Colors.white30,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Question card
// ---------------------------------------------------------------------------

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({
    required this.index,
    required this.question,
    required this.selectedAnswer,
    required this.onAnswerSelected,
  });

  final int index;
  final _Question question;
  final String? selectedAnswer;
  final ValueChanged<String> onAnswerSelected;

  @override
  Widget build(BuildContext context) {
    final options = _optionsFor(question.answerType, index);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category label
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: question.categoryColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                question.category,
                style: TextStyle(
                  fontFamily: 'DM Sans',
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: question.categoryColor,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Question text
            Text(
              question.text,
              style: const TextStyle(
                fontFamily: 'DM Sans',
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 14),
            // Answer buttons
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: options.map((option) {
                final isSelected = selectedAnswer == option;
                return GestureDetector(
                  onTap: () => onAnswerSelected(option),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.teal : Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: isSelected ? AppColors.teal : AppColors.outline,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Text(
                      option,
                      style: TextStyle(
                        fontFamily: 'DM Sans',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : AppColors.onSurface,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Danger warning card
// ---------------------------------------------------------------------------

class _DangerWarningCard extends StatelessWidget {
  const _DangerWarningCard({required this.onGetHelp});

  final VoidCallback onGetHelp;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.red.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.red.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          const Text('⚠️', style: TextStyle(fontSize: 18)),
          const SizedBox(width: 10),
          Expanded(
            child: const Text(
              'This may be a danger sign. Please seek clinic care immediately.',
              style: TextStyle(
                fontFamily: 'DM Sans',
                fontSize: 13,
                color: AppColors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onGetHelp,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.red,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Get help now',
                style: TextStyle(
                  fontFamily: 'DM Sans',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
