import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../data/repositories/auth_repository.dart';
import '../requests/bloc/requests_cubit.dart';
import '../../theme.dart';

class HandymanRequestsListPage extends StatefulWidget {
  const HandymanRequestsListPage({super.key});

  @override
  State<HandymanRequestsListPage> createState() =>
      _HandymanRequestsListPageState();
}

class _HandymanRequestsListPageState extends State<HandymanRequestsListPage> {
  @override
  void initState() {
    super.initState();
    final user = context.read<AuthRepository>().currentUser;
    if (user != null) context.read<RequestsCubit>().loadForHandyman(user.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Incoming requests')),
      body: BlocBuilder<RequestsCubit, RequestsState>(
        builder: (context, state) {
          if (state.loading)
            return const Center(child: CircularProgressIndicator());
          if (state.inbox.isEmpty)
            return const Center(child: Text('No requests yet'));
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.lg),
            itemCount: state.inbox.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, i) {
              final r = state.inbox[i];
              return Card(
                child: ListTile(
                  title: Text(r.issueDescription),
                  subtitle: Text('Preferred: ${r.preferredTime}'),
                  trailing: const Icon(Icons.chevron_right, color: Colors.blue),
                  onTap: () => context.go('/handyman/request/${r.id}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
