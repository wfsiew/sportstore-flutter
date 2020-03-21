String vRequired(String s, String field) {
  if (s.isEmpty) {
    return '$field is required';
  }

  return null;
}

String vMin(String s, int len, String field) {
  if (s.length < len) {
    return 'Min length for $field is $len';
  }

  return null;
}