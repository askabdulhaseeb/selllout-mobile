import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/chat/chat.dart';
import '../models/chat/message.dart';
import '../widgets/custom_widgets/custom_toast.dart';
import 'auth_methods.dart';

class ChatAPI {
  static final FirebaseFirestore _instance = FirebaseFirestore.instance;
  static const String _collection = 'chat';
  static const String _subCollection = 'messages';

  Stream<List<Message>> messages(String chatID) {
    return _instance
        .collection(_collection)
        .doc(chatID)
        .collection(_subCollection)
        .orderBy('timestamp')
        .snapshots()
        .map((QuerySnapshot<Map<String, dynamic>> event) {
      final List<Message> messages = <Message>[];
      for (DocumentSnapshot<Map<String, dynamic>> element in event.docs) {
        final Message temp = Message.fromMap(element.data()!);
        messages.add(temp);
      }
      return messages;
    });
  }

  Stream<List<Chat>> chats() {
    // Firebase Index need to add
    // Composite Index
    // Collection ID -> chat
    // Field Indexed -> persons Arrays is_group Ascending timestamp Descending
    return _instance
        .collection(_collection)
        .where('persons', arrayContains: AuthMethods.uid)
        .where('is_group', isEqualTo: false)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .asyncMap((QuerySnapshot<Map<String, dynamic>> event) {
      List<Chat> chats = <Chat>[];
      for (DocumentSnapshot<Map<String, dynamic>> element in event.docs) {
        final Chat temp = Chat.fromMap(element.data()!);
        chats.add(temp);
      }
      return chats;
    });
  }

  Stream<List<Chat>> groups() {
    // Firebase Index need to add
    // Composite Index
    // Collection ID -> chat
    // Field Indexed -> persons Arrays is_group Descending timestamp Descending
    return _instance
        .collection(_collection)
        .where('persons', arrayContains: AuthMethods.uid)
        .where('is_group', isEqualTo: true)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .asyncMap((QuerySnapshot<Map<String, dynamic>> event) {
      List<Chat> chats = <Chat>[];
      for (DocumentSnapshot<Map<String, dynamic>> element in event.docs) {
        final Chat temp = Chat.fromMap(element.data()!);
        chats.add(temp);
      }
      return chats;
    });
  }

  Future<void> sendMessage(Chat chat) async {
    final Message? newMessage = chat.lastMessage;
    try {
      if (newMessage != null) {
        await _instance
            .collection(_collection)
            .doc(chat.chatID)
            .collection(_subCollection)
            .doc(newMessage.messageID)
            .set(newMessage.toMap());
      }
      await _instance
          .collection(_collection)
          .doc(chat.chatID)
          .set(chat.toMap());
    } catch (e) {
      CustomToast.errorToast(message: e.toString());
    }
  }

  Future<String?> uploadAttachment({
    required File file,
    required String attachmentID,
  }) async {
    try {
      TaskSnapshot snapshot = await FirebaseStorage.instance
          .ref('chat/personal/${AuthMethods.uid}/$attachmentID}')
          .putFile(file);
      String url = (await snapshot.ref.getDownloadURL()).toString();
      return url;
    } catch (e) {
      CustomToast.errorToast(message: e.toString());
      return null;
    }
  }

  Future<String?> uploadGroupImage({
    required File file,
    required String attachmentID,
  }) async {
    try {
      TaskSnapshot snapshot = await FirebaseStorage.instance
          .ref('chat/group/${AuthMethods.uid}/$attachmentID}')
          .putFile(file);
      String url = (await snapshot.ref.getDownloadURL()).toString();
      return url;
    } catch (e) {
      CustomToast.errorToast(message: e.toString());
      return null;
    }
  }
}
