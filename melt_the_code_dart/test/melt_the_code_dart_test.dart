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
import 'package:melt_the_code_dart/melt_the_code_dart.dart';
import 'package:test/test.dart';

void main() {
  group("Global Module Tests", () {
    test("meltTheCode().aboutDartModule() Validation", () {
      var v = meltTheCode().aboutDartModule();
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

    test("StringExtension Conversions", () {
      expect("duh".cmBool(), isFalse);
      expect("y".cmBool(), isTrue);
      expect("a".cmInt(), isNull);
      expect("1".cmInt(), 1);
      expect("1.0".cmInt(), isNull);
      expect("b".cmDouble(), isNull);
      expect("1.25".cmDouble(), 1.25);
      expect("duh".cmArray(), isNull);
      var json = [1, "a", 2];
      expect(jsonEncode(json).cmArray(), isList);

      var json2 = {
        "a": "a",
        "b": null,
      };
      expect("duh".cmJSON(), isNull);
      expect(jsonEncode(json2).cmJSON(), isMap);

      var json3 = {
        "a": "a",
        "b": "b",
      };
      expect(jsonEncode(json3).cmJSON(), isMap);
    });
  });

  group("meltTheCode().useRuntimeQuery() Tests", () {
    test("Query works and does not throw", () {
      for (var element in RuntimeQueryAction.values) {
        expect(meltTheCode().useRuntimeQuery(element), isNotNull);
      }
    });
  });
}
