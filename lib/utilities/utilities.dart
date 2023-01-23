import 'package:selllout/models/payment_model.dart';
import 'package:selllout/utilities/app_image.dart';

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

  static List<String> get videosAndAppImages => <String>[
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

  static List<PaymentModel> payments = [

    PaymentModel(
      paymentType: PaymentType.paypal,
      icon: AppImages.paypal,
      title: 'PayPal',
      description: 'pay_via_paypal',
      clientId: 'AW1TdvpSGbIM5iP4HJNI5TyTmwpY9Gv9dYw8_8yW5lYIbCqf326vrkrp0ce9TAqjEGMHiV3OqJM_aRT0',
      secretKey: 'EHHtTDjnmTZATYBPiGzZC_AZUfMpMAzj2VZUeqlFUrRJA_C0pQNCxDccB5qoRQSEdcOnnKQhycuOWdP9',
    ),
    PaymentModel(
      paymentType: PaymentType.stripe,
      icon: AppImages.strip,
      title: 'Stripe',
      description: 'pay_via_stripe',
      publishableKey: 'pk_test_51LGHh8AALx6sFd4yttVqYod5nAPwxyFuighk3eoMmlVUGT0YEmS8xMoctyb1wYy7hJ8pLMKVv5AWqMzkUeTsU4cd008mApbq7O',
      secretKey: 'sk_test_51LGHh8AALx6sFd4ymMirjnQWcbzcNThlgzv6K1pNV5HrP4RTsZOouXM56XCRZNH6VtiE3qSRsO2n8A0jFCV1kWIw00o6TtZ8tx',
    ),


  ];

  static String get agoraID => 'dad9c77f168046f9b9c0397add34220c';
  static String get agoraToken => '499cccaf590c47008f154cf99bfe3829';
  static String get firebaseServerID =>
      'AAAAQMJ0r5c:APA91bH5D1WnjJYGwk3GMTVy7or-Wh3N5QQRYqhIoDnQEMBJ5EyiMU_qTcR-cFfTllm518sUZ__IePwsEmC5UZOeXo9WzznjlNLKhfv8kNPt4YG0HJ_1DY1Nq6xYlGzNScdsn3hoTW5h';
}
