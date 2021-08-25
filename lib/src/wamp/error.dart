import 'package:minapp/minapp.dart';
import './connectanum/connectanum.dart';

HError errorify({Abort abort}) {
  Map<String, dynamic> lookup = {
    'unreachable': 601,
    'wamp.error.not_authorized': 603,
    'wamp.close.disable_connection': 600,
    'wamp.close.session_destory': 604,
    'wamp.close.invalid_message': 615,
    'wamp.error.invalid_options': 616,
  };

  int errorCode = lookup[abort.reason] ?? 0;

  return HError(errorCode, abort.reason, abort.message?.message);
}
