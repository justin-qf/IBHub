import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;
  FirebaseRemoteConfig get remoteConfig => _remoteConfig;

  Future<void> initialize() async {
    try {
      // Set configuration settings
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(hours: 1),
      ));

      // Set default values
      await _remoteConfig.setDefaults({
        'isGoogleAuthVisible': false,
      });

      // Fetch and activate remote config
      await _remoteConfig.fetchAndActivate();
    } catch (e) {
      print('Error initializing Remote Config: $e');
    }
  }

  bool get isGoogleAuthVisible => _remoteConfig.getBool('isGoogleAuthVisible');
}
