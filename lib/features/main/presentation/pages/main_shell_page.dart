import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:namarang/core/di/locator.dart';
import 'package:namarang/features/home/pages/home_page.dart';
import 'package:namarang/features/more/presentation/pages/more_page.dart';
import 'package:namarang/features/profile/presentation/pages/profile_page.dart';
import 'package:namarang/features/work_status/presentation/cubit/work_status_cubit.dart';
import 'package:namarang/features/work_status/presentation/cubit/work_status_state.dart';
import 'package:namarang/features/work_status/presentation/widgets/work_status_header.dart';

/// صفحه‌ی اصلی اپ بعد از لاگین — شامل BottomNavigationBar با ۳ تب.
///
/// از IndexedStack استفاده شده (نه Navigator جدا برای هر تب) تا وقتی
/// کاربر بین تب‌ها جابه‌جا می‌شه، state هر صفحه (اسکرول، فرم‌های نیمه‌پر،
/// و غیره) حفظ بشه و صفحه از اول ساخته نشه.
class MainShellPage extends StatefulWidget {
  const MainShellPage({super.key});

  @override
  State<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends State<MainShellPage> {
  int _currentIndex = 1; // پیش‌فرض روی تب وسط (راننده) باز می‌شه

  // ترتیب باید دقیقاً با ترتیب آیتم‌های BottomNavigationBar یکی باشد.
  static const _pages = [
    ProfilePage(), // چپ: حساب کاربری
    HomePage(), // وسط: راننده
    MorePage(), // راست: بیشتر (فعلاً خالی)
  ];

  void _onTabTapped(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => locator<WorkStatusCubit>()..load(),
      child: BlocListener<WorkStatusCubit, WorkStatusState>(
        listenWhen: (previous, current) =>
            previous.errorMessage != current.errorMessage &&
            current.errorMessage != null,
        listener: (context, state) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        },
        child: Scaffold(
          appBar: const WorkStatusHeader(),
          body: IndexedStack(index: _currentIndex, children: _pages),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: _onTabTapped,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'حساب کاربری',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.local_shipping_outlined),
                activeIcon: Icon(Icons.local_shipping),
                label: 'راننده',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.more_horiz_outlined),
                activeIcon: Icon(Icons.more_horiz),
                label: 'بیشتر',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
