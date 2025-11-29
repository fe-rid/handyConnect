import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/enums.dart';
import '../../core/models/handyman.dart';
import '../../data/mock/mock_data.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/handyman_repository.dart';
import '../../theme.dart';

class ProfileSetupPage extends StatefulWidget {
  const ProfileSetupPage({super.key});

  @override
  State<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  final _name = TextEditingController();
  final _desc = TextEditingController();
  final _location = TextEditingController();
  final _phone = TextEditingController();
  final _whatsapp = TextEditingController();
  final _telegram = TextEditingController();
  ServiceCategory _category = ServiceCategory.plumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Handyman profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
                controller: _name,
                decoration: const InputDecoration(labelText: 'Full name')),
            const SizedBox(height: AppSpacing.md),
            DropdownButtonFormField<ServiceCategory>(
              value: _category,
              items: ServiceCategory.values
                  .map(
                      (e) => DropdownMenuItem(value: e, child: Text(_label(e))))
                  .toList(),
              onChanged: (v) =>
                  setState(() => _category = v ?? ServiceCategory.plumber),
              decoration: const InputDecoration(labelText: 'Service category'),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
                controller: _location,
                decoration: const InputDecoration(labelText: 'Location')),
            const SizedBox(height: AppSpacing.md),
            TextField(
                controller: _desc,
                decoration:
                    const InputDecoration(labelText: 'Short description'),
                minLines: 2,
                maxLines: 4),
            const SizedBox(height: AppSpacing.lg),
            Text('Contact links',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            TextField(
                controller: _phone,
                decoration: const InputDecoration(
                    labelText: 'Phone (e.g., tel:+15551234567)')),
            const SizedBox(height: AppSpacing.sm),
            TextField(
                controller: _whatsapp,
                decoration: const InputDecoration(
                    labelText: 'WhatsApp link (e.g., https://wa.me/...)')),
            const SizedBox(height: AppSpacing.sm),
            TextField(
                controller: _telegram,
                decoration: const InputDecoration(
                    labelText: 'Telegram link (https://t.me/...)')),
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save, color: Colors.white),
                label: const Text('Save profile',
                    style: TextStyle(color: Colors.white)),
                onPressed: () async {
                  final user = context.read<AuthRepository>().currentUser;
                  if (user == null) return;
                  final profile = HandymanProfile(
                    id: MockData.newId('h'),
                    userId: user.id,
                    fullName: _name.text.trim().isEmpty
                        ? user.name
                        : _name.text.trim(),
                    serviceType: _category,
                    description: _desc.text.trim(),
                    experienceYears: null,
                    location: _location.text.trim(),
                    contactLinks: {
                      if (_phone.text.trim().isNotEmpty)
                        'phone': _phone.text.trim(),
                      if (_whatsapp.text.trim().isNotEmpty)
                        'whatsapp': _whatsapp.text.trim(),
                      if (_telegram.text.trim().isNotEmpty)
                        'telegram': _telegram.text.trim(),
                    },
                    photoUrl: null,
                  );
                  await context
                      .read<HandymanRepository>()
                      .upsertProfile(profile);
                  if (context.mounted) context.go('/handyman/inbox');
                },
              ),
            )
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
