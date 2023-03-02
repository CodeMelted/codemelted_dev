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

import 'package:flutter_test/flutter_test.dart';

import 'package:melt_the_code/melt_the_code.dart';

void main() {
  group("Global Function Tests", () {
    test("meltTheCode().aboutModule() Validation", () {
      var v = meltTheCode().aboutModule();
      expect(v.contains("TITLE:"), true);
      expect(v.contains("VERSION:"), true);
      expect(
          v.contains(
              "WEBSITE:  https://codemelted.dev/modules/flutter/melt_the_code"),
          true);
      expect(v.contains("LICENSE:"), true);
    });
  });

  // group("meltTheCode().useConsole() Functional Tests", () {
  //   test("Non-Console Environment Failures", () {
  //     // Set the items to null to force the UseCaseFailure
  //     meltTheCode().useConsole().setMock(null, null);

  //     expect(
  //       () => meltTheCode().useConsole().input("Enter Data"),
  //       throwsA(isA<UseCaseFailure>()),
  //     );

  //     expect(
  //       () => meltTheCode().useConsole().options("Enter Data", []),
  //       throwsA(isA<UseCaseFailure>()),
  //     );

  //     expect(
  //       () => meltTheCode().useConsole().writeln("Enter Data"),
  //       throwsA(isA<UseCaseFailure>()),
  //     );
  //   });
  // });

  // group("useMath() Tests", () {
  //   test("Temperature Conversion Validation", () {
  //     nearEqual(32.0, meltTheCode().useMath().celsiusToFahrenheit(0.0), 0.1);
  //     nearEqual(273.15, meltTheCode().useMath().celsiusToKelvin(0.0), 0.1);
  //     nearEqual(0.0, meltTheCode().useMath().fahrenheitToCelsius(32.0), 0.1);
  //     nearEqual(273.15, meltTheCode().useMath().fahrenheitToKelvin(32.0), 0.1);
  //     nearEqual(-273.15, meltTheCode().useMath().kelvinToCelsius(0.0), 0.1);
  //     nearEqual(-459.6, meltTheCode().useMath().kelvinToFahrenheit(0.0), 0.1);
  //   });
  // });
}
