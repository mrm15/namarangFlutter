import 'package:flutter/material.dart';
import 'package:namarang/core/api/api_client.dart';
import 'package:namarang/core/di/locator.dart';
import 'package:namarang/core/storage/secure_storage.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('================ HOME PAGE ================');

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () async {
                final storage = locator<SecureStorage>();
                final token = await storage.getAccessToken();
                final refresh = await storage.getRefreshToken();
                debugPrint('✅ Access token:$token');
                debugPrint('✅ Eefresh token:$token');
              },
              child: const Text('DEBUG: Expire Access Token'),
            ),

            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: () async {
                debugPrint('🚀 Calling /userStatus/getWorkStatus ...');
                try {
                  final apiClient = locator<ApiClient>();

                  final response = await apiClient.get(
                    '/userStatus/getWorkStatus',
                  );

                  debugPrint('✅ SUCCESS: ${response.statusCode}');
                  debugPrint('✅ DATA: ${response.data}');
                } catch (e) {
                  debugPrint('❌ FAILED: $e');
                }
              },
              child: const Text('DEBUG: Call getWorkStatus'),
            ),

            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: () async {
                final storage = locator<SecureStorage>();
                await storage.saveAccessToken('invalid_access_test');
                await storage.saveRefreshToken('invalid_refresh_test');
                debugPrint('✅ Both access & refresh tokens corrupted');
              },
              child: const Text('DEBUG: Expire Access + Refresh Token'),
            ),
          ],
        ),
      ),
    );
  }
}
