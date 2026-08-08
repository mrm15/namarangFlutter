import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:namarang/core/constants/app_colors.dart';
import 'package:namarang/core/constants/app_strings.dart';
import 'package:namarang/core/widgets/app_loader.dart';
import 'package:namarang/features/profile/domain/entities/profile_entity.dart';
import 'package:namarang/features/profile/presentation/cubit/profile_cubit.dart';

import 'profile_identity_card.dart';
import 'profile_logout_button.dart';
import 'profile_section_card.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({
    super.key,
    required this.profile,
    this.isRefreshing = false,
  });

  final ProfileEntity profile;
  final bool isRefreshing;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      body: AppLoadingOverlay(
        isLoading: isRefreshing,
        child: RefreshIndicator(
          onRefresh: () => context.read<ProfileCubit>().load(refresh: true),
          color: AppColors.primary,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Column(
                    children: [
                      ProfileIdentityCard(profile: profile),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                        child: Column(
                          children: [
                            ProfileSectionCard(
                              title: AppStrings.organizationalInfo,
                              icon: Icons.apartment_rounded,
                              children: [
                                ProfileInfoRow(
                                  icon: Icons.badge_outlined,
                                  label: AppStrings.role,
                                  value: profile.roleName,
                                ),
                                ProfileInfoRow(
                                  icon: Icons.account_tree_outlined,
                                  label: AppStrings.department,
                                  value: profile.departmentName,
                                  showDivider: false,
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            ProfileSectionCard(
                              title: AppStrings.contactInfo,
                              icon: Icons.contact_phone_outlined,
                              children: [
                                ProfileInfoRow(
                                  icon: Icons.phone_rounded,
                                  label: AppStrings.mobileNumber,
                                  value: profile.phoneNumber,
                                  ltr: true,
                                ),
                                if (profile.email.isNotEmpty)
                                  ProfileInfoRow(
                                    icon: Icons.email_outlined,
                                    label: AppStrings.email,
                                    value: profile.email,
                                    ltr: true,
                                  ),
                                if (profile.location.isNotEmpty)
                                  ProfileInfoRow(
                                    icon: Icons.location_on_outlined,
                                    label: AppStrings.location,
                                    value: profile.location,
                                    showDivider: profile.address.isNotEmpty,
                                  ),
                                if (profile.address.isNotEmpty)
                                  ProfileInfoRow(
                                    icon: Icons.home_outlined,
                                    label: AppStrings.address,
                                    value: profile.address,
                                    showDivider: false,
                                  ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            const ProfileLogoutButton(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
