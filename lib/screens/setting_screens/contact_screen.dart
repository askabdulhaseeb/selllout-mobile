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
import '../../utilities/dimensions.dart';
import '../../widgets/custom_widgets/custom_button.dart';
import '../../widgets/custom_widgets/custom_elevated_button.dart';
import '../../widgets/custom_widgets/custom_image.dart';
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
    final bool isOkay = await Permission.contacts.isGranted ||
        await Permission.contacts.isLimited;
    if (!isOkay) {
      await openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    String search = '';
    return Scaffold(
      appBar: AppBar(title: const Text('Contacts')),
      body: FutureBuilder<List<Contact>>(
        future: FastContacts.getAllContacts(),
        builder: (BuildContext context, AsyncSnapshot<List<Contact>> snapshot) {
          if (snapshot.hasData) {
            return _DisplayContacts(contacts: snapshot.data ?? <Contact>[]);
          } else {
            return snapshot.hasError
                ? Center(
                    child: Column(
                    children: [
                      const Text('Error while fetching'),
                      TextButton(
                        onPressed: () async => await _request(),
                        child: const Text('Request Permission'),
                      ),
                    ],
                  ))
                : const ShowLoading();
          }
        },
      ),
    );
  }
}

class _DisplayContacts extends StatefulWidget {
  const _DisplayContacts({required this.contacts, super.key});
  final List<Contact> contacts;

  @override
  State<_DisplayContacts> createState() => __DisplayContactsState();
}

class __DisplayContactsState extends State<_DisplayContacts> {
  String search = '';
  List<Contact> filtered() {
    return widget.contacts
        .where((Contact element) => element.displayName.contains(search))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Consumer<UserProvider>(
          builder: (BuildContext context, UserProvider userPro, _) {
        return Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .color!
                    .withOpacity(0.15),
                border: Border.all(color: Colors.grey),
              ),
              child: TextFormField(
                onChanged: (String value) => setState(() {
                  search = value;
                }),
                cursorColor: Theme.of(context).colorScheme.secondary,
                decoration: InputDecoration(
                  hintText: 'Search Contact',
                  focusColor: Theme.of(context).primaryColor,
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(
              height: Dimensions.paddingSizeSmall,
            ),
            Expanded(
              child: filtered().isEmpty
                  ? const Center(child: Text('No Contacts available'))
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 1.5),
                      itemCount: filtered().length,
                      itemBuilder: (BuildContext context, int index) {
                        final AppUser? user = userPro.userByPhone(
                            value: filtered()[index].phones[0].number);
                        return user == null
                            ? Container(
                                padding: const EdgeInsets.all(
                                    Dimensions.paddingSizeSmall),
                                decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(5),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Theme.of(context)
                                              .hintColor
                                              .withOpacity(.1),
                                          blurRadius: 3,
                                          spreadRadius: 3)
                                    ]),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        CustomImage(
                                            image: '', width: 20, height: 20),
                                        const SizedBox(
                                          width: Dimensions.paddingSizeSmall,
                                        ),
                                        Text(filtered()[index].displayName),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: Dimensions.paddingSizeExtraSmall,
                                    ),
                                    Text(filtered()[index].phones[0].number),
                                    const SizedBox(
                                      height: Dimensions.paddingSizeDefault,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SizedBox(
                                          width: 90,
                                          child: CustomButton(
                                            buttonText: 'Add',
                                            icon: Icons.person_add,
                                            onPressed: () {},
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )
                            // ListTile(
                            //         dense: true,
                            //         contentPadding: const EdgeInsets.all(0),
                            //         leading: const Icon(Icons.contacts_outlined),
                            //         title: Text(filtered()[index].displayName),
                            //         subtitle: Text(filtered()[index].phones[0]),
                            //       )
                            : _AppUserContact(
                                user: user, contact: filtered()[index]);
                      },
                    ),
            ),
          ],
        );
      }),
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
      subtitle: Text(contact.phones[0].number),
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
