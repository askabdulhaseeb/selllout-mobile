import 'package:cloud_firestore/cloud_firestore.dart';
import '../enums/gender_type_enum.dart';

class AppUser {
  AppUser({
    required this.uid,
    this.displayName = '',
    this.username = '',
    this.gender = GenderTypesEnum.male,
    this.dob = '',
    this.countryCode = '',
    this.phoneNumber = '',
    this.email = '',
    this.isPublicProfile = true,
    this.imageURL = '',
    this.isBlock = false,
    this.isVerified = false,
    this.rating = 0.0,
    this.bio = '',
    this.posts,
    this.supporting,
    this.supporters,
  });

  final String uid;
  final String? displayName;
  final String? username;
  final String? imageURL;
  final GenderTypesEnum? gender;
  final String? dob;
  final String? countryCode;
  final String? phoneNumber;
  final String? email;
  final bool? isPublicProfile;
  final bool? isBlock;
  final bool? isVerified;
  final double? rating;
  final String? bio;
  final List<String>? posts;
  final List<String>? supporting;
  final List<String>? supporters;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'display_name': displayName ?? '',
      'username': username ?? '',
      'image_url': imageURL ?? '',
      'gender': GenderConverter.genderToString(gender ?? GenderTypesEnum.male),
      'dob': dob ?? '',
      'country_code': countryCode ?? '',
      'phone_number': phoneNumber ?? '',
      'email': email ?? '',
      'is_public_profile': isPublicProfile ?? true,
      'is_block': isBlock ?? false,
      'isVerified': isVerified ?? false,
      'rating': rating ?? 0,
      'bio': bio ?? '',
      'posts': posts ?? <String>[],
      'supporting': supporting ?? <String>[],
      'supporters': supporters ?? <String>[],
    };
  }

  Map<String, dynamic> updateProfile() {
    return <String, dynamic>{
      'display_name': displayName ?? '',
      'username': username ?? '',
      'image_url': imageURL ?? '',
      // 'country_code': countryCode ?? '',
      // 'phone_number': phoneNumber ?? '',
      'is_public_profile': isPublicProfile ?? true,
      'bio': bio ?? '',
    };
  }

  Map<String, dynamic> updateSupport() {
    return <String, dynamic>{
      'supporting': supporting ?? <String>[],
      'supporters': supporters ?? <String>[],
    };
  }

  // ignore: sort_constructors_first
  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'] ?? '',
      displayName: map['display_name'] ?? '',
      username: map['username'] ?? '',
      imageURL: map['image_url'],
      email: map['email'] ?? '',
      rating: double.parse(map['rating']),
      countryCode: '',
      dob: '',
      gender: GenderConverter.stringToGender(map['gender']),
      phoneNumber: '',
    );
  }
  // ignore: sort_constructors_first
  factory AppUser.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return AppUser(
      uid: doc.data()!['uid'] ?? '',
      displayName: doc.data()!['display_name'] ?? '',
      username: doc.data()!['username'] ?? '',
      imageURL: doc.data()!['image_url'],
      gender: GenderConverter.stringToGender(doc.data()!['gender']),
      dob: doc.data()!['dob'] ?? '',
      countryCode: doc.data()!['country_code'] ?? '',
      phoneNumber: doc.data()!['phone_number'] ?? '',
      email: doc.data()!['email'] ?? '',
      isPublicProfile: doc.data()!['is_public_profile'] ?? false,
      isBlock: doc.data()!['is_block'],
      rating: doc.data()!['rating']?.toDouble(),
      bio: doc.data()!['bio'],
      posts: List<String>.from(doc.data()!['posts']),
      supporting: List<String>.from(doc.data()!['supporting']),
      supporters: List<String>.from(doc.data()!['supporters']),
    );
  }
}