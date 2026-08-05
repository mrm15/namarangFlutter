import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../domain/entities/profile_entity.dart';

class ProfileIdentityCard extends StatelessWidget {
  const ProfileIdentityCard({super.key, required this.profile});

  final ProfileEntity profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 18, 16, 14),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [
          BoxShadow(
            color: Color(0x120F172A),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          ProfileAvatar(
            imageUrl: profile.profilePictureUrl,
            fullName: profile.fullName,
            isOnline: profile.userStatus.trim().toLowerCase() == 'online',
          ),
          const SizedBox(height: 16),
          Text(
            profile.fullName.isEmpty
                ? AppStrings.defaultUserName
                : profile.fullName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 21,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            profile.roleName.isEmpty
                ? AppStrings.noOrganizationalTitle
                : profile.roleName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          if (profile.isDepartmentAdmin) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.verified_user_outlined,
                    size: 16,
                    color: AppColors.primary,
                  ),
                  SizedBox(width: 6),
                  Text(
                    AppStrings.departmentAdmin,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    required this.imageUrl,
    required this.fullName,
    required this.isOnline,
  });

  final String imageUrl;
  final String fullName;
  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 112,
          height: 112,
          padding: const EdgeInsets.all(4),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(colors: AppColors.brandGradient),
          ),
          child: ClipOval(
            child: ColoredBox(
              color: const Color(0xFFE8EDF3),
              child: imageUrl.trim().isEmpty
                  ? ProfileAvatarFallback(fullName: fullName)
                  : Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) =>
                          progress == null
                          ? child
                          : const Center(
                              child: AppLoader(size: 24, strokeWidth: 2),
                            ),
                      errorBuilder: (context, error, stackTrace) =>
                          ProfileAvatarFallback(fullName: fullName),
                    ),
            ),
          ),
        ),
        Positioned(
          left: 7,
          bottom: 5,
          child: Container(
            width: 21,
            height: 21,
            decoration: BoxDecoration(
              color: isOnline
                  ? const Color(0xFF22C55E)
                  : const Color(0xFFEF4444),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
            ),
          ),
        ),
      ],
    );
  }
}

class ProfileAvatarFallback extends StatelessWidget {
  const ProfileAvatarFallback({super.key, required this.fullName});

  final String fullName;

  @override
  Widget build(BuildContext context) {
    final trimmed = fullName.trim();
    return Center(
      child: trimmed.isEmpty
          ? const Icon(
              Icons.person_rounded,
              size: 56,
              color: AppColors.secondary,
            )
          : Text(
              trimmed.characters.first,
              style: const TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
    );
  }
}
