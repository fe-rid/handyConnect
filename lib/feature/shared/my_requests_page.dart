import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/models/enums.dart';
import '../../core/models/service_request.dart';
import '../../data/repositories/auth_repository.dart';
import '../requests/bloc/requests_cubit.dart';
import '../../theme.dart';

class MyRequestsPage extends StatefulWidget {
  const MyRequestsPage({super.key});

  @override
  State<MyRequestsPage> createState() => _MyRequestsPageState();
}

class _MyRequestsPageState extends State<MyRequestsPage> {
  @override
  void initState() {
    super.initState();
    final user = context.read<AuthRepository>().currentUser;
    if (user != null) {
      context.read<RequestsCubit>().loadForCustomer(user.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My requests')),
      body: BlocBuilder<RequestsCubit, RequestsState>(
        builder: (context, state) {
          if (state.loading)
            return const Center(child: CircularProgressIndicator());
          if (state.mine.isEmpty)
            return const Center(child: Text('No requests yet'));
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.lg),
            itemCount: state.mine.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, i) => _RequestTile(req: state.mine[i]),
          );
        },
      ),
    );
  }
}

class _RequestTile extends StatelessWidget {
  const _RequestTile({required this.req});
  final ServiceRequest req;

  @override
  Widget build(BuildContext context) {
    final statusColor = switch (req.status) {
      RequestStatus.pending => Colors.orange,
      RequestStatus.accepted => Colors.green,
      RequestStatus.rejected => Colors.red,
    };
    final statusText = switch (req.status) {
      RequestStatus.pending => 'Pending',
      RequestStatus.accepted => 'Accepted',
      RequestStatus.rejected => 'Rejected',
    };
    return Card(
      child: ListTile(
        leading: CircleAvatar(
            child: Text(req.handymanId.substring(0, 2).toUpperCase())),
        title: Text(req.issueDescription),
        subtitle: Text('Preferred: ${req.preferredTime}'),
        trailing: Chip(
            label: Text(statusText),
            labelStyle: const TextStyle(color: Colors.white),
            backgroundColor: statusColor),
      ),
    );
  }
}
