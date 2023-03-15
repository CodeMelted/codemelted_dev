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
import 'package:melt_the_code_flutter/melt_the_code_flutter.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';

// ----------------------------------------------------------------------------
// Mocks
// ----------------------------------------------------------------------------

LaunchUrlStringFunction mockLaunchUrlStringSuccess = (
  String urlString, {
  LaunchMode mode = LaunchMode.platformDefault,
  WebViewConfiguration webViewConfiguration = const WebViewConfiguration(),
  String? webOnlyWindowName,
}) async {
  return true;
};

LaunchUrlStringFunction mockLaunchUrlStringFailure = (
  String urlString, {
  LaunchMode mode = LaunchMode.platformDefault,
  WebViewConfiguration webViewConfiguration = const WebViewConfiguration(),
  String? webOnlyWindowName,
}) async {
  return false;
};

LaunchUrlStringFunction mockLaunchUrlStringUrlValidation = (
  String urlString, {
  LaunchMode mode = LaunchMode.platformDefault,
  WebViewConfiguration webViewConfiguration = const WebViewConfiguration(),
  String? webOnlyWindowName,
}) async {
  return Uri.tryParse(urlString) != null;
};

class MockSharedPreferences extends Mock implements SharedPreferences {
  // Member Fields:
  final _data = <String, dynamic>{};
  final bool throwException;

  MockSharedPreferences(this.throwException);

  void _tryThrowException() {
    if (throwException) {
      throw "It failed";
    }
  }

  @override
  Future<bool> setString(String key, String value) async {
    _tryThrowException();
    _data[key] = value;
    return true;
  }

  @override
  String? getString(String key) {
    _tryThrowException();
    return _data[key] as String?;
  }

  @override
  Future<bool> remove(String key) async {
    _tryThrowException();
    _data.remove(key);
    return true;
  }

  @override
  Future<bool> clear() async {
    _tryThrowException();
    _data.clear();
    return true;
  }
}

// ----------------------------------------------------------------------------
// Tests
// ----------------------------------------------------------------------------

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group("Global Module Tests", () {
    test("aboutFlutterModule() Validation", () {
      var v = aboutFlutterModule();
      expect(v.contains("TITLE:"), true);
      expect(v.contains("VERSION:"), true);
      expect(
          v.contains("WEBSITE:  https://codemelted.dev/melt_the_code_flutter"),
          true);
      expect(v.contains("LICENSE:"), true);
    });
  });

  group("useLinkOpener() Tests", () {
    test("[action] specified, [url] not specified", () {
      for (var element in LinkOpenerAction.values) {
        expectLater(
            () => useLinkOpener(element), throwsA(isA<UseCaseFailure>()));
      }
    });

    test("[action] specified, [url] is empty string", () {
      for (var element in LinkOpenerAction.values) {
        expectLater(() => useLinkOpener(element, url: ""),
            throwsA(isA<UseCaseFailure>()));
      }
    });

    test("[action] specified, url specified, success", () async {
      setFlutterModuleMock(launchUrlStringMock: mockLaunchUrlStringSuccess);
      for (var element in LinkOpenerAction.values) {
        final success = await useLinkOpener(
          element,
          url: "a url",
        );
        expect(success, isTrue);
      }
    });

    test("[action] specified, url specified, no service", () async {
      setFlutterModuleMock(launchUrlStringMock: mockLaunchUrlStringFailure);
      for (var element in LinkOpenerAction.values) {
        final success = await useLinkOpener(
          element,
          url: "a url value",
        );
        expect(success, isFalse);
      }
    });

    test("mailto Optional Parameter Validation", () async {
      setFlutterModuleMock(
          launchUrlStringMock: mockLaunchUrlStringUrlValidation);

      // First validate mailto throws on empty mailto array
      try {
        await useLinkOpener(LinkOpenerAction.mailto, mailto: []);
        fail("Should throw an exception because mailto was an empty array");
      } catch (ex) {
        expect(ex, isA<UseCaseFailure>());
      }

      // Now validate the URL is properly formatted with each new optional
      // element added.
      try {
        await useLinkOpener(
          LinkOpenerAction.mailto,
          mailto: ["test@google.com", "test2@google.com"],
        );
        await useLinkOpener(
          LinkOpenerAction.mailto,
          mailto: ["test@google.com", "test2@google.com"],
          cc: ["test3@google.com"],
        );
        await useLinkOpener(
          LinkOpenerAction.mailto,
          mailto: ["test@google.com", "test2@google.com"],
          cc: ["test3@google.com"],
          bcc: ["test4@google.com"],
        );
        await useLinkOpener(
          LinkOpenerAction.mailto,
          mailto: ["test@google.com", "test2@google.com"],
          cc: ["test3@google.com"],
          bcc: ["test4@google.com"],
          subject: "subject",
        );
        await useLinkOpener(
          LinkOpenerAction.mailto,
          mailto: ["test@google.com", "test2@google.com"],
          cc: ["test3@google.com"],
          bcc: ["test4@google.com"],
          subject: "subject",
          body: "body",
        );
      } catch (ex) {
        fail("should not throw exception");
      }

      setFlutterModuleMock();
    });
  });

  group("useStorage() Tests", () {
    test("FlutterUseCaseFailure occurs", () async {
      setFlutterModuleMock(
        sharedPreferencesMock: MockSharedPreferences(true),
      );

      try {
        await useStorage(StorageAction.clear);
        fail("Should throw exception");
      } catch (ex) {
        expect(ex, isA<UseCaseFailure>());
      }
    });

    test("CRUD operations work, no throw", () async {
      setFlutterModuleMock(
        sharedPreferencesMock: MockSharedPreferences(false),
      );

      var v = await useStorage(StorageAction.get, "testKey");
      expect(v, isNull);

      await useStorage(StorageAction.set, "testKey", "test key value");

      v = await useStorage(StorageAction.get, "testKey");
      expect(v.toString(), "test key value");

      await useStorage(StorageAction.remove, "testKey");
      v = await useStorage(StorageAction.get, "testKey");
      expect(v, isNull);

      await useStorage(StorageAction.clear);
    });
  });
}
