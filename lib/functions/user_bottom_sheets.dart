import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database/auth_methods.dart';
import '../models/app_user.dart';
import '../models/chat/chat.dart';
import '../providers/user/user_provider.dart';
import '../screens/chat_screens/personal_chat_page/personal_chat_screen.dart';
import '../screens/user_screens/others_profile.dart';
import '../widgets/custom_widgets/custom_profile_image.dart';
import 'unique_id_functions.dart';

class UserBottomSheets {
  PersistentBottomSheetController<dynamic> showNewChatPersons({
    required BuildContext context,
    required List<AppUser> users,
  }) {
    return showBottomSheet(
      context: context,
      enableDrag: true,
      builder: (BuildContext context) => Column(
        children: <Widget>[
          const SizedBox(height: 30),
          Row(
            children: <Widget>[
              IconButton(
                splashRadius: 20,
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(Icons.adaptive.arrow_back_rounded),
              ),
              const Text(
                'New Chat',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              primary: false,
              itemCount: users.length,
              itemBuilder: (BuildContext context, int index) => ListTile(
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute<PersonalChatScreen>(
                      builder: (_) => PersonalChatScreen(
                        chatWith: users[index],
                        chat: Chat(
                          chatID: UniqueIdFunctions.personalChatID(
                            chatWith: users[index].uid,
                          ),
                          persons: <String>[users[index].uid, AuthMethods.uid],
                        ),
                      ),
                    ),
                  );
                },
                leading: CustomProfileImage(
                  imageURL: users[index].imageURL ?? '',
                ),
                title: Text(
                  users[index].displayName ?? 'Name fetching issue',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  users[index].bio ?? 'Bio fetching issue',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  PersistentBottomSheetController<dynamic> showUsersBottomSheet({
    required BuildContext context,
    required List<String> users,
    String title = '',
    bool showBackButton = true,
  }) {
    return showBottomSheet(
      context: context,
      enableDrag: true,
      builder: (BuildContext context) => Column(
        children: <Widget>[
          if (showBackButton)
            Row(
              children: <Widget>[
                IconButton(
                  splashRadius: 20,
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.adaptive.arrow_back_rounded),
                ),
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          Expanded(
            child: Consumer<UserProvider>(
                builder: (BuildContext context, UserProvider userPro, _) {
              return ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: users.length,
                itemBuilder: (BuildContext context, int index) {
                  final AppUser user = userPro.user(uid: users[index]);
                  return ListTile(
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute<OthersProfile>(
                            builder: (_) => OthersProfile(user: user)),
                      );
                    },
                    leading: CustomProfileImage(
                      imageURL: user.imageURL ?? '',
                    ),
                    title: Text(
                      user.displayName ?? 'Name fetching issue',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      user.bio ?? 'Bio fetching issue',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
