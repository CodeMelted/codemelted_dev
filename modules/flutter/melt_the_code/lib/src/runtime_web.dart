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

// ignore: avoid_web_libraries_in_flutter
import "dart:html" as html;

import "package:melt_the_code/src/runtime.dart";

/// Creates the runtime for IO.
Runtime getRuntime() => RuntimeWeb();

/// Represents the web runtime.
class RuntimeWeb extends Runtime {
  @override
  String hostname() => html.window.location.hostname ?? "";

  @override
  int numberOfProcessors() => html.window.navigator.hardwareConcurrency ?? -1;

  @override
  String osName() {
    var name = html.window.navigator.userAgent.toLowerCase();
    if (name.contains("android")) {
      name = "android";
    } else if (name.contains("ios")) {
      name = "ios";
    } else if (name.contains("mac")) {
      name = "macos";
    } else if (name.contains("linux") || name.contains("unix")) {
      name = "linux";
    } else if (name.contains("win")) {
      name = "windows";
    } else {
      name = "";
    }

    return name;
  }
}
