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

/// An collection of common developer use case function in one reusable module.
library melt_the_code_dart;

import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:melt_the_code_dart/src/runtime.dart';

// ----------------------------------------------------------------------------
// About Dart Module Use Case
// ----------------------------------------------------------------------------

/// You want to know what this module is about.
String aboutDartModule() => '''
  TITLE:    melt_the_code_dart Module
  VERSION:  v0.4.0 (Released on 14 Mar 2023)
  WEBSITE:  https://codemelted.dev/melt_the_code_dart
  LICENSE:  MIT / (c) 2023 Mark Shaffer. All Rights Reserved.
  ''';

// ----------------------------------------------------------------------------
// Common Module Definitions
// ----------------------------------------------------------------------------

/// Exception thrown when a use case function fails to be carried out due to
/// a module violation.
class UseCaseFailure implements Exception {
  // Member Fields:
  final String message;
  StackTrace? _stackTrace;

  /// Gets the stack trace associated with this failure.
  StackTrace get stackTrace => _stackTrace!;

  /// Tell me why this use case failed.
  UseCaseFailure(this.message, StackTrace st) {
    _stackTrace = st;
  }

  @override
  String toString() => "DartUseCaseFailure: $message\n$_stackTrace";

  /// Helper method for handling the catch portion within this module.
  static void handle(dynamic ex, StackTrace st) {
    // Go gather our information.
    UseCaseFailure? ucFailureEx;
    if (ex is UseCaseFailure) {
      ex._stackTrace = st;
      ucFailureEx = ex;
    } else {
      ucFailureEx = UseCaseFailure(ex.toString(), st);
    }

    // Ensure we are not in a unit test environment or we will encounter mocks
    // That will cause very bad behavior.
    if (!Runtime.instance.isUnitTestPlatform()) {
      Runtime.instance.useLogger(
        LoggerAction.logError,
        "melt_the_code module encountered a use case failure.",
        ucFailureEx.message,
        ucFailureEx._stackTrace,
      );
    }
    throw ucFailureEx;
  }
}

/// @nodoc
void setMock({Logger? loggerMock}) {
  Runtime.instance.setMock(loggerMock: loggerMock);
}

// ----------------------------------------------------------------------------
// Use JSON Converter Use Case
// ----------------------------------------------------------------------------

/// Defines what a JSONArray is in dart.
typedef JSONArray = List<dynamic>;

/// Provides helper methods for the JSONArray.
extension JSONArrayExtension on JSONArray {
  /// Converts the JSON object to a string returning null if it cannot
  String? stringify() {
    try {
      return jsonEncode(this);
    } catch (ex) {
      return null;
    }
  }
}

/// Defines what a JSONObject is in dart.
typedef JSONObject = Map<String, dynamic>;

/// Provides helper methods for the JSONObject
extension JSONObjectExtension on JSONObject {
  /// Converts the JSON object to a string returning null if it cannot.
  String? stringify() {
    try {
      return jsonEncode(this);
    } catch (ex) {
      return null;
    }
  }
}

/// Provides a series of cmXXX() conversion from a string data type.
extension StringExtension on String {
  /// Will attempt to convert to a bool from a series of strings that can
  /// represent a true value.
  bool cmBool() {
    List<String> trueStrings = [
      "true",
      "1",
      "t",
      "y",
      "yes",
      "yeah",
      "yup",
      "certainly",
      "uh-huh"
    ];
    return trueStrings.contains(toLowerCase());
  }

  /// Will attempt to return a int from the string value or null if it cannot.
  int? cmInt() => int.tryParse(this);

  /// Will attempt to return a double from the string value or null if it
  /// cannot.
  double? cmDouble() => double.tryParse(this);

  /// Will attempt to return Map<String, dynamic> object or null if it cannot.
  JSONObject? parseJSONObject() {
    try {
      return jsonDecode(this) as Map<String, dynamic>?;
    } catch (ex) {
      return null;
    }
  }

  /// Will attempt to return an array object ir null if it cannot.
  JSONArray? parseJSONArray() {
    try {
      return jsonDecode(this) as List<dynamic>?;
    } catch (ex) {
      return null;
    }
  }
}

/// Defines the enumerated actions to support the [useJSONConverter] use case.
enum JSONConverterAction { stringify, parse }

/// Data object returned from the [useJSONConverter] use case where one of the
/// member fields will contain the converted data and the others will be null.
class JSONConvertedData {
  // Member Fields
  final String? stringifiedData;
  final JSONObject? jsonObject;
  final JSONArray? jsonArray;

  JSONConvertedData({this.stringifiedData, this.jsonArray, this.jsonObject});
}

/// Provides the ability to convert encode and decode JSON data.  Will throw
/// [UseCaseFailure] if the data cannot be converted.
JSONConvertedData useJSONConverter(JSONConverterAction action, dynamic data) {
  JSONConvertedData? rtnval;
  try {
    switch (action) {
      case JSONConverterAction.stringify:
        rtnval = JSONConvertedData(stringifiedData: jsonEncode(data));
        break;
      case JSONConverterAction.parse:
        final obj = jsonDecode(data);
        rtnval = (obj is JSONObject)
            ? JSONConvertedData(jsonObject: obj)
            : JSONConvertedData(jsonArray: obj);
        break;
    }
  } catch (ex, st) {
    UseCaseFailure.handle(ex, st);
  }

  return rtnval!;
}

// ----------------------------------------------------------------------------
// Use Logger Use Case
// ----------------------------------------------------------------------------

/// Defines an additional callback for enhancing the [useLogger] use case.
typedef LogHandlerCB = Future<void> Function(LogRecord);

/// Identifies the logger actions to utilize the [useLogger] use case function.
enum LoggerAction {
  setLogLevel,
  setLogHandler,
  logInfo,
  logWarning,
  logError,
  logDebug,
}

/// Identifies the logging level to set with the useLogger() setLogLevel
/// action.
enum LogLevel { off, info, warning, error, debug }

/// Provides a mapping between our chosen log levels and the runtime supported
/// log levels.  They have way more and it seems to defeat the purpose.
extension LogLevelExtension on LogLevel {
  static final _map = {
    LogLevel.off: Level.OFF,
    LogLevel.info: Level.INFO,
    LogLevel.warning: Level.WARNING,
    LogLevel.error: Level.SEVERE,
    LogLevel.debug: Level.FINE,
  };

  Level get level => _map[this] as Level;
}

/// Provides the ability to log to the dart supported logger package.
/// Utilizing the [LoggerAction] enumeration you are able to set the log
/// level, add a handler for additional log actions, and then of course most
/// importantly, do some actual logging.
void useLogger(
  LoggerAction action,
  Object? data, [
  Object? error,
  StackTrace? stackTrace,
]) {
  try {
    Runtime.instance.useLogger(action, data, error, stackTrace);
  } catch (ex, st) {
    UseCaseFailure.handle(ex, st);
  }
}

// ----------------------------------------------------------------------------
// Use Query Runtime Use Case
// ----------------------------------------------------------------------------

/// Defines the queryable information held by the runtime accessible via the
/// [useRuntimeQuery] use case.
enum RuntimeQueryAction {
  eol,
  hostname,
  isBrowser,
  isDesktop,
  isMobile,
  numberOfProcessors,
  osName,
  osVersion,
  pathSeparator,
}

/// Provides the ability to query the runtime environment for information it
/// would know and return it as a dynamic value.  These queryable values are
/// based on the [RuntimeQueryAction] enumeration.
String useRuntimeQuery(RuntimeQueryAction action) {
  String rtnval = "";
  try {
    rtnval = Runtime.instance.useRuntimeQuery(action);
  } catch (ex, st) {
    UseCaseFailure.handle(ex, st);
  }
  return rtnval;
}
