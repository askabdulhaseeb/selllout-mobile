import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../../../database/auth_methods.dart';
import '../../../enums/chat/message_tabbar_enum.dart';
import '../../../functions/user_bottom_sheets.dart';
import '../../../models/app_user.dart';
import '../../../providers/chat/chat_page_provider.dart';
import '../../../providers/user/user_provider.dart';
import '../../../widgets/chat/chat_person_search.dart';
import '../../chat_screens/group_chat_page/create_group_screen.dart';
import '../../chat_screens/group_chat_page/group_chat_dashboard.dart';
import '../../chat_screens/personal_chat_page/personal_chat_dashboard.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ChatPageProvider page = Provider.of<ChatPageProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Messenger',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: <Widget>[
                ChatPersonSearch(
                  onChanged: (String? value) {},
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: () {
                    if (page.currentTab == MessageTabBarEnum.chat) {
                      final List<AppUser> suppters =
                          Provider.of<UserProvider>(context, listen: false)
                              .supporters(uid: AuthMethods.uid);
                      UserBottomSheets().showNewChatPersons(
                        context: context,
                        users: suppters,
                      );
                    } else if (page.currentTab == MessageTabBarEnum.group) {
                      Navigator.of(context)
                          .pushNamed(CreateChatGroupScreen.routeName);
                    }
                    // else {
                    //   Navigator.of(context)
                    //       .pushNamed(AddMediaStoryScreen.routeName);
                    // }
                  },
                  splashRadius: 16,
                  padding: const EdgeInsets.all(0),
                  icon: const Icon(Icons.forum_rounded),
                ),
              ],
            ),
          ),
          _TabBar(page: page),
          Expanded(
            child: (page.currentTab == MessageTabBarEnum.chat)
                ? const PersonalChatDashboard()
                : const GroupChatDashboard(),
          ),
        ],
      ),
    );
  }
}

class _TabBar extends StatelessWidget {
  const _TabBar({required ChatPageProvider page, Key? key})
      : _page = page,
        super(key: key);

  final ChatPageProvider _page;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          TabBarIconButton(
            icon: Icons.perm_contact_cal,
            title: 'Chats',
            isSelected: _page.currentTab == MessageTabBarEnum.chat,
            onTab: () {
              _page.updateTab(MessageTabBarEnum.chat);
            },
          ),
          const SizedBox(width: 50),
          TabBarIconButton(
            icon: Icons.groups_rounded,
            title: 'Groups',
            isSelected: _page.currentTab == MessageTabBarEnum.group,
            onTab: () {
              _page.updateTab(MessageTabBarEnum.group);
            },
          ),
          // TabBarIconButton(
          //   icon: Icons.blur_circular_sharp,
          //   title: 'Stories',
          //   isSelected: _page.currentTab == MessageTabBarEnum.story,
          //   onTab: () {
          //     _page.updateTab(MessageTabBarEnum.story);
          //   },
          // ),
        ],
      ),
    );
  }
}

class TabBarIconButton extends StatelessWidget {
  const TabBarIconButton({
    required this.onTab,
    required this.icon,
    required this.title,
    this.isSelected = false,
    Key? key,
  }) : super(key: key);
  final bool isSelected;
  final IconData icon;
  final String title;
  final VoidCallback onTab;

  @override
  Widget build(BuildContext context) {
    final Color? color = isSelected
        ? Theme.of(context).primaryColor
        : Theme.of(context).iconTheme.color;
    return GestureDetector(
      onTap: onTab,
      child: Column(
        children: <Widget>[
          Icon(icon, color: color),
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }
}
