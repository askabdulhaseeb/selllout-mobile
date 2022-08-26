class Utilities {
  final double _videoAspectRatio = 4 / 3;
  final double _imageAspectRatio = 4 / 3;

  double get videoAspectRatio => _videoAspectRatio;
  double get imageAspectRatio => _imageAspectRatio;
  static double get borderRadius => 24;

  static String get agoraID => 'dad9c77f168046f9b9c0397add34220c';
  static String get agoraToken => '499cccaf590c47008f154cf99bfe3829';

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
  static bool isVideo({required String extension}) {
    if (_listOfVideoExtensions.contains(extension.toLowerCase())) {
      return true;
    }
    return false;
  }
}
