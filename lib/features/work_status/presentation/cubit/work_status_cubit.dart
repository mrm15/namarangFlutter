import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/work_status.dart';
import '../../domain/usecases/get_work_status_usecase.dart';
import '../../domain/usecases/set_work_status_usecase.dart';
import 'work_status_state.dart';

class WorkStatusCubit extends Cubit<WorkStatusState> {
  WorkStatusCubit(this._getWorkStatus, this._setWorkStatus)
    : super(const WorkStatusState());

  final GetWorkStatusUseCase _getWorkStatus;
  final SetWorkStatusUseCase _setWorkStatus;

  Future<void> load() async {
    if (state.isLoading) return;
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final status = await _getWorkStatus();
      emit(state.copyWith(status: status, isLoading: false, clearError: true));
    } on Failure catch (failure) {
      emit(state.copyWith(isLoading: false, errorMessage: failure.message));
    }
  }

  Future<bool> update(WorkStatus status) async {
    if (state.isUpdating || state.status == status) return false;
    emit(state.copyWith(isUpdating: true, clearError: true));
    try {
      final updated = await _setWorkStatus(status);
      emit(
        state.copyWith(status: updated, isUpdating: false, clearError: true),
      );
      return true;
    } on Failure catch (failure) {
      emit(state.copyWith(isUpdating: false, errorMessage: failure.message));
      return false;
    }
  }
}
