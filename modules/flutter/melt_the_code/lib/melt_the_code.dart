/*
===============================================================================
MIT License
© 2022 Mark Shaffer. All Rights Reserved.

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
library melt_the_code;

// import 'dart:async';
// import 'dart:convert';

// import 'package:geolocator/geolocator.dart';
// import 'package:sensors_plus/sensors_plus.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import 'dart:isolate';
// import 'dart:async';
// import 'package:flutter/foundation.dart';

// ----------------------------------------------------------------------------
// Common Module Definitions
// ----------------------------------------------------------------------------

// Tells us all about the module
const String _aboutModule = '''
  TITLE:    melt_the_code Flutter Module
  VERSION:  v0.1.0 (Released on 18 Feb 2023)
  WEBSITE:  https://codemelted.dev/modules/flutter/melt_the_code
  LICENSE:  MIT / (c) 2023 Mark Shaffer. All Rights Reserved.
  r''';

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

// ----------------------------------------------------------------------------
// Flutter Extensions
// ----------------------------------------------------------------------------

// /// Represents the task to be kicked off via the [UseAsyncIO] interface.
// typedef TaskFunction = FutureOr<dynamic> Function(dynamic data);

// /// Callback called for the [TaskRunner] once a background task is done
// /// processing.
// typedef OnTaskCompletedCallback = void Function(dynamic);

// /// A FIFO dedicated wrapper of an [Isolate] setting up the bidirectional
// /// communication necessary to repeat a processing task.
// class TaskRunner {
//   // Member Fields:
//   final TaskFunction _task;
//   final OnTaskCompletedCallback onTaskCompleted;
//   bool _isRunning = false;
//   late Isolate _isolate;
//   late SendPort _sendPort;

//   /// Wraps the [TaskFunction] to handle queue up data for processing.
//   TaskRunner(this._task, this.onTaskCompleted) {
//     _init();
//   }

//   /// Determines if the [TaskRunner] is fully up and running.
//   bool get isRunning => _isRunning;

//   /// Queues up data for the [TaskFunction] to process.
//   void queue(dynamic data) => _sendPort.send(data);

//   /// Kills the dedicated [TaskRunner] by killing the wrapped [Isolate]
//   void kill() => _isolate.kill(priority: Isolate.immediate);

//   /// Sets up the dedicated [Isolate] and the bidirectional communication to
//   /// queue up and receive processed data.
//   Future<void> _init() async {
//     _isRunning = false;
//     ReceivePort receive = ReceivePort();
//     _isolate = await Isolate.spawn<SendPort>((port) {
//       ReceivePort receivePort = ReceivePort();
//       port.send(receivePort.sendPort);
//       receivePort.listen((data) async {
//         var result = await _task(data);
//         port.send(result);
//       });
//     }, receive.sendPort);
//     _sendPort = await receive.first as SendPort;
//     receive.listen((result) => onTaskCompleted(result));
//     _isRunning = true;
//   }
// }

// /// Implements the Use Async use case wrapping the ability to spawn a dedicated
// /// task processing via a FIFO [TaskRunner], fire a one shot async task either
// /// on the main thread or in the background, and the ability to sleep an async
// /// function.
// class UseAsyncIO {
//   // Member Fields:
//   static UseAsyncIO? _instance;

//   /// Provides a private constructor to initialize the API singleton.
//   UseAsyncIO._internal() {
//     _instance = this;
//   }

//   /// Gains access to the singleton via a factory constructor.
//   factory UseAsyncIO() => _instance ?? UseAsyncIO._internal();

//   /// Creates a dedicated [TaskRunner] for repeat background tasks within an
//   /// application.
//   TaskRunner dedicated({
//     required TaskFunction task,
//     required OnTaskCompletedCallback onTaskCompleted,
//   }) =>
//       TaskRunner(task, onTaskCompleted);

//   /// Fires off a one shot [TaskFunction] to process potential data and return
//   /// the result of that data based on some set of milliseconds in the future.
//   Future<dynamic> oneShot(
//       {required TaskFunction task,
//       dynamic data,
//       bool isBackground = false,
//       int timeout = 0}) async {
//     await sleep(timeout);
//     return isBackground ? compute(task, data) : Future.value(task(data));
//   }

//   /// Will sleep an asynchronous task for the specified set of milliseconds.
//   Future<void> sleep(int milliseconds) async => Future.delayed(
//         Duration(milliseconds: milliseconds),
//       );
// }

// ----------------------------------------------------------------------------
// Use JSON Use Case Implementation
// ----------------------------------------------------------------------------

// class UseJSON {
//   // Member Fields:
//   static UseJSON? _instance;

//   /// Private constructor to setup the object.
//   UseJSON._();

//   /// Gets an instance for the [CodeMelted] API.
//   static UseJSON _getInstance() {
//     _instance ??= UseJSON._();
//     return _instance!;
//   }

//   dynamic parse(String data) {
//     try {
//       var rtnval = jsonDecode(data);
//       if (rtnval == null) {
//         throw NullThrownError();
//       }
//     } catch (e) {
//       throw UseCaseFailure("Failed to decode a valid JSON object");
//     }
//   }

//   String stringify(dynamic data) {
//     try {
//       return jsonEncode(data);
//     } catch (e) {
//       throw UseCaseFailure("Failed to encode the JSON object");
//     }
//   }
// }

// ----------------------------------------------------------------------------
// Use GIS Use Case Implementation
// ----------------------------------------------------------------------------

// /// The units that can be converted between in the [UseGIS] use case.
// enum Unit {
//   celsiusToFahrenheit,
//   celsiusToKelvin,
//   fahrenheitToCelsius,
//   fahrenheitToKelvin,
//   kelvinToCelsius,
//   kelvinToFahrenheit,
// }

// extension _UnitExtension on Unit {
//   static final _map = {
//     Unit.celsiusToFahrenheit: (double v) => v * (9 / 5) + 32,
//     Unit.celsiusToKelvin: (double v) => v + 273.15,
//     Unit.fahrenheitToCelsius: (double v) => (v - 32) * (5 / 9),
//     Unit.fahrenheitToKelvin: (double v) => ((v - 32) * (5 / 9)) + 273.15,
//     Unit.kelvinToCelsius: (double v) => v - 273.15,
//     Unit.kelvinToFahrenheit: (double v) => ((v - 273.15) * (9 / 5)) + 32,
//   };
//   double _convert(v) => _map[this]!(v);
// }

// abstract class XYZCoordinate {
//   // Member Fields:
//   DateTime? _timestamp;
//   double _x = double.nan;
//   double _y = double.nan;
//   double _z = double.nan;

//   DateTime? get lastUpdated => _timestamp;
//   double get x => _x;
//   double get y => _y;
//   double get z => _z;
//   bool get isSet => !x.isNaN && !y.isNaN && !z.isNaN;

//   void _update(double x, double y, double z) {
//     _timestamp = DateTime.now();
//     _x = x;
//     _y = y;
//     _z = z;
//   }
// }

// class AccelerometerData extends XYZCoordinate {
//   AccelerometerData._();
// }

// class GyroscopeData extends XYZCoordinate {
//   GyroscopeData._();
// }

// class MagnetometerData extends XYZCoordinate {
//   MagnetometerData._();
// }

// class PositionData {
//   // Member Fields
//   DateTime? _timestamp;
//   double _accuracy = double.nan;
//   double _altitude = double.nan;
//   double _heading = double.nan;
//   double _latitude = double.nan;
//   double _longitude = double.nan;
//   double _speed = double.nan;
//   double _speedAccuracy = double.nan;

//   PositionData._();

//   DateTime? get lastUpdated => _timestamp;
//   double get accuracy => _accuracy;
//   double get altitude => _altitude;
//   double get heading => _heading;
//   double get latitude => _latitude;
//   double get longitude => _longitude;
//   double get speed => _speed;
//   double get speedAccuracy => _speedAccuracy;

//   void _update(Position v) {
//     _timestamp = DateTime.now();
//     _accuracy = v.accuracy;
//     _altitude = v.altitude;
//     _heading = v.heading;
//     _latitude = v.latitude;
//     _longitude = v.longitude;
//     _speed = v.speed;
//     _speedAccuracy = v.speedAccuracy;
//   }
// }

// class GISData {
//   // Member Fields:
//   DateTime _lastUpdated = DateTime.now();
//   final accelerometer = AccelerometerData._();
//   final gyroscope = GyroscopeData._();
//   final magnetometer = MagnetometerData._();
//   final position = PositionData._();

//   GISData._();

//   DateTime get lastUpdated => _lastUpdated;

//   Future<void> _update(dynamic data) async {
//     _lastUpdated = DateTime.now();
//     if (data is AccelerometerEvent) {
//       accelerometer._update(data.x, data.y, data.z);
//     } else if (data is GyroscopeEvent) {
//       gyroscope._update(data.x, data.y, data.z);
//     } else if (data is MagnetometerEvent) {
//       magnetometer._update(data.x, data.y, data.z);
//     } else if (data is Position) {
//       position._update(data);
//     }
//   }
// }

// typedef OnGISDataUpdated = Future<void> Function(GISData data);

// class UseGIS {
//   // Member Fields:
//   static UseGIS? _instance;
//   OnGISDataUpdated? onGISDataUpdated;
//   final gisData = GISData._();

//   UseGIS._() {
//     accelerometerEvents.listen((event) {
//       gisData._update(event);
//     });

//     gyroscopeEvents.listen((GyroscopeEvent event) {
//       gisData._update(event);
//     });

//     magnetometerEvents.listen((MagnetometerEvent event) {
//       gisData._update(event);
//     });

//     const locationSettings = LocationSettings(
//       accuracy: LocationAccuracy.high,
//       distanceFilter: 100,
//     );
//     Geolocator.getPositionStream(locationSettings: locationSettings)
//         .listen((Position? position) {
//       gisData._update(position);
//     });

//     _initInitialPosition();
//   }

//   /// Gets an instance for the [CodeMelted] API.
//   static UseGIS _getInstance() {
//     _instance ??= UseGIS._();
//     return _instance!;
//   }

//   double bearingBetween(
//     double startLatitude,
//     double startLongitude,
//     double endLatitude,
//     double endLongitude,
//   ) {
//     return Geolocator.bearingBetween(
//       startLatitude,
//       startLongitude,
//       endLatitude,
//       endLongitude,
//     );
//   }

//   /// Converts between the different [Unit] enumerated units.
//   double convertUnits(Unit unit, double v) {
//     return unit._convert(v);
//   }

//   double distanceBetween(
//     double startLatitude,
//     double startLongitude,
//     double endLatitude,
//     double endLongitude,
//   ) {
//     return Geolocator.distanceBetween(
//       startLatitude,
//       startLongitude,
//       endLatitude,
//       endLongitude,
//     );
//   }

//   double speedBetween(
//     DateTime startTime,
//     double startLatitude,
//     double startLongitude,
//     DateTime endTime,
//     double endLatitude,
//     double endLongitude,
//   ) {
//     final distanceMeters = distanceBetween(
//       startLatitude,
//       startLongitude,
//       endLatitude,
//       endLongitude,
//     );
//     final timeSeconds =
//         (endTime.millisecondsSinceEpoch - startTime.millisecondsSinceEpoch) /
//             1000.0;
//     return distanceMeters / timeSeconds;
//   }

//   Future<void> _initInitialPosition() async {
//     // Setup our worker variables
//     bool serviceEnabled;
//     LocationPermission permission;

//     // Test if location services are enabled.
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       // Location services are not enabled don't continue
//       // accessing the position and request users of the
//       // App to enable the location services.
//       return Future.error("Location services are disabled.");
//     }

//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         // Permissions are denied, next time you could try
//         // requesting permissions again (this is also where
//         // Android's shouldShowRequestPermissionRationale
//         // returned true. According to Android guidelines
//         // your App should show an explanatory UI now.
//         return Future.error("Location permissions are denied");
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       // Permissions are denied forever, handle appropriately.
//       return Future.error(
//         "Location permissions are permanently denied, "
//         "we cannot request permissions.",
//       );
//     }

//     // When we reach here, permissions are granted and we can
//     // continue accessing the position of the device.
//     final position = await Geolocator.getCurrentPosition();
//     gisData._update(position);
//   }
// }

// ----------------------------------------------------------------------------
// Use Storage Use Case Implementation
// ----------------------------------------------------------------------------

// /// Provides the ability to store key/value string pairs for later access by
// /// an application.
// class UseStorage {
//   // Member Fields:
//   static UseStorage? _instance;
//   SharedPreferences? _pref;

//   /// Private constructor to setup the [SharedPreferences] object.
//   UseStorage._() {
//     SharedPreferences.getInstance().then((value) {
//       _pref = value;
//       _pref!.reload();
//     });
//   }

//   /// Gets an instance for the [CodeMelted] API.
//   static UseStorage _getInstance() {
//     _instance ??= UseStorage._();
//     return _instance!;
//   }

//   /// Sets a key/value pair into the storage.
//   Future<void> set(String key, String value) async {
//     _tryNullCheck();
//     try {
//       await _pref!.setString(key, value);
//     } catch (e) {
//       throw UseCaseFailure(e.toString());
//     }
//   }

//   /// Retrieves the string value associated with the key or null if key does
//   /// not exist within the storage.
//   String? get(String key) {
//     _tryNullCheck();
//     String? rtnval;
//     try {
//       rtnval = _pref!.getString(key);
//     } catch (e) {
//       throw UseCaseFailure(e.toString());
//     }
//     return rtnval;
//   }

//   /// Removes the specified key if it exists.
//   Future<void> remove(String key) async {
//     _tryNullCheck();
//     try {
//       await _pref!.remove(key);
//     } catch (e) {
//       throw UseCaseFailure(e.toString());
//     }
//   }

//   /// Clears all stored keys in the storage.
//   Future<void> clear() async {
//     _tryNullCheck();
//     try {
//       await _pref!.clear();
//     } catch (e) {
//       throw UseCaseFailure(e.toString());
//     }
//   }

//   /// Ensures the [SharedPreferences] are properly loaded.
//   void _tryNullCheck() {
//     if (_pref == null) {
//       throw UseCaseFailure("Preferences failed to be loaded");
//     }
//   }
// }

// ----------------------------------------------------------------------------
// Public Facing API
// ----------------------------------------------------------------------------

/// Collection of use cases covering common developer actions.
class CodeMelted {
  // Member Fields:
  static CodeMelted? _instance;

  /// Private Constructor to the API.
  CodeMelted._();

  /// Provides access to the [CodeMelted] API via the [meltTheCode] function.
  static CodeMelted _getInstance() {
    _instance ??= CodeMelted._();
    return _instance!;
  }

  /// You just want to know what it is you are using.
  String aboutModule() => _aboutModule;

  /// Gets access to the [UseAsyncIO] collection of async utility
  /// functions.
  // UseAsyncIO useAsyncIO() => UseAsyncIO();

  /// Gets access to the [UseStorage] collection of functions to store and
  /// access key/value pairs.
  // UseStorage useStorage() => UseStorage._getInstance();
}

/// Main entry point to the [CodeMelted] API.
CodeMelted meltTheCode() {
  return CodeMelted._getInstance();
}
