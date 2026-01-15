Future<Map<String, String>> getDeviceHeaders() async {
  return {
    'X-Device-Model': 'stub',
    'X-OS': 'unknown',
    'X-OS-Version': 'unknown',
    'X-App-Version': 'unknown',
    'X-Device-ID': 'stub',
    'X-Client-IP':'unknown'
  };
}
