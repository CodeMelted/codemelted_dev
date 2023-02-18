/*
===============================================================================
MIT License

Copyright (c) 2022 Mark Shaffer

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
===============================================================================
*/

// @ts-ignore Deno import of local ts files supported
import { assert, assertThrows } from "https://deno.land/std@0.137.0/testing/asserts.ts";

import { meltTheCode } from "./dist/deno/melt_the_code/melt_the_code.bundle.js";

// ----------------------------------------------------------------------------
// Core API Use Case Tests
// ----------------------------------------------------------------------------
// @ts-ignore Deno is not part of tsc
Deno.test("meltTheCode().aboutModule()", () => {
    const v = meltTheCode().aboutModule();
    assert(v.includes("TITLE:"));
    assert(v.includes("VERSION:"));
    assert(v.includes(
        "WEBSITE:  https://codemelted.dev/modules/deno/melt_the_code"
    ));
    assert(v.includes("LICENSE:"));
});


// ----------------------------------------------------------------------------
// useMath() Use Case Tests
// ----------------------------------------------------------------------------
// @ts-ignore Deno is not part of tsc
// Deno.test("useMath() - Temperature Conversion Formulas", () => {
//     assert(meltTheCode().useMath().celsiusToFahrenheit(0.0) == 32.0);
//     assert(meltTheCode().useMath().celsiusToKelvin(0.0) == 273.15);
//     assert(meltTheCode().useMath().fahrenheitToCelsius(32.0) == 0.0);
//     assert(meltTheCode().useMath().fahrenheitToKelvin(32.0) == 273.15);
//     assert(meltTheCode().useMath().kelvinToCelsius(0.0) == -273.15);
//     const result = meltTheCode().useMath().kelvinToFahrenheit(0.0);
//     assert(result > -459.8);
//     assert(result < -459.5);
// });

// @ts-ignore Deno is not part of tsc
// Deno.test("useMath() - Temperature Conversion Param Checks", () => {
//     assertThrows(
//         () => meltTheCode().useMath().celsiusToFahrenheit("a"),
//         CodeMeltedError
//     );
//     assertThrows(
//         () => meltTheCode().useMath().celsiusToKelvin("a"),
//         CodeMeltedError
//     );
//     assertThrows(
//         () => meltTheCode().useMath().fahrenheitToCelsius("a"),
//         CodeMeltedError
//     );
//     assertThrows(
//         () => meltTheCode().useMath().fahrenheitToKelvin("a"),
//         CodeMeltedError
//     );
//     assertThrows(
//         () => meltTheCode().useMath().kelvinToCelsius("a"),
//         CodeMeltedError
//     );
//     assertThrows(
//         () => meltTheCode().useMath().kelvinToFahrenheit("a"),
//         CodeMeltedError
//     );
// });