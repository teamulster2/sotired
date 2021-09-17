import 'package:flutter/cupertino.dart';
import 'package:so_tired/config/config_manager.dart';
import 'package:so_tired/database/database_manager.dart';
import 'package:so_tired/notifications/notifications.dart';
import 'package:so_tired/utils/utils.dart';
import 'package:timezone/data/latest.dart';

/// This class serves as service provider providing a [ConfigManager],
/// [DatabaseManager] and a [Notifications] instance.
class ServiceProvider extends ChangeNotifier {
  final ConfigManager _configManager = ConfigManager();
  final DatabaseManager _databaseManager = DatabaseManager();
  final Notifications _notifications = Notifications();

  ConfigManager get configManager => _configManager;

  DatabaseManager get databaseManager => _databaseManager;

  Notifications get notification => _notifications;

  /// This method initializes [ConfigManager], [DatabaseManager] and
  /// [Notifications] synchronously.
  Future<void> init(Function onDoneInitializing, String basePath) async {
    // initialize config
    try {
      try {
        await _configManager
            .fetchConfigFromServer('http://192.168.179.125:50000');
      } on Exception {
        _configManager.loadDefaultConfig();
      }
      if (!Utils.doesFileExist(
          '$basePath/${_configManager.clientConfigFileName}')) {
        // TODO: Add exception handling for server not reachable
        // TODO: load url from config
        try {
          await _configManager
              .fetchConfigFromServer('http://192.168.179.125:50000');
        } on Exception {
          _configManager.loadDefaultConfig();
        }
        _configManager.writeConfigToFile();
      } else {
        _configManager.loadConfigFromJson();
      }
    } catch (e) {
      rethrow;
    }

    // initialize database
    await _databaseManager
        .initDatabase('$basePath/${_databaseManager.databasePath}');

    // initialize notifications
    notification.initializeSetting();
    initializeTimeZones();
    await _notifications.showScheduleNotification(
        configManager.clientConfig!.studyName,
        configManager.clientConfig!.notificationText,
        configManager.clientConfig!.utcNotificationTimes);

    onDoneInitializing();
  }
}
