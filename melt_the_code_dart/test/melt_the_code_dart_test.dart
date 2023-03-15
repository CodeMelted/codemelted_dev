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

import 'dart:convert';
import 'dart:io';

import 'package:logging/logging.dart';
import 'package:melt_the_code_dart/melt_the_code_dart.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

// ----------------------------------------------------------------------------
// Mocks
// ----------------------------------------------------------------------------

class MockErrorLogger extends Mock implements Logger {
  @override
  void info(Object? message, [Object? error, StackTrace? stackTrace]) {
    throw Exception("Error");
  }

  @override
  void warning(Object? message, [Object? error, StackTrace? stackTrace]) {
    throw Exception("Error");
  }

  @override
  void severe(Object? message, [Object? error, StackTrace? stackTrace]) {
    throw Exception("Error");
  }

  @override
  void fine(Object? message, [Object? error, StackTrace? stackTrace]) {
    throw Exception("Error");
  }
}

// ----------------------------------------------------------------------------
// Tests
// ----------------------------------------------------------------------------

void main() {
  // --------------------------------------------------------------------------
  // Global Module Tests
  // --------------------------------------------------------------------------

  group("Global Module Tests", () {
    test("aboutDartModule() Validation", () {
      var v = aboutDartModule();
      expect(v.contains("TITLE:"), true);
      expect(v.contains("VERSION:"), true);
      expect(v.contains("WEBSITE:  https://codemelted.dev/melt_the_code_dart"),
          true);
      expect(v.contains("LICENSE:"), true);
    });

    test("UseCaseFailure Validation", () {
      expectLater(() => UseCaseFailure.handle("duh", StackTrace.current),
          throwsA(isA<UseCaseFailure>()));

      var ex = UseCaseFailure("Custom creation", StackTrace.current);
      expect(ex.stackTrace, isA<StackTrace>());
      expect(ex.toString(), isA<String>());
      expectLater(() => UseCaseFailure.handle(ex, StackTrace.current),
          throwsA(isA<UseCaseFailure>()));
    });
  });

  // --------------------------------------------------------------------------
  // Use JSON Converter Use Case Tests
  // --------------------------------------------------------------------------

  group("useJSONConverter() Tests", () {
    test("useJSONConverter Validation", () {
      // First garbage conversion
      try {
        useJSONConverter(JSONConverterAction.parse, null);
        fail("Should throw an exception");
      } catch (ex) {
        expect(ex, isA<UseCaseFailure>());
      }

      try {
        useJSONConverter(JSONConverterAction.stringify, Object());
        fail("Should throw an exception");
      } catch (ex) {
        expect(ex, isA<UseCaseFailure>());
      }

      // Now some valid conversion
      var jsonArray = [1, "a", 2];
      var jsonArrayString = jsonEncode(jsonArray);
      expect(
        useJSONConverter(JSONConverterAction.stringify, jsonArray)
            .stringifiedData,
        jsonArrayString,
      );
      expect(
        useJSONConverter(JSONConverterAction.parse, jsonArrayString).jsonArray,
        jsonArray,
      );

      var jsonObject = {
        "a": "a",
        "b": null,
      };
      var jsonObjectString = jsonEncode(jsonObject);
      expect(
        useJSONConverter(JSONConverterAction.stringify, jsonObject)
            .stringifiedData,
        jsonObjectString,
      );
      expect(
        useJSONConverter(JSONConverterAction.parse, jsonObjectString)
            .jsonObject,
        jsonObject,
      );
    });

    test("JSONObject and JSONArray Validation", () {
      var jsonArray = [1, "a", 2];
      expect(jsonArray.stringify(), isNotNull);

      var jsonArray2 = [1, "a", 2, HttpClient()];
      expect(jsonArray2.stringify(), isNull);

      var jsonObject = {
        "a": "a",
        "b": null,
      };
      expect(jsonObject.stringify(), isNotNull);

      var jsonObject2 = {
        "a": "a",
        "b": null,
        "bruh": HttpClient(),
      };
      expect(jsonObject2.stringify(), isNull);
    });

    test("StringExtension Conversions", () {
      expect("duh".cmBool(), isFalse);
      expect("y".cmBool(), isTrue);
      expect("a".cmInt(), isNull);
      expect("1".cmInt(), 1);
      expect("1.0".cmInt(), isNull);
      expect("b".cmDouble(), isNull);
      expect("1.25".cmDouble(), 1.25);
      expect("duh".parseJSONArray(), isNull);
      var json = [1, "a", 2];
      expect(jsonEncode(json).parseJSONArray(), isList);

      var json2 = {
        "a": "a",
        "b": null,
      };
      expect("duh".parseJSONObject(), isNull);
      expect(jsonEncode(json2).parseJSONObject(), isMap);

      var json3 = {
        "a": "a",
        "b": "b",
      };
      expect(jsonEncode(json3).parseJSONObject(), isMap);
    });
  });

  // --------------------------------------------------------------------------
  // Use Logger Use Case Tests
  // --------------------------------------------------------------------------

  group("useLogger() Tests", () {
    test("Log everything, no errors", () async {
      int logCount = 0;
      useLogger(LoggerAction.setLogLevel, LogLevel.debug);
      useLogger(LoggerAction.setLogHandler, (rec) async {
        logCount += 1;
      });

      useLogger(LoggerAction.logInfo, "info");
      useLogger(LoggerAction.logWarning, "warning");
      useLogger(
        LoggerAction.logError,
        "error",
        "it was bad",
        StackTrace.current,
      );
      useLogger(LoggerAction.logDebug, "debug");
      await Future.delayed(const Duration(milliseconds: 250));
      expect(logCount, 4);
    });

    test("Log some things, ensure log level works", () async {
      int logCount = 0;
      useLogger(LoggerAction.setLogLevel, LogLevel.error);
      useLogger(LoggerAction.setLogHandler, (rec) async {
        logCount += 1;
      });

      useLogger(LoggerAction.logInfo, "info");
      useLogger(LoggerAction.logWarning, "warning");
      useLogger(
        LoggerAction.logError,
        "error",
        "it was bad",
        StackTrace.current,
      );
      useLogger(LoggerAction.logDebug, "debug");
      await Future.delayed(const Duration(milliseconds: 250));
      expect(logCount, 1);
    });

    test("Total logger failure, throws exception", () {
      setMock(loggerMock: MockErrorLogger());
      try {
        useLogger(LoggerAction.logError, "error");
        fail("should throw an exception");
      } catch (ex) {
        expect(ex, isA<UseCaseFailure>());
      }
    });
  });

  // --------------------------------------------------------------------------
  // Use Runtime Query Use Case Tests
  // --------------------------------------------------------------------------

  group("useRuntimeQuery() Tests", () {
    test("Query works and does not throw", () {
      for (var element in RuntimeQueryAction.values) {
        expect(useRuntimeQuery(element), isNotEmpty);
      }
    });
  });
}
