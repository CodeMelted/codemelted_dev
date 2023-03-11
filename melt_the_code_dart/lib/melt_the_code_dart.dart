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
  VERSION:  v0.1.1 (Released on 11 Mar 2023)
  WEBSITE:  https://codemelted.dev/melt_the_code_dart
  LICENSE:  MIT / (c) 2023 Mark Shaffer. All Rights Reserved.
  ''';

/// Exception thrown when a use case function fails to be carried out.
class DartUseCaseFailure implements Exception {
  // Member Fields:
  final String message;
  StackTrace? _stackTrace;

  /// Gets the stack trace associated with this failure.
  StackTrace get stackTrace => _stackTrace!;

  /// Tell me why this use case failed.
  DartUseCaseFailure(this.message, StackTrace st) {
    _stackTrace = st;
  }

  /// Helper method for handling the catch portion within this module.
  static void handle(dynamic ex, StackTrace st) {
    if (ex is DartUseCaseFailure) {
      ex._stackTrace = st;
      throw ex;
    } else {
      throw DartUseCaseFailure(ex.toString(), st);
    }
  }
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

/// Implements the dart use case functions accessible in the dart or flutter
/// environments.
class CodeMeltedAPI {
  // Member Fields:
  static CodeMeltedAPI? _instance;

  /// Private Constructor to the API.
  CodeMeltedAPI._();

  /// Provides access to the [CodeMeltedAPI] via the [meltTheCode] function.
  static CodeMeltedAPI _getInstance() {
    _instance ??= CodeMeltedAPI._();
    return _instance!;
  }

  /// You just want to know what it is you are using.
  String aboutDartModule() => _aboutModule;
}

/// Main entry point to the [CodeMeltedAPI] API.
CodeMeltedAPI meltTheCode() {
  return CodeMeltedAPI._getInstance();
}
