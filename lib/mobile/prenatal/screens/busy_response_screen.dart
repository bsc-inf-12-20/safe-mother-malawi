import 'package:flutter/material.dart';
import '../../../services/api_service.dart';
import '../../../theme/app_colors.dart';

class BusyResponseScreen extends StatefulWidget {
  final String appointmentId;
  final String appointmentTitle;
  final String appointmentDate;
  final String? appointmentTime;

  const BusyResponseScreen({
    super.key,
    required this.appointmentId,
    required this.appointmentTitle,
    required this.appointmentDate,
    this.appointmentTime,
  });

  @override
  State<BusyResponseScreen> createState() => _BusyResponseScreenState();
}

class _BusyResponseScreenState extends State<BusyResponseScreen> {
  String _selectedReason = 'other';
  bool _rescheduleRequested = false;
  DateTime? _preferredRescheduleDate;
  String? _preferredRescheduleTime;
  final _notesController = TextEditingController();
  bool _isSubmitting = false;

  final List<Map<String, String>> _reasons = [
    {'value': 'work_conflict', 'label': 'Work conflict'},
    {'value': 'health_issue', 'label': 'Health issue'},
    {'value': 'transportation', 'label': 'Transportation issue'},
    {'value': 'family_emergency', 'label': 'Family emergency'},
    {'value': 'forgot', 'label': 'Forgot about appointment'},
    {'value': 'other', 'label': 'Other reason'},
  ];

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submitBusyResponse() async {
    if (_rescheduleRequested && _preferredRescheduleDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a preferred reschedule date'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final payload = {
        'reason': _selectedReason,
        'additionalNotes': _notesController.text.isEmpty ? null : _notesController.text,
        'rescheduleRequested': _rescheduleRequested,
        if (_preferredRescheduleDate != null)
          'preferredRescheduleDate': _preferredRescheduleDate!.toIso8601String(),
        if (_preferredRescheduleTime != null) 'preferredRescheduleTime': _preferredRescheduleTime,
      };

      await ApiService.instance.post(
        '/appointments/${widget.appointmentId}/busy',
        payload,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Your response has been recorded. Your clinician will contact you soon.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cannot Attend Appointment'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Appointment details
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.infoBg,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.appointmentTitle,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16, color: AppColors.mutedText),
                      const SizedBox(width: 8),
                      Text(
                        widget.appointmentDate,
                        style: const TextStyle(fontSize: 14, color: AppColors.onSurface),
                      ),
                    ],
                  ),
                  if (widget.appointmentTime != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 16, color: AppColors.mutedText),
                        const SizedBox(width: 8),
                        Text(
                          widget.appointmentTime!,
                          style: const TextStyle(fontSize: 14, color: AppColors.onSurface),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Reason selection
            const Text(
              'Why can\'t you attend?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.headings,
              ),
            ),
            const SizedBox(height: 12),
            ..._reasons.map((reason) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: RadioListTile<String>(
                  title: Text(reason['label']!),
                  value: reason['value']!,
                  groupValue: _selectedReason,
                  onChanged: (value) {
                    setState(() => _selectedReason = value!);
                  },
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              );
            }),
            const SizedBox(height: 20),

            // Additional notes
            const Text(
              'Additional notes (optional)',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.headings,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _notesController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Tell your clinician more about your situation...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
            const SizedBox(height: 20),

            // Reschedule request
            CheckboxListTile(
              title: const Text('I want to reschedule this appointment'),
              value: _rescheduleRequested,
              onChanged: (value) {
                setState(() => _rescheduleRequested = value ?? false);
              },
              contentPadding: EdgeInsets.zero,
              dense: true,
            ),
            const SizedBox(height: 12),

            // Preferred reschedule date/time
            if (_rescheduleRequested) ...[
              const Text(
                'Preferred reschedule date',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.headings,
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(const Duration(days: 1)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 90)),
                  );
                  if (picked != null) {
                    setState(() => _preferredRescheduleDate = picked);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primary),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, color: AppColors.primary),
                      const SizedBox(width: 12),
                      Text(
                        _preferredRescheduleDate != null
                            ? _preferredRescheduleDate!.toString().split(' ')[0]
                            : 'Select date',
                        style: TextStyle(
                          fontSize: 14,
                          color: _preferredRescheduleDate != null
                              ? AppColors.onSurface
                              : AppColors.mutedText,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Preferred time (optional)',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.headings,
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (picked != null) {
                    setState(() => _preferredRescheduleTime = picked.format(context));
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primary),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.access_time, color: AppColors.primary),
                      const SizedBox(width: 12),
                      Text(
                        _preferredRescheduleTime ?? 'Select time',
                        style: TextStyle(
                          fontSize: 14,
                          color: _preferredRescheduleTime != null
                              ? AppColors.onSurface
                              : AppColors.mutedText,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Submit button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitBusyResponse,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  disabledBackgroundColor: AppColors.mutedText,
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Submit Response',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Your clinician will review your response and contact you to reschedule if needed.',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.mutedText,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
