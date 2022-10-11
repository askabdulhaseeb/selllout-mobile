import 'package:cloud_firestore/cloud_firestore.dart';
import '../database/auth_methods.dart';
import '../enums/gender_type_enum.dart';
import 'number_details.dart';
import 'reports/report_user.dart';

class AppUser {
  AppUser({
    required this.uid,
    required this.phoneNumber,
    this.displayName = '',
    this.username = '',
    this.gender = GenderTypesEnum.male,
    this.dob = '',
    this.email = '',
    this.isPublicProfile = true,
    this.imageURL = '',
    this.isBlock = false,
    this.isVerified = false,
    this.rating = 0.0,
    this.bio = '',
    this.reports,
    this.blockTo,
    this.blockedBy,
    this.supporting,
    this.supporters,
    this.supportRequest,
  });

  final String uid;
  String? displayName;
  String? username;
  String? imageURL;
  final NumberDetails phoneNumber;
  final GenderTypesEnum? gender;
  final String? dob;
  final String? email;
  bool isPublicProfile;
  final bool? isBlock;
  final bool? isVerified;
  final double? rating;
  String? bio;
  final List<ReportUser>? reports;
  final List<String>? blockTo;
  final List<String>? blockedBy;
  final List<String>? supporting;
  final List<String>? supporters;
  final List<String>? supportRequest;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'display_name': displayName ?? '',
      'number_details': phoneNumber.toMap(),
      'username': username?.trim().toLowerCase() ?? uid,
      'image_url': imageURL ?? '',
      'gender': GenderConverter.genderToString(gender ?? GenderTypesEnum.male),
      'dob': dob ?? '',
      'email': email ?? '',
      'is_public_profile': isPublicProfile,
      'is_block': isBlock ?? false,
      'isVerified': isVerified ?? false,
      'rating': rating ?? 0,
      'bio': bio ?? '',
      'supporting': supporting ?? <String>[],
      'supporters': supporters ?? <String>[],
      'support_request': supportRequest ?? <String>[],
    };
  }

  Map<String, dynamic> updateProfile() {
    // TODO: if the users shifting from private to public profile then SUPPORT REQUIEST needs to be the part of the suports
    return <String, dynamic>{
      'display_name': displayName ?? '',
      'username': username?.trim().toLowerCase() ?? '',
      'image_url': imageURL ?? '',
      'is_public_profile': isPublicProfile,
      'bio': bio ?? '',
    };
  }

  Map<String, dynamic> updateSupporter({
    required bool alreadyExist,
    required String uid,
  }) {
    return <String, dynamic>{
      'supporters': alreadyExist
          ? FieldValue.arrayRemove(<String>[uid])
          : FieldValue.arrayUnion(supporters ?? <String>[]),
    };
  }

  Map<String, dynamic> updateSupporting({
    required bool alreadyExist,
    required String uid,
  }) {
    return <String, dynamic>{
      'supporting': alreadyExist
          ? FieldValue.arrayRemove(<String>[uid])
          : FieldValue.arrayUnion(supporting ?? <String>[]),
    };
  }

  Map<String, dynamic> updateSupportRequest({required bool alreadyExist}) {
    return <String, dynamic>{
      'support_request': alreadyExist
          ? FieldValue.arrayRemove(<String>[AuthMethods.uid])
          : FieldValue.arrayUnion(supportRequest ?? <String>[]),
    };
  }

  blockToUpdate() {
    return <String, dynamic>{
      'block_to': FieldValue.arrayUnion(blockTo ?? <String>[]),
    };
  }

  blockByUpdate() {
    return <String, dynamic>{
      'blocked_by': FieldValue.arrayUnion(blockedBy ?? <String>[]),
    };
  }

  unblockTO() {
    return <String, dynamic>{
      'block_to': FieldValue.arrayRemove(blockTo ?? <String>[]),
    };
  }

  unblockBy() {
    return <String, dynamic>{
      'blocked_by': FieldValue.arrayRemove(blockedBy ?? <String>[]),
    };
  }

  Map<String, dynamic> report() {
    if (!(blockedBy?.contains(AuthMethods.uid) ?? false)) {
      blockedBy?.add(AuthMethods.uid);
    }
    return <String, dynamic>{
      'report': FieldValue.arrayUnion(
          reports!.map((ReportUser e) => e.toMap()).toList()),
      'blocked_by': FieldValue.arrayUnion(blockedBy!),
    };
  }

  // ignore: sort_constructors_first
  factory AppUser.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    List<ReportUser> reportInfo = <ReportUser>[];
    if (doc.data()!['reports'] != null) {
      doc.data()!['reports'].forEach((dynamic e) {
        reportInfo.add(ReportUser.fromMap(e));
      });
    }
    return AppUser(
      uid: doc.data()?['uid'] ?? '',
      phoneNumber: NumberDetails.fromMap(
          doc.data()?['number_details'] ?? <String, dynamic>{}),
      displayName: doc.data()?['display_name'] ?? '',
      username: doc.data()?['username']?.trim().toLowerCase() ??
          doc.data()?['uid'] ??
          '',
      imageURL: doc.data()?['image_url'] ?? '',
      gender: GenderConverter.stringToGender(
        doc.data()?['gender'] ??
            GenderConverter.genderToString(GenderTypesEnum.male),
      ),
      dob: doc.data()?['dob'] ?? '',
      email: doc.data()?['email'] ?? '',
      isPublicProfile: doc.data()?['is_public_profile'] ?? false,
      isBlock: doc.data()?['is_block'],
      rating: doc.data()?['rating']?.toDouble(),
      bio: doc.data()?['bio'],
      reports: reportInfo,
      blockTo: List<String>.from(doc.data()?['block_to'] ?? <String>[]),
      blockedBy: List<String>.from(doc.data()?['blocked_by'] ?? <String>[]),
      supporting: List<String>.from(doc.data()?['supporting'] ?? <String>[]),
      supporters: List<String>.from(doc.data()?['supporters'] ?? <String>[]),
      supportRequest:
          List<String>.from(doc.data()?['support_request'] ?? <String>[]),
    );
  }
}
