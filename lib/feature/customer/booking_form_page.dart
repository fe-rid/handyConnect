import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../data/repositories/auth_repository.dart';
import '../../feature/requests/bloc/requests_cubit.dart';
import '../../theme.dart';

class BookingFormPage extends StatefulWidget {
  const BookingFormPage({super.key, required this.handymanId});
  final String handymanId;

  @override
  State<BookingFormPage> createState() => _BookingFormPageState();
}

class _BookingFormPageState extends State<BookingFormPage> {
  final _desc = TextEditingController();
  DateTime? _time;

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthRepository>().currentUser;
    return Scaffold(
      appBar: AppBar(title: const Text('New request')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _desc,
              minLines: 3,
              maxLines: 6,
              decoration: const InputDecoration(
                labelText: 'Describe the issue',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.schedule, color: Colors.blue),
                    label: Text(_time == null
                        ? 'Preferred time'
                        : DateFormat('EEE, MMM d • HH:mm').format(_time!)),
                    onPressed: () async {
                      final date = await showDatePicker(
                          context: context,
                          firstDate: DateTime.now(),
                          lastDate:
                              DateTime.now().add(const Duration(days: 60)),
                          initialDate: DateTime.now());
                      if (date == null) return;
                      final time = await showTimePicker(
                          context: context, initialTime: TimeOfDay.now());
                      if (time == null) return;
                      setState(() {
                        _time = DateTime(date.year, date.month, date.day,
                            time.hour, time.minute);
                      });
                    },
                  ),
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.send, color: Colors.white),
                label: const Text('Send request',
                    style: TextStyle(color: Colors.white)),
                onPressed:
                    (_time == null || _desc.text.trim().isEmpty || user == null)
                        ? null
                        : () async {
                            await context.read<RequestsCubit>().create(
                                  customerId: user.id,
                                  handymanId: widget.handymanId,
                                  description: _desc.text.trim(),
                                  preferredTime: _time!,
                                );
                            if (context.mounted) Navigator.of(context).pop();
                          },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
