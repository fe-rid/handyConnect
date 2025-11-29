import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/enums.dart';
import '../../../core/models/handyman.dart';
import '../../../data/repositories/handyman_repository.dart';

class HandymanState {
  final List<HandymanProfile> items;
  final bool loading;
  final String? error;
  const HandymanState(
      {this.items = const [], this.loading = false, this.error});

  HandymanState copyWith(
          {List<HandymanProfile>? items, bool? loading, String? error}) =>
      HandymanState(
          items: items ?? this.items,
          loading: loading ?? this.loading,
          error: error);
}

class HandymanCubit extends Cubit<HandymanState> {
  final HandymanRepository repository;
  HandymanCubit(this.repository) : super(const HandymanState());

  Future<void> load({ServiceCategory? category, String? location}) async {
    emit(state.copyWith(loading: true));
    try {
      final list = await repository.fetchHandymen(
          category: category, location: location);
      emit(state.copyWith(loading: false, items: list));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }
}
