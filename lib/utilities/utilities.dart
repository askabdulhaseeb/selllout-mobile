class Utilities {
  static int get usernameMaxLength => _usernameMaxLenght;
  static int get groupDescriptionMaxLength => _groupDescriptionMaxLength;
  static int get bioMaxLength => _bioMaxLength;

  static double get videoAspectRatio => _videoAspectRatio;
  static double get imageAspectRatio => _imageAspectRatio;

  static double get borderRadius => 24;

  static bool isVideo({required String extension}) {
    if (_listOfVideoExtensions.contains(extension.toLowerCase())) {
      return true;
    }
    return false;
  }

  static List<String> get videosAndImages => <String>[
        'heic',
        'jpeg',
        'jpg',
        'png',
        'pjp',
        'pjpeg',
        'jfif',
        'gif',
        'mp4',
        'mov',
        'mkv',
        'qt',
        'm4p',
        'm4v',
        'mpg',
        'mpeg',
        'mpv',
        'm2v',
        '3gp',
        '3g2',
        'svi',
      ];
  static final List<String> _listOfVideoExtensions = <String>[
    'gif',
    'mp4',
    'mov',
    'mkv',
    'qt',
    'm4p',
    'm4v',
    'mpg',
    'mpeg',
    'mpv',
    'm2v',
    '3gp',
    '3g2',
    'svi',
  ];

  static const int _usernameMaxLenght = 32;
  static const int _bioMaxLength = 160;
  static const int _groupDescriptionMaxLength = 160;

  static const double _videoAspectRatio = 4 / 3;
  static const double _imageAspectRatio = 4 / 3;

  static String get agoraID => 'dad9c77f168046f9b9c0397add34220c';
  static String get agoraToken => '499cccaf590c47008f154cf99bfe3829';
  static String get firebaseServerID =>
      'AAAAQMJ0r5c:APA91bH5D1WnjJYGwk3GMTVy7or-Wh3N5QQRYqhIoDnQEMBJ5EyiMU_qTcR-cFfTllm518sUZ__IePwsEmC5UZOeXo9WzznjlNLKhfv8kNPt4YG0HJ_1DY1Nq6xYlGzNScdsn3hoTW5h';
}
