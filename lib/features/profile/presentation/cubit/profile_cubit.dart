import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._getProfile) : super(const ProfileInitial());

  final GetProfileUseCase _getProfile;

  Future<void> load({bool refresh = false}) async {
    final previous = _currentProfile;
    if (refresh && previous != null) {
      emit(ProfileLoaded(previous, isRefreshing: true));
    } else {
      emit(const ProfileLoading());
    }

    try {
      emit(ProfileLoaded(await _getProfile()));
    } on Failure catch (failure) {
      emit(ProfileFailure(failure.message, previousProfile: previous));
    }
  }

  ProfileEntity? get _currentProfile {
    final current = state;
    if (current is ProfileLoaded) return current.profile;
    if (current is ProfileFailure) return current.previousProfile;
    return null;
  }
}
