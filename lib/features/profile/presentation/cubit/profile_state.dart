import 'package:equatable/equatable.dart';

import '../../domain/entities/profile_entity.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  const ProfileLoaded(this.profile, {this.isRefreshing = false});

  final ProfileEntity profile;
  final bool isRefreshing;

  @override
  List<Object?> get props => [profile, isRefreshing];
}

class ProfileFailure extends ProfileState {
  const ProfileFailure(this.message, {this.previousProfile});

  final String message;
  final ProfileEntity? previousProfile;

  @override
  List<Object?> get props => [message, previousProfile];
}
