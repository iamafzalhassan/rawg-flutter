import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:rawg/core/secrets/app_secrets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OneSignalService {
  static const String _notificationsEnabledKey = 'notifications_enabled';

  bool _isInitialized = false;

  Future<void> initialize(GoRouter router) async {
    if (_isInitialized) return;
    await _guard('initialize', () async {
      OneSignal.initialize(AppSecrets.oneSignalAppId);
      await OneSignal.Notifications.requestPermission(true);
      OneSignal.Notifications.addClickListener((_) => router.go('/dashboard'));
      OneSignal.Notifications.addForegroundWillDisplayListener((event) => event.notification.display());
      _optIn(await getNotificationsEnabled());
      _isInitialized = true;
    });
  }

  Future<bool> getNotificationsEnabled() async {
    try {
      return (await SharedPreferences.getInstance()).getBool(_notificationsEnabledKey) ?? true;
    } catch (_) {
      return true;
    }
  }

  Future<void> removeExternalUserId() => _guard('logout', OneSignal.logout);

  Future<void> setExternalUserId(String userId) => _guard('login', () => OneSignal.login(userId));

  Future<void> setNotificationsEnabled(bool enabled) => _guard('setNotificationsEnabled', () async {
    _optIn(enabled);
    await (await SharedPreferences.getInstance()).setBool(_notificationsEnabledKey, enabled);
  });

  Future<void> _guard(String action, Future<void> Function() body) async {
    try {
      await body();
    } catch (e) {
      if (kDebugMode) log('OneSignal $action failed: $e');
    }
  }

  void _optIn(bool enabled) => enabled ? OneSignal.User.pushSubscription.optIn() : OneSignal.User.pushSubscription.optOut();
}
