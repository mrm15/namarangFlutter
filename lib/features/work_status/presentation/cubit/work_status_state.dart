import 'package:equatable/equatable.dart';

import '../../domain/entities/work_status.dart';

class WorkStatusState extends Equatable {
  const WorkStatusState({
    this.status,
    this.isLoading = false,
    this.isUpdating = false,
    this.errorMessage,
  });

  final WorkStatus? status;
  final bool isLoading;
  final bool isUpdating;
  final String? errorMessage;

  WorkStatusState copyWith({
    WorkStatus? status,
    bool? isLoading,
    bool? isUpdating,
    String? errorMessage,
    bool clearError = false,
  }) {
    return WorkStatusState(
      status: status ?? this.status,
      isLoading: isLoading ?? this.isLoading,
      isUpdating: isUpdating ?? this.isUpdating,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, isLoading, isUpdating, errorMessage];
}
