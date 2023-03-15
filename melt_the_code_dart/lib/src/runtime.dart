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

import "package:logging/logging.dart";
import "package:melt_the_code_dart/melt_the_code_dart.dart";
import "package:melt_the_code_dart/src/runtime_stub.dart"
    if (dart.library.io) 'package:melt_the_code_dart/src/runtime_io.dart'
    if (dart.library.js) 'package:melt_the_code_dart/src/runtime_web.dart';

/// Provides a wrapper class to the runtime to access IO or Web based runtimes
/// to allow the module to test / run properly.
abstract class Runtime {
  // Member Fields:
  static Runtime? _instance;
  Logger? _logger = Logger('MeltTheCodeLogger');
  bool _hasLoggerBeenInitialized = false;
  LogHandlerCB? _logHandler;

  /// Gain access to the runtime instance
  static Runtime get instance {
    _instance ??= getRuntime();
    return _instance!;
  }

  /// Accessor to aid in bypassing logic if we are in a unit test
  /// environment.
  bool isUnitTestPlatform();

  /// Definition of the use logger use case function.
  void useLogger(
    LoggerAction action,
    Object? data, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    // Initialize things for first time access and use.
    if (!_hasLoggerBeenInitialized) {
      Logger.root.level = Level.ALL;
      Logger.root.onRecord.listen((record) {
        // Go format to log the record
        var logRecord =
            "${record.time} [${record.level.name}]: ${record.message}.";
        logRecord = record.error != null
            ? "$logRecord\nERROR: ${record.error}"
            : logRecord;
        logRecord = record.stackTrace != null
            ? "$logRecord\nSTACK TRACE:\n${record.stackTrace}"
            : logRecord;
        print(logRecord);

        // Pass off that same record to a log handler for further processing.
        if (_logHandler != null) {
          _logHandler!(record);
        }
      });
      _hasLoggerBeenInitialized = true;
    }

    // Go carry out the action
    switch (action) {
      case LoggerAction.setLogLevel:
        Logger.root.level = (data as LogLevel).level;
        break;
      case LoggerAction.setLogHandler:
        _logHandler = data as LogHandlerCB?;
        break;
      case LoggerAction.logInfo:
        _logger!.info(data, error, stackTrace);
        break;
      case LoggerAction.logWarning:
        _logger!.warning(data, error, stackTrace);
        break;
      case LoggerAction.logError:
        _logger!.severe(data, error, stackTrace);
        break;
      case LoggerAction.logDebug:
        _logger!.fine(data, error, stackTrace);
        break;
    }
  }

  /// Definition of the use query runtime use case function.
  String useRuntimeQuery(RuntimeQueryAction action);

  /// Support mocking for testing of the Runtime.
  void setMock({Logger? loggerMock}) {
    _logger = loggerMock;
  }
}
