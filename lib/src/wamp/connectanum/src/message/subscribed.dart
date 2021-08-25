import 'dart:async';

import 'abstract_message.dart';
import 'event.dart';
import 'message_types.dart';

/// Is returned by the subscription process
class Subscribed extends AbstractMessage {
  int subscribeRequestId;
  int subscriptionId;

  /// the constructor with a [subscribeRequestId] initially sent to the server
  /// and a [subscriptionId] that was generated by the server
  Subscribed(this.subscribeRequestId, this.subscriptionId) {
    id = MessageTypes.CODE_SUBSCRIBED;
  }

  /// Is created by the protocol processor and will receive an event object
  /// when the transport receives one
  Stream<Event> eventStream;
  final _revokeCompleter = Completer<String>();

  /// Is completed when the revocation happens
  Future<String> get onRevoke {
    return _revokeCompleter.future;
  }

  /// Is called by the session when the revokation happens
  void revoke(String reason) {
    _revokeCompleter.complete(reason);
  }
}
