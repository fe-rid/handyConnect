import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/enums.dart';
import '../../feature/handyman/bloc/handyman_cubit.dart';
import '../../theme.dart';

class HandymanListPage extends StatefulWidget {
  const HandymanListPage({super.key});

  @override
  State<HandymanListPage> createState() => _HandymanListPageState();
}

class _HandymanListPageState extends State<HandymanListPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
    final category = extra?['category'] as ServiceCategory?;
    final location = extra?['location'] as String?;
    context.read<HandymanCubit>().load(
        category: category,
        location: (location?.isEmpty ?? true) ? null : location);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Available handymen')),
      body: BlocBuilder<HandymanCubit, HandymanState>(
        builder: (context, state) {
          if (state.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.items.isEmpty) {
            return const Center(
                child: Text('No results. Try a different filter.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.lg),
            itemCount: state.items.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) {
              final h = state.items[index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                      child: Text(h.fullName.isNotEmpty ? h.fullName[0] : '?')),
                  title: Text(h.fullName),
                  subtitle: Text(
                      '${_label(h.serviceType)} • ${h.location ?? 'Unknown'}'),
                  trailing: const Icon(Icons.chevron_right, color: Colors.blue),
                  onTap: () => context.go('/handyman/${h.id}'),
                ),
              );
            },
          );
        },
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
