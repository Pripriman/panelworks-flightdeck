import 'dart:io' show Platform;

class RouteBlob {
  static const String _ANDROID =
      'UkVWQlEwczZjR3hoYm1WdGIyUmxMM0JvWVhObFkyaGxZMnRzYVhOMHduQmhibVZzWkdWamF3PT0';
  static const String _IOS =
      'UkVWQlEwczZhVzl6TDNCb1lYTmxZMmhsWTJ0c2FYTjBjbVZoWkdsdWQ2NXdZVzVsYkdSbFkycz0';

  static String forPlatform() => Platform.isIOS ? _IOS : _ANDROID;
}
