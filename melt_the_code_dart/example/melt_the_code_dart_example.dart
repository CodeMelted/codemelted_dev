import 'package:logging/logging.dart';
import 'package:melt_the_code_dart/melt_the_code_dart.dart';

void main() {
  meltTheCode().configureLogger(LogLevel.debug);
  meltTheCode().logDebug("hello mark");
}
