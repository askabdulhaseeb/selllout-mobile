import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/app_user.dart';

class UserAPI{
  static const String _collection = 'users';
  static final FirebaseFirestore _instance = FirebaseFirestore.instance;
  // functions
  Future<List<AppUser>> getAllUsers() async {
    final List<AppUser> appUser = <AppUser>[];
    final QuerySnapshot<Map<String, dynamic>> doc =
        await _instance.collection(_collection).get();

    for (DocumentSnapshot<Map<String, dynamic>> element in doc.docs) {
      appUser.add(AppUser.fromDoc(element));
    }
    return appUser;
  }

}