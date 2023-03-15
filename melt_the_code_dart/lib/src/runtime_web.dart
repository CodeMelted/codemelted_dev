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

import 'package:melt_the_code_dart/melt_the_code_dart.dart';
import 'package:melt_the_code_dart/src/runtime.dart';

/// Creates the runtime for IO.
Runtime getRuntime() => RuntimeWeb();

/// Represents the web runtime.
class RuntimeWeb extends Runtime {
  @override
  bool isUnitTestPlatform() {
    return false;
  }

  @override
  String useRuntimeQuery(RuntimeQueryAction action) {
    final osName = html.window.navigator.userAgent.toLowerCase();
    switch (action) {
      case RuntimeQueryAction.eol:
        return osName == "windows" ? "\r\n" : "\n";
      case RuntimeQueryAction.hostname:
        return html.window.location.hostname ?? "";
      case RuntimeQueryAction.isBrowser:
        return "true";
      case RuntimeQueryAction.isDesktop:
        return (!osName.contains("android") && !osName.contains("ios"))
            .toString();
      case RuntimeQueryAction.isMobile:
        return (osName.contains("android") || osName.contains("ios"))
            .toString();
      case RuntimeQueryAction.numberOfProcessors:
        return (html.window.navigator.hardwareConcurrency ?? -1).toString();
      case RuntimeQueryAction.osName:
        if (osName.contains("android")) {
          return "android";
        } else if (osName.contains("ios")) {
          return "ios";
        } else if (osName.contains("linux")) {
          return "linux";
        } else if (osName.contains("mac")) {
          return "macos";
        } else if (osName.contains("windows")) {
          return "windows";
        } else {
          return "unknown";
        }
      case RuntimeQueryAction.osVersion:
        return "unknown";
      case RuntimeQueryAction.pathSeparator:
        return "/";
    }
  }
}
