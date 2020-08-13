import 'dart:convert';

String prettyJson(Map<String, dynamic> json, {int indent = 2}) {
  var spaces = ' ' * indent;
  var encoder = JsonEncoder.withIndent(spaces);
  return encoder.convert(json);
}

void printPrettyJson(Map<String, dynamic> json, {int indent = 2}) {
  print(prettyJson(json, indent: indent));
}

Map<String, dynamic> getPointerIds() {
  return {
    'pointer_userprofile_id': 69147880,
    'pointer_test_order_id': '5b7bd80ae2f1d05730d3181a',
    'pointer_userprofile_id2': 67667620,
    'pointer_test_order_id2': '5b7cd4220e1654436565565b',
  };
}
