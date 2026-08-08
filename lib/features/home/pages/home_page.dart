import 'dart:async';

import 'package:flutter/material.dart';
import 'package:namarang/core/constants/app_colors.dart';
import 'package:namarang/core/constants/app_strings.dart';
import 'package:namarang/core/services/background_service.dart';
import 'package:namarang/core/services/permission_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  StreamSubscription<Map<String, dynamic>?>? _syncSubscription;
  bool _isStarting = false;
  bool _isRunning = false;
  bool? _lastRequestSucceeded;
  int? _statusCode;
  String? _response;

  @override
  void initState() {
    super.initState();
    _loadServiceState();
    _syncSubscription = BackgroundService.service
        .on('locationSyncResult')
        .listen(_onSyncResult);
    WidgetsBinding.instance.addPostFrameCallback((_) => _startTracking());
  }

  Future<void> _loadServiceState() async {
    final running = await BackgroundService.service.isRunning();
    if (!mounted) return;
    setState(() => _isRunning = running);
  }

  Future<void> _startTracking() async {
    setState(() {
      _isStarting = true;
      _lastRequestSucceeded = null;
      _response = null;
      _statusCode = null;
    });

    final permissionGranted = await PermissionService()
        .requestLocationPermission();
    if (!permissionGranted) {
      if (!mounted) return;
      setState(() => _isStarting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.locationPermissionRequired)),
      );
      return;
    }

    await BackgroundService.start();
    BackgroundService.captureNow();
    if (!mounted) return;
    setState(() {
      _isStarting = false;
      _isRunning = true;
    });
  }

  void _onSyncResult(Map<String, dynamic>? event) {
    if (!mounted || event == null) return;

    final succeeded = event['success'] == true;
    setState(() {
      _lastRequestSucceeded = succeeded;
      _statusCode = event['statusCode'] as int?;
      _response = (event['response'] ?? event['message'])?.toString();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          succeeded
              ? AppStrings.locationSendSucceeded
              : AppStrings.locationSendFailed,
        ),
        backgroundColor: succeeded ? Colors.green : AppColors.error,
      ),
    );
  }

  @override
  void dispose() {
    _syncSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final resultColor = _lastRequestSucceeded == true
        ? Colors.green
        : AppColors.error;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.my_location_rounded,
                      color: AppColors.primary,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    AppStrings.trackingTestTitle,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    AppStrings.trackingTestDescription,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 52,
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isStarting ? null : _startTracking,
                      icon: _isStarting
                          ? const SizedBox.square(
                              dimension: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.play_arrow_rounded),
                      label: Text(
                        _isStarting
                            ? AppStrings.startingLocationTracking
                            : AppStrings.startLocationTracking,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  if (_isRunning) ...[
                    const SizedBox(height: 16),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.circle, color: Colors.green, size: 10),
                        SizedBox(width: 8),
                        Text(AppStrings.trackingActive),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (_isRunning && _lastRequestSucceeded == null)
              const Center(child: Text(AppStrings.waitingForLocationResponse)),
            if (_lastRequestSucceeded != null)
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: resultColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: resultColor.withValues(alpha: 0.25),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _lastRequestSucceeded == true
                              ? Icons.check_circle_rounded
                              : Icons.error_rounded,
                          color: resultColor,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          _lastRequestSucceeded == true
                              ? AppStrings.locationSendSucceeded
                              : AppStrings.locationSendFailed,
                          style: TextStyle(
                            color: resultColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    if (_statusCode != null) ...[
                      const SizedBox(height: 12),
                      Text('${AppStrings.statusCode}: $_statusCode'),
                    ],
                    if (_response?.isNotEmpty == true) ...[
                      const SizedBox(height: 8),
                      const Text(
                        AppStrings.serverResponse,
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      SelectableText(
                        _response!,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
