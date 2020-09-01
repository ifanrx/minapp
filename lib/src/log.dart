import 'package:logger/logger.dart';
import 'config.dart';

class CustomLogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return config.debug;
  }
}
