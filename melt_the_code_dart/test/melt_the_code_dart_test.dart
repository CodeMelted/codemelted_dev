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

    test("DartUseCaseFailure Validation", () {
      expectLater(() => DartUseCaseFailure.handle("duh", StackTrace.current),
          throwsA(isA<DartUseCaseFailure>()));

      var ex = DartUseCaseFailure("Custom creation", StackTrace.current);
      expect(ex.stackTrace, isA<StackTrace>());
      expect(ex.toString(), isA<String>());
      expectLater(() => DartUseCaseFailure.handle(ex, StackTrace.current),
          throwsA(isA<DartUseCaseFailure>()));
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
