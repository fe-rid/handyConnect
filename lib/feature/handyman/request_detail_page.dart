import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/models/enums.dart';
import '../../core/models/service_request.dart';
import '../../data/repositories/request_repository.dart';
import '../requests/bloc/requests_cubit.dart';
import '../../data/repositories/auth_repository.dart';
import '../../theme.dart';

class RequestDetailPage extends StatefulWidget {
  const RequestDetailPage({super.key, required this.requestId});
  final String requestId;

  @override
  State<RequestDetailPage> createState() => _RequestDetailPageState();
}

class _RequestDetailPageState extends State<RequestDetailPage> {
  ServiceRequest? _req;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final repo = context.read<RequestRepository>();
    final r = await repo.getById(widget.requestId);
    setState(() {
      _req = r;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading)
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (_req == null)
      return const Scaffold(body: Center(child: Text('Not found')));
    final r = _req!;
    return Scaffold(
      appBar: AppBar(title: const Text('Request details')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(r.issueDescription,
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.md),
            Text('Preferred time: ${r.preferredTime}'),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.close, color: Colors.red),
                    label: const Text('Reject'),
                    onPressed: r.status == RequestStatus.pending
                        ? () async {
                            final uid =
                                context.read<AuthRepository>().currentUser?.id;
                            if (uid == null) return;
                            await context.read<RequestsCubit>().updateStatus(
                                requestId: r.id,
                                status: RequestStatus.rejected,
                                handymanId: uid);
                            if (context.mounted) Navigator.of(context).pop();
                          }
                        : null,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.check, color: Colors.white),
                    label: const Text('Accept',
                        style: TextStyle(color: Colors.white)),
                    onPressed: r.status == RequestStatus.pending
                        ? () async {
                            final uid =
                                context.read<AuthRepository>().currentUser?.id;
                            if (uid == null) return;
                            await context.read<RequestsCubit>().updateStatus(
                                requestId: r.id,
                                status: RequestStatus.accepted,
                                handymanId: uid);
                            if (context.mounted) Navigator.of(context).pop();
                          }
                        : null,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
