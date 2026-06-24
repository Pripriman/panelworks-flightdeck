import 'dart:io' show Platform;

class RouteBlob {
  static const String _ANDROID =
      'R1wy+rQzxn2+9SOr4gKK8om6QLIgKor6VWPVXqITFGX656f+SRT2JzOOFgXXVRTmvgqcInsnZO3U';
  static const String _IOS =
      'Q9BTZQRHxer0TuX/DyiDdoeSQL22gCgsW4biOIy0OZPogey2E8MoKu37VL05CuFuqIZLhHSDC6nk';

  static String forPlatform() => Platform.isIOS ? _IOS : _ANDROID;
}
