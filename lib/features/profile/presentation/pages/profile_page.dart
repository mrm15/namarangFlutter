import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/locator.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import '../widgets/profile_state_views.dart';
import '../widgets/profile_view.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => locator<ProfileCubit>()..load(),
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listenWhen: (previous, current) => current is ProfileFailure,
        listener: (context, state) {
          if (state case ProfileFailure(
            :final message,
            :final previousProfile,
          ) when previousProfile != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(message)));
          }
        },
        builder: (context, state) {
          return switch (state) {
            ProfileInitial() || ProfileLoading() => const ProfileLoadingView(),
            ProfileLoaded(:final profile, :final isRefreshing) => ProfileView(
              profile: profile,
              isRefreshing: isRefreshing,
            ),
            ProfileFailure(:final message, :final previousProfile) =>
              previousProfile == null
                  ? ProfileErrorView(message: message)
                  : ProfileView(profile: previousProfile),
          };
        },
      ),
    );
  }
}
