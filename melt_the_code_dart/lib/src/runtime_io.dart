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

import 'dart:io';

import 'package:melt_the_code_dart/melt_the_code_dart.dart';
import 'package:melt_the_code_dart/src/runtime.dart';

/// Creates the runtime for IO.
Runtime getRuntime() => RuntimeIO();

/// Represents the mobile or desktop/server runtime.
class RuntimeIO extends Runtime {
  @override
  bool isUnitTestPlatform() {
    return Platform.environment.containsKey('FLUTTER_TEST');
  }

  @override
  String useRuntimeQuery(RuntimeQueryAction action) {
    final osName = Platform.operatingSystem;
    switch (action) {
      case RuntimeQueryAction.eol:
        return osName == "windows" ? "\r\n" : "\n";
      case RuntimeQueryAction.hostname:
        return Platform.localHostname;
      case RuntimeQueryAction.isBrowser:
        return "false";
      case RuntimeQueryAction.isDesktop:
        return (osName == "linux" || osName == "macos" || osName == "windows")
            .toString();
      case RuntimeQueryAction.isMobile:
        return (osName == "android" || osName == "ios").toString();
      case RuntimeQueryAction.numberOfProcessors:
        return Platform.numberOfProcessors.toString();
      case RuntimeQueryAction.osName:
        return osName;
      case RuntimeQueryAction.osVersion:
        return Platform.operatingSystemVersion;
      case RuntimeQueryAction.pathSeparator:
        return Platform.pathSeparator;
    }
  }
}
