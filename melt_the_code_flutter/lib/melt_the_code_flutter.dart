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

/// An extension of the melt_the_code_dart module bringing use case functions
/// specific to the flutter environment.
library melt_the_code_flutter;

import 'package:flutter/foundation.dart';
import 'package:melt_the_code_dart/melt_the_code_dart.dart' as melt_dart;
import 'package:url_launcher/url_launcher_string.dart';

// ----------------------------------------------------------------------------
// Definitions
// ----------------------------------------------------------------------------

// Tells us all about the module
const String _aboutModule = '''
  TITLE:    melt_the_code_flutter Module
  VERSION:  v0.2.0 (Released on 11 Mar 2023)
  WEBSITE:  https://codemelted.dev/melt_the_code_flutter
  LICENSE:  MIT / (c) 2023 Mark Shaffer. All Rights Reserved.
  ''';

/// Exception thrown when a use case function fails to be carried out.
class FlutterUseCaseFailure implements Exception {
  // Member Fields:
  final String message;
  StackTrace? _stackTrace;

  /// Gets the stack trace associated with this failure.
  StackTrace get stackTrace => _stackTrace!;

  /// Tell me why this use case failed.
  FlutterUseCaseFailure(this.message, StackTrace st) {
    _stackTrace = st;
  }

  /// Helper method for handling the catch portion within this module.
  static void handle(dynamic ex, StackTrace st) {
    if (ex is FlutterUseCaseFailure) {
      ex._stackTrace = st;
      throw ex;
    } else {
      throw FlutterUseCaseFailure(ex.toString(), st);
    }
  }
}

/// Identifies the function definition for launching URLs from the
/// useLinkOpener() use case.
typedef LaunchUrlStringFunction = Future<bool> Function(
  String urlString, {
  LaunchMode mode,
  WebViewConfiguration webViewConfiguration,
  String? webOnlyWindowName,
});
LaunchUrlStringFunction? _launchUrlString = launchUrlString;

// ----------------------------------------------------------------------------
// Enumerations
// ----------------------------------------------------------------------------

/// The supported link opener protocols to utilize with the
/// useLinkOpener() use case.
enum LinkOpenerAction { file, https, mailto, tel, sms }

// ----------------------------------------------------------------------------
// Extensions
// ----------------------------------------------------------------------------

/// Private extension to support the [LinkOpenerAction] enumeration.
extension _LinkOpenerActionExtension on LinkOpenerAction {
  // Member Fields
  static final _map = {
    LinkOpenerAction.file: "file:",
    LinkOpenerAction.https: "https://",
    LinkOpenerAction.mailto: "mailto:",
    LinkOpenerAction.tel: "tel:",
    LinkOpenerAction.sms: "sms:",
  };

  /// Gets the associated protocol of the action.
  String get protocol => _map[this].toString();
}

// ----------------------------------------------------------------------------
// Public Facing API
// ----------------------------------------------------------------------------

/// Implements the flutter use case functions specific to the flutter runtime
/// environment.
extension CodeMeltedAPIExtension on melt_dart.CodeMeltedAPI {
  /// You want to know what version of this module you are using.
  String aboutFlutterModule() => _aboutModule;

  /// Provides the ability to open a link protocol as represented by the
  /// [LinkOpenerAction] enumerated value utilizing the native app for
  /// that protocol. In all protocols, one can specify the url value
  /// as associated with the selected action.
  ///
  /// - file:<path> ex: url = "/home"
  /// - https:<URL> ex: url = "google.com"
  /// - tel:<phone number> ex: url = "+1-555-010-999"
  /// - sms:<phone number> ex: url = "5550101234"
  /// - mailto:<email address>?subject=<subject>&body=<body>
  ///       ex: mailto:smith@example.org?subject=News&body=New%20plugin
  ///
  /// In the case of the mailto [LinkOpenerAction], it is recommended to utilize
  /// the other optional parameters as they will format the url parameter based
  /// on the values specified.
  ///
  /// When utilizing this use case on the web, you will need to specify the
  /// webOnlyWindowName parameter which corresponds to target attributes similar
  /// to <a target="_blank|_self|_parent|_top|framename">.  See
  /// https://www.w3schools.com/tags/att_a_target.asp for details of the target
  /// attribute meanings.
  Future<void> useLinkOpener(
    LinkOpenerAction action, {
    String? url,
    List<String>? mailto,
    List<String>? cc,
    List<String>? bcc,
    String? subject,
    String? body,
    String? webOnlyWindowName,
  }) async {
    try {
      String urlString = url ?? "";
      if (action == LinkOpenerAction.mailto) {
        if (urlString.isEmpty) {
          // Check the first expected parameter that is required and format
          // as necessary
          if (mailto == null || mailto.isEmpty) {
            throw const FormatException(
              "mailto protocol requires url or mailto to be specified",
            );
          }

          // Now go format the mailto line
          for (var element in mailto) {
            urlString += "$element;";
          }
          urlString = urlString.substring(0, urlString.length - 1);

          // Now go check the remainder of optional parameters
          var delimiter = "?";
          if (cc != null && cc.isNotEmpty) {
            urlString += "${delimiter}cc=";
            delimiter = "&";
            for (var element in cc) {
              urlString += "$element;";
            }
            urlString = urlString.substring(0, urlString.length - 1);
          }

          if (bcc != null && bcc.isNotEmpty) {
            urlString += "${delimiter}bcc=";
            delimiter = "&";
            for (var element in bcc) {
              urlString += "$element;";
            }
            urlString = urlString.substring(0, urlString.length - 1);
          }

          if (subject != null && subject.isNotEmpty) {
            urlString += "${delimiter}subject=$subject";
            delimiter = "&";
          }

          if (body != null && body.isNotEmpty) {
            urlString += "${delimiter}body=$body";
            delimiter = "&";
          }
        }
      }

      // Check to see if someone specified a valid url or not
      if (urlString.isEmpty) {
        throw const FormatException("A valid url parameter was not specified");
      }

      // Go attempt to launch the url
      urlString = "${action.protocol}$urlString";
      if (!await _launchUrlString!(urlString,
          webOnlyWindowName: webOnlyWindowName)) {
        throw FlutterUseCaseFailure(
            "Failed to open $urlString link", StackTrace.current);
      }
    } catch (ex, st) {
      FlutterUseCaseFailure.handle(ex.toString(), st);
    }
  }

  /// @nodoc
  @visibleForTesting
  void setFlutterModuleMock({
    LaunchUrlStringFunction? launchUrlStringMock,
  }) {
    _launchUrlString = launchUrlStringMock ?? _launchUrlString;
  }
}

/// Main entry point to the [melt_dart.CodeMeltedAPI] API.
melt_dart.CodeMeltedAPI meltTheCode() {
  return melt_dart.meltTheCode();
}
