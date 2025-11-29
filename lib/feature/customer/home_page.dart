import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/enums.dart';
import '../../theme.dart';

class CustomerHomePage extends StatefulWidget {
  const CustomerHomePage({super.key});

  @override
  State<CustomerHomePage> createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
  ServiceCategory? _selected;
  final _locationCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('HandyConnect'),
        actions: [
          IconButton(
            tooltip: 'My requests',
            onPressed: () => context.go('/requests'),
            icon: const Icon(Icons.receipt_long, color: Colors.blue),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('What do you need help with?', style: text.headlineLarge),
            const SizedBox(height: AppSpacing.md),
            Text('Choose a category and optionally add your location.'),
            const SizedBox(height: AppSpacing.lg),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ServiceCategory.values
                  .map((cat) => ChoiceChip(
                        label: Text(_label(cat)),
                        selected: _selected == cat,
                        onSelected: (_) => setState(() => _selected = cat),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                      ))
                  .toList(),
            ),
            const SizedBox(height: AppSpacing.lg),
            TextField(
              controller: _locationCtrl,
              decoration: const InputDecoration(
                labelText: 'Location (optional)',
                prefixIcon: Icon(Icons.location_on, color: Colors.red),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.search, color: Colors.white),
                  label: const Text('Search',
                      style: TextStyle(color: Colors.white)),
                  onPressed: _selected == null
                      ? null
                      : () => context.go('/handymen', extra: {
                            'category': _selected,
                            'location': _locationCtrl.text.trim()
                          }),
                ),
                const SizedBox(width: AppSpacing.md),
                OutlinedButton.icon(
                  icon: const Icon(Icons.refresh, color: Colors.blue),
                  label: const Text('Reset'),
                  onPressed: () => setState(() {
                    _selected = null;
                    _locationCtrl.clear();
                  }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _label(ServiceCategory c) => switch (c) {
        ServiceCategory.plumber => 'Plumber',
        ServiceCategory.electrician => 'Electrician',
        ServiceCategory.carpenter => 'Carpenter',
        ServiceCategory.painter => 'Painter',
        ServiceCategory.cleaner => 'Cleaner',
        ServiceCategory.gardener => 'Gardener',
      };
}
