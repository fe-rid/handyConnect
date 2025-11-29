import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/enums.dart';
import '../../../core/models/service_request.dart';
import '../../../data/repositories/request_repository.dart';

class RequestsState {
  final List<ServiceRequest> mine;
  final List<ServiceRequest> inbox;
  final bool loading;
  final String? error;
  const RequestsState(
      {this.mine = const [],
      this.inbox = const [],
      this.loading = false,
      this.error});

  RequestsState copyWith(
          {List<ServiceRequest>? mine,
          List<ServiceRequest>? inbox,
          bool? loading,
          String? error}) =>
      RequestsState(
          mine: mine ?? this.mine,
          inbox: inbox ?? this.inbox,
          loading: loading ?? this.loading,
          error: error);
}

class RequestsCubit extends Cubit<RequestsState> {
  final RequestRepository repository;
  RequestsCubit(this.repository) : super(const RequestsState());

  Future<void> loadForCustomer(String customerId) async {
    emit(state.copyWith(loading: true));
    try {
      final items = await repository.getCustomerRequests(customerId);
      emit(state.copyWith(loading: false, mine: items));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> loadForHandyman(String handymanId) async {
    emit(state.copyWith(loading: true));
    try {
      final items = await repository.getHandymanRequests(handymanId);
      emit(state.copyWith(loading: false, inbox: items));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> create(
      {required String customerId,
      required String handymanId,
      required String description,
      required DateTime preferredTime}) async {
    await repository.createRequest(
        customerId: customerId,
        handymanId: handymanId,
        description: description,
        preferredTime: preferredTime);
    await loadForCustomer(customerId);
  }

  Future<void> updateStatus(
      {required String requestId,
      required RequestStatus status,
      required String handymanId}) async {
    await repository.updateStatus(requestId, status);
    await loadForHandyman(handymanId);
  }
}
