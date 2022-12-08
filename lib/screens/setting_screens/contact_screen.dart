import 'package:fast_contacts/fast_contacts.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../database/auth_methods.dart';
import '../../database/chat_api.dart';
import '../../functions/unique_id_functions.dart';
import '../../models/app_user.dart';
import '../../models/chat/chat.dart';
import '../../providers/provider.dart';
import '../../widgets/custom_widgets/custom_elevated_button.dart';
import '../../widgets/custom_widgets/custom_profile_image.dart';
import '../../widgets/custom_widgets/custom_textformfield.dart';
import '../../widgets/custom_widgets/show_loading.dart';
import '../chat_screens/personal_chat_page/personal_chat_screen.dart';
import '../user_screens/others_profile.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({Key? key}) : super(key: key);
  static const String routeName = '/contacts';

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  @override
  void initState() {
    _request();
    super.initState();
  }

  _request() async {
    await Permission.contacts.request();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController _search = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text('Contacts')),
      body: FutureBuilder<List<Contact>>(
        future: FastContacts.allContacts,
        builder: (BuildContext context, AsyncSnapshot<List<Contact>> snapshot) {
          if (snapshot.hasData) {
            final List<Contact> all = snapshot.data ?? <Contact>[];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Consumer<UserProvider>(
                  builder: (BuildContext context, UserProvider userPro, _) {
                return Column(
                  children: <Widget>[
                    CustomTextFormField(
                      controller: _search,
                      hint: 'Search contact',
                      validator: (String? value) => null,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: all.length,
                        itemBuilder: (BuildContext context, int index) {
                          final AppUser? user =
                              userPro.userByPhone(value: all[index].phones[0]);
                          return user == null
                              ? ListTile(
                                  dense: true,
                                  contentPadding: const EdgeInsets.all(0),
                                  leading: const Icon(Icons.contacts_outlined),
                                  title: Text(all[index].displayName),
                                  subtitle: Text(all[index].phones[0]),
                                )
                              : _AppUserContact(
                                  user: user, contact: all[index]);
                        },
                      ),
                    ),
                  ],
                );
              }),
            );
          } else {
            return snapshot.hasError
                ? const Text('Error while fetching')
                : const ShowLoading();
          }
        },
      ),
    );
  }
}

class _AppUserContact extends StatelessWidget {
  const _AppUserContact({
    required this.user,
    required this.contact,
    Key? key,
  }) : super(key: key);

  final AppUser user;
  final Contact contact;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute<OthersProfile>(
          builder: (BuildContext context) => OthersProfile(user: user),
        ));
      },
      contentPadding: const EdgeInsets.all(0),
      leading: CustomProfileImage(imageURL: user.imageURL ?? ''),
      title: Text(
        user.displayName ?? 'null',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(contact.phones[0]),
      trailing: SizedBox(
        width: 100,
        height: 50,
        child: CustomElevatedButton(
          title: 'Message',
          bgColor: Colors.transparent,
          border: Border.all(color: Theme.of(context).primaryColor),
          textStyle: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 14,
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute<PersonalChatScreen>(
              builder: (BuildContext context) => PersonalChatScreen(
                  chat: Chat(
                      chatID:
                          UniqueIdFunctions.personalChatID(chatWith: user.uid),
                      persons: <String>[AuthMethods.uid, user.uid]),
                  chatWith: user),
            ));
          },
        ),
      ),
    );
  }
}
