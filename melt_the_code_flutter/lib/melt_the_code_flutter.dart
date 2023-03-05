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

/// An extension of use cases to the melt_the_code_dart module bringing a
/// complete array of use cases using functions to the flutter environment.
library melt_the_code_flutter;

import 'package:melt_the_code_dart/melt_the_code_dart.dart' as melt_dart;

// ----------------------------------------------------------------------------
// Definitions
// ----------------------------------------------------------------------------

// Tells us all about the module
const String _aboutModule = '''
  TITLE:    melt_the_code_flutter Module
  VERSION:  v0.1.0 (Released on 18 Feb 2023)
  WEBSITE:  https://codemelted.dev/melt_the_code_flutter
  LICENSE:  MIT / (c) 2023 Mark Shaffer. All Rights Reserved.
  ''';

// ----------------------------------------------------------------------------
// Enumerations
// ----------------------------------------------------------------------------

// ----------------------------------------------------------------------------
// Extensions
// ----------------------------------------------------------------------------

// ----------------------------------------------------------------------------
// Public Facing API
// ----------------------------------------------------------------------------

/// Implements the extensions to the melt_the_code_dart module that are
/// are specific to flutter and not a dart environment.
extension CodeMeltedAPIExtension on melt_dart.CodeMeltedAPI {
  String aboutFlutterModule() => _aboutModule;
}

/// Collection of use cases covering common developer actions wrapped in
/// simple using functions.
melt_dart.CodeMeltedAPI meltTheCode() {
  return melt_dart.meltTheCode();
}
