/*
===============================================================================
MIT License

© 2023 Mark Shaffer. All Rights Reserved.

Permission is hereby granted, free of charge, to any person obtaining a
copy of this software and associated documentation files (the "Software"),
to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.
===============================================================================
*/

library melt_the_code_dart;

import 'package:logging/logging.dart';

// ----------------------------------------------------------------------------
// Definitions
// ----------------------------------------------------------------------------

// Tells us all about the module
const String _aboutModule = '''
  TITLE:    melt_the_code_dart Module
  VERSION:  v0.1.0 (Released on 18 Feb 2023)
  WEBSITE:  https://codemelted.dev/modules/flutter/melt_the_code
  LICENSE:  MIT / (c) 2023 Mark Shaffer. All Rights Reserved.
  ''';

/// Error thrown when the melt_the_code module has been violated by attempting
/// to access a use case via an unsupported target platform.
class ModuleViolationError extends UnsupportedError {
  ModuleViolationError(String message) : super(message);
}

/// Exception thrown when attempting execute a use case transaction and that
/// transaction fails.
class UseCaseFailure implements Exception {
  // Member Fields:
  String message;

  UseCaseFailure(this.message);
}

typedef LogHandlerCB = Future<void> Function(LogRecord);

// ----------------------------------------------------------------------------
// Enumerations
// ----------------------------------------------------------------------------

enum LogLevel { off, info, warning, error, debug }

// ----------------------------------------------------------------------------
// Extensions
// ----------------------------------------------------------------------------

extension LogLevelExtension on LogLevel {
  static final _data = {
    LogLevel.off: Level.OFF,
    LogLevel.info: Level.INFO,
    LogLevel.warning: Level.WARNING,
    LogLevel.error: Level.SEVERE,
    LogLevel.debug: Level.FINE,
  };

  Level get level => _data[this] as Level;
}

// ----------------------------------------------------------------------------
// Public Facing API
// ----------------------------------------------------------------------------

class CodeMeltedAPI {
  // Member Fields:
  static CodeMeltedAPI? _instance;
  Logger? _logger;
  LogHandlerCB? _onLoggedEvent;

  /// Private Constructor to the API.
  CodeMeltedAPI._() {
    // Setup our logger
    _logger = Logger("melt_the_code_logger");
    Logger.root.onRecord.listen((record) {
      print('${record.level.name}: ${record.time}: ${record.message}');
      if (_onLoggedEvent != null) {
        _onLoggedEvent!(record);
      }
    });
  }

  /// Provides access to the [CodeMelted] API via the [meltTheCode] function.
  static CodeMeltedAPI _getInstance() {
    _instance ??= CodeMeltedAPI._();
    return _instance!;
  }

  /// You just want to know what it is you are using.
  String aboutModule() => _aboutModule;

  // == Use Logger Use Case==

  configureLogger(LogLevel v, [LogHandlerCB? handler]) {
    Logger.root.level = v.level;
    _onLoggedEvent = handler;
  }

  void logInfo(
    Object? message, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    try {
      _logger!.info(message, error, stackTrace);
    } catch (err) {
      throw UseCaseFailure("Failed to log debug. ${err.toString()}");
    }
  }

  void logWarning(
    Object? message, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    try {
      _logger!.warning(message, error, stackTrace);
    } catch (err) {
      throw UseCaseFailure("Failed to log debug. ${err.toString()}");
    }
  }

  void logError(
    Object? message, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    try {
      _logger!.severe(message, error, stackTrace);
    } catch (err) {
      throw UseCaseFailure("Failed to log debug. ${err.toString()}");
    }
  }

  void logDebug(
    Object? message, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    try {
      _logger!.fine(message, error, stackTrace);
    } catch (err) {
      throw UseCaseFailure("Failed to log debug. ${err.toString()}");
    }
  }
}

/// Main entry point to the [CodeMeltedAPI] API.
CodeMeltedAPI meltTheCode() {
  return CodeMeltedAPI._getInstance();
}
