import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/models/handyman.dart';
import '../../data/repositories/handyman_repository.dart';
import '../../theme.dart';

class HandymanDetailPage extends StatefulWidget {
  const HandymanDetailPage({super.key, required this.id});
  final String id;

  @override
  State<HandymanDetailPage> createState() => _HandymanDetailPageState();
}

class _HandymanDetailPageState extends State<HandymanDetailPage> {
  HandymanProfile? _h;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final repo = context.read<HandymanRepository>();
    final h = await repo.getById(widget.id);
    setState(() {
      _h = h;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading)
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (_h == null)
      return const Scaffold(body: Center(child: Text('Not found')));
    final h = _h!;
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text(h.fullName)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(radius: 36, child: Text(h.fullName[0])),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(h.fullName, style: text.titleLarge),
                      const SizedBox(height: 4),
                      Text(h.location ?? 'Unknown'),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.event_available, color: Colors.white),
                  label:
                      const Text('Book', style: TextStyle(color: Colors.white)),
                  onPressed: () => context.go('/book/${h.id}'),
                )
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('About', style: text.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            Text(h.description ?? 'No description'),
            const SizedBox(height: AppSpacing.lg),
            Text('Contact', style: text.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: 8,
              children: [
                if ((h.contactLinks?['whatsapp']) != null)
                  _ContactButton(
                      icon: Icons.chat_bubble,
                      label: 'WhatsApp',
                      url: h.contactLinks!['whatsapp']!),
                if ((h.contactLinks?['telegram']) != null)
                  _ContactButton(
                      icon: Icons.send,
                      label: 'Telegram',
                      url: h.contactLinks!['telegram']!),
                if ((h.contactLinks?['phone']) != null)
                  _ContactButton(
                      icon: Icons.phone,
                      label: 'Call',
                      url: h.contactLinks!['phone']!),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactButton extends StatelessWidget {
  const _ContactButton(
      {required this.icon, required this.label, required this.url});
  final IconData icon;
  final String label;
  final String url;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      icon: Icon(icon, color: Colors.blue),
      label: Text(label),
      onPressed: () async {
        final uri = Uri.parse(url);
        if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Could not open link')));
          }
        }
      },
    );
  }
}
