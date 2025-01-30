import 'dart:convert';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

class RemoteConfigService {
  final remoteConfig = FirebaseRemoteConfig.instance;
  
  Future<void> initialize() async {
    try {
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(hours: 1),
      ));

      await remoteConfig.setDefaults({
        'enable_new_features': false,
        'enable_reports': true,
        'enable_market_prices': true,
        'enable_cycle_details': true,

        'is_maintenance_mode': false,
        'app_version': '1.0.0',
        'required_update': false,
        'max_chicks_count': 5000,
        'access_codes': jsonEncode({
          'user1': '123456',
          'user2': '789012',
          'user3': '345678',
        }),
        'feature_flags': jsonEncode({
          'enable_new_features': false,
          'enable_reports': true,
          'enable_market_prices': true,
          'enable_cycle_details': true,
        }),
      });

      await remoteConfig.fetchAndActivate();
    } catch (e) {
      debugPrint('Error initializing remote config: $e');
    }
  }

  // Getters for simple values
  bool get isMaintenanceMode => remoteConfig.getBool('is_maintenance_mode');
  String get appVersion => remoteConfig.getString('app_version');
  bool get requiresUpdate => remoteConfig.getBool('required_update');
  
  // Get feature flags
  Map<String, bool> get featureFlags {
    try {
      final flagsString = remoteConfig.getString('feature_flags');
      final decodedFlags = jsonDecode(flagsString) as Map<String, dynamic>;
      return Map<String, bool>.from(decodedFlags);
    } catch (e) {
      debugPrint('Error getting feature flags: $e');
      // Return default values if there's an error
      return {
        'enable_new_features': false,
        'enable_reports': true,
        'enable_market_prices': true,
        'enable_cycle_details': true,
      };
    }
  }
  
  // Get access codes
  Map<String, String> getAccessCodes() {
    try {
      final codesString = remoteConfig.getString('access_codes');
      final decodedCodes = jsonDecode(codesString) as Map<String, dynamic>;
      return Map<String, String>.from(decodedCodes);
    } catch (e) {
      debugPrint('Error getting access codes: $e');
      return {};
    }
  }

  // Get specific feature flag
  bool getFeatureFlag(String flag) {
    try {
      return featureFlags[flag] ?? false;
    } catch (e) {
      debugPrint('Error getting feature flag $flag: $e');
      return false;
    }
  }

  bool isFeatureEnabled(String feature) {
    final String flagKey = feature.startsWith('enable_') ? feature : 'enable_$feature';
    return featureFlags[flagKey] ?? true; // افتراضياً true إذا لم يتم العثور على القيمة
  }
}