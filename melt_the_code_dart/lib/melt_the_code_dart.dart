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

/// An implementation of common developer use cases in one reusable module.
library melt_the_code_dart;

// ----------------------------------------------------------------------------
// Definitions
// ----------------------------------------------------------------------------

// Tells us all about the module
const String _aboutModule = '''
  TITLE:    melt_the_code_dart Module
  VERSION:  v0.1.0 (Released on 18 Feb 2023)
  WEBSITE:  https://codemelted.dev/melt_the_code_dart
  LICENSE:  MIT / (c) 2023 Mark Shaffer. All Rights Reserved.
  ''';

/// Error thrown when the melt_the_code module has been violated by attempting
/// to access a use case via an unsupported target platform.
class ModuleViolationError extends UnsupportedError {
  ModuleViolationError(String message) : super(message);
}

/// Exception thrown when attempting execute a use case transaction and that
/// transaction fails.
class UseCaseFailure implements Exception {
  // Member Fields:
  String message;

  UseCaseFailure(this.message);
}

// typedef LogHandlerCB = Future<void> Function(LogRecord);

// ----------------------------------------------------------------------------
// Enumerations
// ----------------------------------------------------------------------------

// enum LogLevel { off, info, warning, error, debug }

// ----------------------------------------------------------------------------
// Extensions
// ----------------------------------------------------------------------------

// ----------------------------------------------------------------------------
// Public Facing API
// ----------------------------------------------------------------------------

/// Collection of use cases covering common developer actions wrapped in
/// simple using functions.
class CodeMeltedAPI {
  // Member Fields:
  static CodeMeltedAPI? _instance;

  /// Private Constructor to the API.
  CodeMeltedAPI._();

  /// Provides access to the [CodeMelted] API via the [meltTheCode] function.
  static CodeMeltedAPI _getInstance() {
    _instance ??= CodeMeltedAPI._();
    return _instance!;
  }

  /// You just want to know what it is you are using.
  String aboutModule() => _aboutModule;
}

/// Main entry point to the [CodeMeltedAPI] API.
CodeMeltedAPI meltTheCode() {
  return CodeMeltedAPI._getInstance();
}
