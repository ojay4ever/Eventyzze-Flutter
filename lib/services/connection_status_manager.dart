import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/get_it.dart';
import '../customWidgets/app_alert_dialog.dart';


enum ConnectionStatus { connected, disconnected, checking }

class ConnectionStatusManager {
  factory ConnectionStatusManager() => _instance;
  ConnectionStatusManager._();

  static final ConnectionStatusManager _instance = ConnectionStatusManager._();

  static const Duration _dialogCooldown = Duration(minutes: 1);
  static const String _lastDialogKey = 'last_connection_dialog_shown';
  static const int _maxConsecutiveFailures = 3;

  ConnectionStatus _status = ConnectionStatus.connected;
  int _consecutiveFailures = 0;
  bool _isServerDown = false;

  ConnectionStatus get status => _status;
  bool get isServerDown => _isServerDown;
  int get consecutiveFailures => _consecutiveFailures;

  Future<bool> shouldShowDialog() async {
    final prefs = await SharedPreferences.getInstance();
    final lastShownTimestamp = prefs.getInt(_lastDialogKey) ?? 0;
    final lastShown = DateTime.fromMillisecondsSinceEpoch(lastShownTimestamp);
    final now = DateTime.now();

    if (lastShownTimestamp == 0) return true;
    return now.difference(lastShown) > _dialogCooldown;
  }

  Future<void> markDialogShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastDialogKey, DateTime.now().millisecondsSinceEpoch);
  }

  void handleNetworkError() {
    _consecutiveFailures++;
    _status = ConnectionStatus.disconnected;

    getIt<LoggerService>().warning(
      'Network error detected. Consecutive failures: $_consecutiveFailures',
    );

    if (_consecutiveFailures >= _maxConsecutiveFailures) {
      _isServerDown = true;
      _showConnectionErrorIfAllowed();
    }
  }

  void handleServerError() {
    _consecutiveFailures++;
    _status = ConnectionStatus.disconnected;
    _isServerDown = true;

    getIt<LoggerService>().warning(
      'Server error detected. Consecutive failures: $_consecutiveFailures',
    );

    _showConnectionErrorIfAllowed();
  }

  void handleSuccess() {
    if (_consecutiveFailures > 0 || _status != ConnectionStatus.connected) {
      getIt<LoggerService>()
          .info('Connection restored after $_consecutiveFailures failures');
    }

    _consecutiveFailures = 0;
    _status = ConnectionStatus.connected;
    _isServerDown = false;
  }

  Future<void> _showConnectionErrorIfAllowed() async {
    if (await shouldShowDialog()) {
      await markDialogShown();
      _showConnectionErrorDialog();
    } else {
      getIt<LoggerService>()
          .info('Connection error dialog suppressed (cooldown active)');
    }
  }

  void _showConnectionErrorDialog() {
    getIt<LoggerService>().info('Showing connection error dialog');

    final context = Get.context;
    if (context != null) {
      AppAlertDialog.simple(
        context: context,
        title: 'Connection Issue',
        message: 'We were unable to connect to our servers. Try again soon.',
        confirmButtonColor: Colors.orange,
        onConfirm: () {
          getIt<LoggerService>()
              .info('User dismissed connection error dialog');
        },
      );
    } else {
      getIt<LoggerService>()
          .warning('No context available for dialog, using snackbar');
      GetSnackBar(
        title: 'Connection Issue',
        message: 'We were unable to connect to our servers. Try again soon.',
        backgroundColor: Colors.orange,
        duration: Duration(seconds: 5),
        icon: Icon(Icons.wifi_off),
      );
    }
  }

  void reset() {
    _consecutiveFailures = 0;
    _status = ConnectionStatus.connected;
    _isServerDown = false;
    getIt<LoggerService>().info('Connection status manager reset');
  }

  String getStatusInfo() {
    return 'Status: $_status, '
        'Failures: $_consecutiveFailures, '
        'Server Down: $_isServerDown';
  }
}